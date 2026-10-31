package ychatapp.Servlet;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/UsersLogoutServlet")
public class UsersLogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public UsersLogoutServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		// ====== Remember Me cookies を削除 ======
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
		    for (Cookie c : cookies) {
		        if ("rem_email".equals(c.getName()) || "rem_pass".equals(c.getName()) || "rem_token".equals(c.getName())) {
		            Cookie c1 = new Cookie(c.getName(), "");
		            c1.setMaxAge(0);
		            c1.setPath("/");
		            response.addCookie(c1);

		            String ctxPath = request.getContextPath();
		            if (ctxPath != null && !ctxPath.isEmpty() && !"/".equals(ctxPath)) {
		                Cookie c2 = new Cookie(c.getName(), "");
		                c2.setMaxAge(0);
		                c2.setPath(ctxPath);
		                response.addCookie(c2);
		            }
		        }
		    }
		}

		// session を破棄
		HttpSession session = request.getSession(false);
		if (session != null) {
		    session.invalidate();
		}

		// Logout メッセージをリクエストスコープにset
		request.setAttribute("logoutMsg",
		        "<p style=\"color:red\">※ ログアウトしました</p>");

		// ログイン画面にforward
		RequestDispatcher rd =
		        request.getRequestDispatcher("/WEB-INF/jsp/login.jsp");
		rd.forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	}

}
