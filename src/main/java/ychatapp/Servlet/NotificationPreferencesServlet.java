package ychatapp.Servlet;
import java.io.IOException;import jakarta.servlet.annotation.WebServlet;import jakarta.servlet.http.*;import ychatapp.model.beans.UsersBeans;import ychatapp.model.dao.NotificationPreferenceDAO;
@WebServlet("/NotificationPreferencesServlet") public class NotificationPreferencesServlet extends HttpServlet {
 protected void doPost(HttpServletRequest req,HttpServletResponse res)throws IOException{HttpSession s=req.getSession(false);UsersBeans u=s==null?null:(UsersBeans)s.getAttribute("ub");res.setContentType("application/json;charset=UTF-8");if(u==null){res.setStatus(401);res.getWriter().write("{\"success\":false}");return;}String category=req.getParameter("category");boolean enabled="true".equalsIgnoreCase(req.getParameter("enabled"));boolean ok=new NotificationPreferenceDAO().setEnabled(u.getId(),category,enabled);res.getWriter().write("{\"success\":"+ok+"}");}
}
