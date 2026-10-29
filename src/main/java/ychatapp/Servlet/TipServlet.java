package ychatapp.Servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import ychatapp.model.beans.CreatorTipBean;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.CreatorTipDAO;
import ychatapp.model.dao.PaymentDAO;
import ychatapp.model.dao.UsersDAO;

@WebServlet("/TipServlet")
public class TipServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final CreatorTipDAO tipDAO = new CreatorTipDAO();
    private final UsersDAO usersDAO = new UsersDAO();
    private final PaymentDAO paymentDAO = new PaymentDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        handleRequest(request, response);
    }

    private void handleRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JsonObject json = new JsonObject();

        HttpSession session = request.getSession(false);
        UsersBeans currentUser = (session != null) ? (UsersBeans) session.getAttribute("ub") : null;

        if (currentUser == null) {
            json.addProperty("success", false);
            json.addProperty("message", "Please log in to continue.");
            out.print(gson.toJson(json));
            return;
        }

        String action = request.getParameter("action");
        if (action == null || action.trim().isEmpty()) {
            action = "sendTip";
        }

        try {
            switch (action) {
                case "sendTip": {
                    String receiverIdStr = request.getParameter("receiverId");
                    String amountStr = request.getParameter("amount");
                    String method = request.getParameter("method");
                    String note = request.getParameter("note");
                    String postIdStr = request.getParameter("postId");
                    String trxId = request.getParameter("trxId");

                    if (receiverIdStr == null || amountStr == null) {
                        json.addProperty("success", false);
                        json.addProperty("message", "Receiver and amount are required.");
                        out.print(gson.toJson(json));
                        return;
                    }

                    int receiverId = Integer.parseInt(receiverIdStr);
                    double amount = Double.parseDouble(amountStr);
                    Integer postId = (postIdStr != null && !postIdStr.trim().isEmpty()) ? Integer.parseInt(postIdStr) : null;
                    if (method == null || method.trim().isEmpty()) method = "WALLET";

                    if (receiverId == currentUser.getId()) {
                        json.addProperty("success", false);
                        json.addProperty("message", "You cannot send a tip to yourself.");
                        out.print(gson.toJson(json));
                        return;
                    }
                    if (amount <= 0) {
                        json.addProperty("success", false);
                        json.addProperty("message", "Tip amount must be greater than zero.");
                        out.print(gson.toJson(json));
                        return;
                    }

                    boolean ok = tipDAO.sendTip(currentUser.getId(), receiverId, postId, amount, method, trxId, note);
                    if (ok) {
                        double currentBalance = usersDAO.getBalance(currentUser.getId());
                        currentUser.setBalance(currentBalance);
                        session.setAttribute("ub", currentUser);

                        json.addProperty("success", true);
                        json.addProperty("message", "Tip of $" + String.format("%.2f", amount) + " sent successfully to creator!");
                        json.addProperty("newBalance", currentBalance);
                    } else {
                        json.addProperty("success", false);
                        json.addProperty("message", "Failed to send tip.");
                    }
                    break;
                }
                case "addBalance": {
                    json.addProperty("success", false);
                    json.addProperty("message", "Wallet top-ups must use secure Stripe Checkout. Please update the app and retry.");
                    break;
                }
                case "getStats": {
                    double myBalance = usersDAO.getBalance(currentUser.getId());
                    double totalTipsReceived = tipDAO.getTotalTipsReceived(currentUser.getId());
                    List<CreatorTipBean> tipsReceived = tipDAO.getTipsReceived(currentUser.getId());

                    currentUser.setBalance(myBalance);
                    session.setAttribute("ub", currentUser);

                    json.addProperty("success", true);
                    json.addProperty("balance", myBalance);
                    json.addProperty("totalTipsReceived", totalTipsReceived);
                    json.add("tips", gson.toJsonTree(tipsReceived));
                    break;
                }
                default:
                    json.addProperty("success", false);
                    json.addProperty("message", "Unknown action: " + action);
                    break;
            }
        } catch (IllegalStateException | IllegalArgumentException e) {
            json.addProperty("success", false);
            json.addProperty("message", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            json.addProperty("success", false);
            json.addProperty("message", "Server error: " + e.getMessage());
        }

        out.print(gson.toJson(json));
    }
}
