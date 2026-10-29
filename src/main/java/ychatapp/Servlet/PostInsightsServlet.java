package ychatapp.Servlet;

import java.io.IOException;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.PostDAO;

@WebServlet("/PostInsightsServlet")
public class PostInsightsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    @Override protected void doGet(HttpServletRequest req, HttpServletResponse res) throws IOException {
        HttpSession session=req.getSession(false);
        UsersBeans user=session==null?null:(UsersBeans)session.getAttribute("ub");
        res.setContentType("application/json;charset=UTF-8");
        if(user==null){res.setStatus(401);res.getWriter().write("{\"success\":false}");return;}
        try {
            int postId=Integer.parseInt(req.getParameter("postId"));
            JsonArray viewers=new JsonArray();
            for(String name:new PostDAO().getTodayPostViewers(postId,user.getId())) viewers.add(name);
            JsonObject out=new JsonObject(); out.addProperty("success",true); out.addProperty("period","today"); out.addProperty("uniqueViewers",viewers.size()); out.add("viewers",viewers);
            res.getWriter().write(out.toString());
        } catch(Exception e){res.setStatus(400);res.getWriter().write("{\"success\":false}");}
    }
}
