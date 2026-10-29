package ychatapp.Servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.UUID;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.PaymentDAO;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final HttpClient HTTP = HttpClient.newBuilder().connectTimeout(java.time.Duration.ofSeconds(15)).build();

    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws IOException {
        res.setContentType("application/json;charset=UTF-8");
        res.setHeader("Cache-Control", "no-store");
        HttpSession session = req.getSession(false);
        UsersBeans user = session == null ? null : (UsersBeans) session.getAttribute("ub");
        if (user == null) { json(res, 401, false, "Please sign in again.", null); return; }
        if (!"checkout".equalsIgnoreCase(req.getParameter("action"))) { json(res, 400, false, "Unknown payment action.", null); return; }
        String secret = System.getenv("STRIPE_SECRET_KEY");
        if (secret == null || secret.isBlank()) { json(res, 503, false, "Online payment is not configured yet. Ask the administrator to configure Stripe.", null); return; }

        String purpose = req.getParameter("purpose");
        String currency;
        long amountMinor;
        try {
            if ("BLUE_TICK".equalsIgnoreCase(purpose)) {
                purpose = "BLUE_TICK"; currency = "usd"; amountMinor = 499L;
            } else if ("WALLET_TOPUP".equalsIgnoreCase(purpose)) {
                purpose = "WALLET_TOPUP"; currency = "usd";
                BigDecimal amount = new BigDecimal(req.getParameter("amount")).setScale(2, RoundingMode.UNNECESSARY);
                if (amount.compareTo(new BigDecimal("5.00")) < 0 || amount.compareTo(new BigDecimal("500.00")) > 0) throw new IllegalArgumentException("Wallet top-up must be between $5 and $500.");
                amountMinor = amount.movePointRight(2).longValueExact();
            } else { throw new IllegalArgumentException("Unsupported payment purpose."); }
        } catch (Exception e) { json(res, 400, false, e.getMessage() == null ? "Invalid amount." : e.getMessage(), null); return; }

        try {
            String base = System.getenv().getOrDefault("APP_BASE_URL", "http://localhost:8080/ychatApp").replaceAll("/+$", "");
            URI baseUri = URI.create(base);
            if (!("https".equalsIgnoreCase(baseUri.getScheme()) || "http".equalsIgnoreCase(baseUri.getScheme())) || baseUri.getHost() == null) throw new IllegalArgumentException("APP_BASE_URL must be a valid http(s) URL.");
            String product = "BLUE_TICK".equals(purpose) ? "Y-Chat Verified Creator Badge" : "Y-Chat Wallet Top-up";
            String success = base + "/PaymentServlet?result=success&session_id={CHECKOUT_SESSION_ID}";
            String cancel = base + "/UsersPostServlet?payment=cancel";
            Map<String,String> fields = new LinkedHashMap<>();
            fields.put("mode", "payment"); fields.put("success_url", success); fields.put("cancel_url", cancel);
            fields.put("adaptive_pricing[enabled]", "true");
            fields.put("client_reference_id", String.valueOf(user.getId()));
            fields.put("line_items[0][price_data][currency]", currency);
            fields.put("line_items[0][price_data][unit_amount]", String.valueOf(amountMinor));
            fields.put("line_items[0][price_data][product_data][name]", product);
            fields.put("line_items[0][quantity]", "1");
            fields.put("metadata[user_id]", String.valueOf(user.getId()));
            fields.put("metadata[purpose]", purpose);
            fields.put("metadata[amount_minor]", String.valueOf(amountMinor));
            fields.put("metadata[currency]", currency);
            StringBuilder body = new StringBuilder();
            for (Map.Entry<String,String> entry : fields.entrySet()) { if (body.length() > 0) body.append('&'); body.append(enc(entry.getKey())).append('=').append(enc(entry.getValue())); }
            String auth = Base64.getEncoder().encodeToString((secret + ":").getBytes(StandardCharsets.UTF_8));
            HttpRequest request = HttpRequest.newBuilder(URI.create("https://api.stripe.com/v1/checkout/sessions"))
                    .timeout(java.time.Duration.ofSeconds(25)).header("Authorization", "Basic " + auth)
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .header("Idempotency-Key", UUID.randomUUID().toString())
                    .POST(HttpRequest.BodyPublishers.ofString(body.toString())).build();
            HttpResponse<String> response = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            JsonObject stripe = JsonParser.parseString(response.body()).getAsJsonObject();
            if (response.statusCode() < 200 || response.statusCode() >= 300 || !stripe.has("url")) {
                String detail = stripe.has("error") && stripe.getAsJsonObject("error").has("message") ? stripe.getAsJsonObject("error").get("message").getAsString() : "Stripe could not start checkout.";
                json(res, 502, false, detail, null); return;
            }
            json(res, 200, true, "Checkout session created.", stripe.get("url").getAsString());
        } catch (Exception e) {
            getServletContext().log("Stripe checkout creation failed", e);
            json(res, 502, false, "Could not start secure checkout. Please try again.", null);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        String sessionId = req.getParameter("session_id");
        if ("success".equals(req.getParameter("result")) && sessionId != null && sessionId.startsWith("cs_")) {
            HttpSession session = req.getSession(false);
            UsersBeans user = session == null ? null : (UsersBeans) session.getAttribute("ub");
            if (user == null) { res.sendRedirect("UsersLoginServlet"); return; }
            if (completeStripeSession(sessionId, user.getId())) {
                user.setBalance(new ychatapp.model.dao.UsersDAO().getBalance(user.getId()));
                user.setIs_verified(new PaymentDAO().isUserVerified(user.getId()));
                session.setAttribute("ub", user);
                res.sendRedirect("UsersPostServlet?payment=success"); return;
            }
            res.sendRedirect("UsersPostServlet?payment=pending"); return;
        }
        res.sendError(405);
    }

    public static boolean completeStripeSession(String sessionId, int expectedUserId) {
        String secret = System.getenv("STRIPE_SECRET_KEY");
        if (secret == null || secret.isBlank() || sessionId == null || !sessionId.matches("cs_(test|live)_[A-Za-z0-9]+")) return false;
        try {
            String auth = Base64.getEncoder().encodeToString((secret + ":").getBytes(StandardCharsets.UTF_8));
            HttpRequest request = HttpRequest.newBuilder(URI.create("https://api.stripe.com/v1/checkout/sessions/" + sessionId))
                    .timeout(java.time.Duration.ofSeconds(20)).header("Authorization", "Basic " + auth).GET().build();
            HttpResponse<String> response = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            if (response.statusCode() < 200 || response.statusCode() >= 300) return false;
            JsonObject obj = JsonParser.parseString(response.body()).getAsJsonObject();
            return settlePaidSession(obj, expectedUserId);
        } catch (Exception e) { return false; }
    }

    public static boolean settlePaidSession(JsonObject obj, int expectedUserId) {
        try {
            if (!obj.has("payment_status") || !"paid".equals(obj.get("payment_status").getAsString())) return false;
            JsonObject meta = obj.getAsJsonObject("metadata");
            if (meta == null) return false;
            int userId = Integer.parseInt(meta.get("user_id").getAsString());
            String purpose = meta.get("purpose").getAsString();
            String currency = obj.get("currency").getAsString().toLowerCase();
            long total = obj.get("amount_total").getAsLong();
            long expectedAmount = Long.parseLong(meta.get("amount_minor").getAsString());
            String expectedCurrency = meta.get("currency").getAsString().toLowerCase();
            String id = obj.get("id").getAsString();
            boolean exactPresentment = total == expectedAmount && currency.equals(expectedCurrency);
            boolean validAdaptiveConversion = false;
            if (!exactPresentment && obj.has("currency_conversion") && !obj.get("currency_conversion").isJsonNull()) {
                JsonObject conversion = obj.getAsJsonObject("currency_conversion");
                validAdaptiveConversion = expectedCurrency.equalsIgnoreCase(conversion.get("source_currency").getAsString()) && expectedAmount == conversion.get("amount_total").getAsLong();
            }
            if (userId <= 0 || (expectedUserId > 0 && userId != expectedUserId) || !id.startsWith("cs_") || (!exactPresentment && !validAdaptiveConversion)) return false;
            if ("BLUE_TICK".equals(purpose) && (!"usd".equals(expectedCurrency) || expectedAmount != 499L)) return false;
            if ("WALLET_TOPUP".equals(purpose) && (!"usd".equals(expectedCurrency) || expectedAmount < 500L || expectedAmount > 50000L)) return false;
            if (!"BLUE_TICK".equals(purpose) && !"WALLET_TOPUP".equals(purpose)) return false;
            return new PaymentDAO().recordStripePayment(userId, id, purpose, expectedAmount, expectedCurrency);
        } catch (Exception e) { return false; }
    }

    private static String enc(String value) { return URLEncoder.encode(value, StandardCharsets.UTF_8); }
    private static void json(HttpServletResponse res, int status, boolean success, String message, String url) throws IOException {
        res.setStatus(status); JsonObject out = new JsonObject(); out.addProperty("status", success ? "success" : "error"); out.addProperty("message", message); if (url != null) out.addProperty("checkoutUrl", url); res.getWriter().write(out.toString());
    }
}
