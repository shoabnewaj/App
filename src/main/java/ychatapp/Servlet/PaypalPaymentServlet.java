package ychatapp.Servlet;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.Locale;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.PaymentDAO;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/PaypalPaymentServlet")
public class PaypalPaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final HttpClient HTTP = HttpClient.newBuilder().connectTimeout(java.time.Duration.ofSeconds(10)).build();

    @Override protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        req.setCharacterEncoding("UTF-8");
        UsersBeans user = currentUser(req);
        if (user == null) { json(resp, 401, false, "Please sign in again.", null); return; }
        if (!"create".equals(req.getParameter("action"))) { json(resp, 400, false, "Unknown PayPal action.", null); return; }
        String clientId = System.getenv("PAYPAL_CLIENT_ID");
        String clientSecret = System.getenv("PAYPAL_CLIENT_SECRET");
        if (blank(clientId) || blank(clientSecret)) { json(resp, 503, false, "PayPal is not configured. Ask the administrator to configure PayPal.", null); return; }

        String purpose = req.getParameter("purpose");
        long amountMinor;
        try {
            if ("BLUE_TICK".equalsIgnoreCase(purpose)) { purpose = "BLUE_TICK"; amountMinor = 499L; }
            else if ("WALLET_TOPUP".equalsIgnoreCase(purpose)) {
                purpose = "WALLET_TOPUP";
                BigDecimal amount = new BigDecimal(req.getParameter("amount")).setScale(2, java.math.RoundingMode.UNNECESSARY);
                if (amount.compareTo(new BigDecimal("5.00")) < 0 || amount.compareTo(new BigDecimal("500.00")) > 0) throw new IllegalArgumentException("Wallet top-up must be between $5 and $500.");
                amountMinor = amount.movePointRight(2).longValueExact();
            } else throw new IllegalArgumentException("Unsupported payment purpose.");
        } catch (Exception e) { json(resp, 400, false, e.getMessage() == null ? "Invalid amount." : e.getMessage(), null); return; }

        try {
            String base = appBase(req);
            String customId = "ychat:" + user.getId() + ":" + purpose + ":" + amountMinor;
            JsonObject orderBody = new JsonObject();
            orderBody.addProperty("intent", "CAPTURE");
            JsonArray units = new JsonArray();
            JsonObject unit = new JsonObject();
            unit.addProperty("custom_id", customId);
            unit.addProperty("description", "BLUE_TICK".equals(purpose) ? "Y-Chat Verified Creator Badge" : "Y-Chat Wallet Top-up");
            JsonObject amount = new JsonObject(); amount.addProperty("currency_code", "USD"); amount.addProperty("value", BigDecimal.valueOf(amountMinor, 2).setScale(2).toPlainString());
            unit.add("amount", amount); units.add(unit); orderBody.add("purchase_units", units);
            JsonObject context = new JsonObject(); context.addProperty("return_url", base + "/PaypalPaymentServlet?action=capture"); context.addProperty("cancel_url", base + "/UsersPostServlet?payment=cancel"); context.addProperty("brand_name", "Y-ChatApp");
            orderBody.add("application_context", context);

            String accessToken = accessToken();
            HttpRequest request = HttpRequest.newBuilder(URI.create(apiBase() + "/v2/checkout/orders"))
                    .timeout(java.time.Duration.ofSeconds(25)).header("Authorization", "Bearer " + accessToken)
                    .header("Content-Type", "application/json").header("PayPal-Request-Id", java.util.UUID.randomUUID().toString())
                    .POST(HttpRequest.BodyPublishers.ofString(orderBody.toString())).build();
            HttpResponse<String> result = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            JsonObject order = JsonParser.parseString(result.body()).getAsJsonObject();
            if (result.statusCode() < 200 || result.statusCode() >= 300 || !order.has("links")) { json(resp, 502, false, "PayPal could not start checkout.", null); return; }
            String approve = null;
            for (var link : order.getAsJsonArray("links")) if ("approve".equals(link.getAsJsonObject().get("rel").getAsString())) approve = link.getAsJsonObject().get("href").getAsString();
            if (approve == null) { json(resp, 502, false, "PayPal did not return an approval link.", null); return; }
            json(resp, 200, true, "PayPal order created.", approve);
        } catch (Exception e) { getServletContext().log("PayPal order creation failed", e); json(resp, 502, false, "Could not start PayPal checkout.", null); }
    }

    @Override protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        if (!"capture".equals(req.getParameter("action"))) { resp.sendError(405); return; }
        UsersBeans user = currentUser(req);
        String orderId = req.getParameter("token");
        if (user == null) { resp.sendRedirect("UsersLoginServlet"); return; }
        if (blank(orderId) || !orderId.matches("[A-Za-z0-9-]{8,80}")) { resp.sendRedirect("UsersPostServlet?payment=failed"); return; }
        try {
            HttpRequest request = HttpRequest.newBuilder(URI.create(apiBase() + "/v2/checkout/orders/" + orderId + "/capture"))
                    .timeout(java.time.Duration.ofSeconds(25)).header("Authorization", "Bearer " + accessToken())
                    .header("Content-Type", "application/json").header("PayPal-Request-Id", java.util.UUID.randomUUID().toString())
                    .POST(HttpRequest.BodyPublishers.ofString("{}")).build();
            HttpResponse<String> result = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
            if (result.statusCode() < 200 || result.statusCode() >= 300) { resp.sendRedirect("UsersPostServlet?payment=pending"); return; }
            JsonObject order = JsonParser.parseString(result.body()).getAsJsonObject();
            if (!"COMPLETED".equals(order.get("status").getAsString())) { resp.sendRedirect("UsersPostServlet?payment=pending"); return; }
            JsonObject unit = order.getAsJsonArray("purchase_units").get(0).getAsJsonObject();
            String[] meta = unit.get("custom_id").getAsString().split(":", -1);
            JsonObject capture = unit.getAsJsonObject("payments").getAsJsonArray("captures").get(0).getAsJsonObject();
            JsonObject paidAmount = capture.getAsJsonObject("amount");
            if (meta.length != 4 || !"ychat".equals(meta[0]) || Integer.parseInt(meta[1]) != user.getId() || !"COMPLETED".equals(capture.get("status").getAsString()) || !"USD".equals(paidAmount.get("currency_code").getAsString())) { resp.sendRedirect("UsersPostServlet?payment=failed"); return; }
            String purpose = meta[2]; long amountMinor = Long.parseLong(meta[3]);
            if (new BigDecimal(paidAmount.get("value").getAsString()).movePointRight(2).longValueExact() != amountMinor) { resp.sendRedirect("UsersPostServlet?payment=failed"); return; }
            if (!new PaymentDAO().recordProviderPayment(user.getId(), capture.get("id").getAsString(), "PAYPAL", purpose, amountMinor, "usd")) { resp.sendRedirect("UsersPostServlet?payment=pending"); return; }
            user.setBalance(new UsersDAO().getBalance(user.getId())); user.setIs_verified(new PaymentDAO().isUserVerified(user.getId()));
            HttpSession session = req.getSession(false); if (session != null) session.setAttribute("ub", user);
            resp.sendRedirect("UsersPostServlet?payment=success");
        } catch (Exception e) { getServletContext().log("PayPal capture failed", e); resp.sendRedirect("UsersPostServlet?payment=pending"); }
    }

    private String accessToken() throws Exception {
        String id = System.getenv("PAYPAL_CLIENT_ID"), secret = System.getenv("PAYPAL_CLIENT_SECRET");
        if (blank(id) || blank(secret)) throw new IllegalStateException("PayPal credentials are not configured");
        String basic = Base64.getEncoder().encodeToString((id + ":" + secret).getBytes(StandardCharsets.UTF_8));
        HttpRequest request = HttpRequest.newBuilder(URI.create(apiBase() + "/v1/oauth2/token")).timeout(java.time.Duration.ofSeconds(15))
                .header("Authorization", "Basic " + basic).header("Content-Type", "application/x-www-form-urlencoded")
                .POST(HttpRequest.BodyPublishers.ofString("grant_type=client_credentials")).build();
        HttpResponse<String> response = HTTP.send(request, HttpResponse.BodyHandlers.ofString());
        if (response.statusCode() < 200 || response.statusCode() >= 300) throw new IOException("PayPal OAuth failed with HTTP " + response.statusCode());
        return JsonParser.parseString(response.body()).getAsJsonObject().get("access_token").getAsString();
    }
    private static String apiBase() { return "live".equalsIgnoreCase(System.getenv("PAYPAL_ENVIRONMENT")) ? "https://api-m.paypal.com" : "https://api-m.sandbox.paypal.com"; }
    private static String appBase(HttpServletRequest req) { String configured = System.getenv("APP_BASE_URL"); return (blank(configured) ? req.getScheme() + "://" + req.getServerName() + (req.getServerPort() == 80 || req.getServerPort() == 443 ? "" : ":" + req.getServerPort()) + req.getContextPath() : configured).replaceAll("/+$", ""); }
    private static UsersBeans currentUser(HttpServletRequest req) { HttpSession session = req.getSession(false); return session == null ? null : (UsersBeans) session.getAttribute("ub"); }
    private static boolean blank(String s) { return s == null || s.isBlank(); }
    private static void json(HttpServletResponse resp, int status, boolean ok, String message, String url) throws IOException { resp.setStatus(status); resp.setContentType("application/json;charset=UTF-8"); JsonObject out = new JsonObject(); out.addProperty("status", ok ? "success" : "error"); out.addProperty("message", message); if (url != null) out.addProperty("checkoutUrl", url); resp.getWriter().write(out.toString()); }
}