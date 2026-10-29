package ychatapp.Servlet;
import java.io.IOException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ychatapp.model.beans.UsersBeans;
import ychatapp.model.dao.PostDAO;
@WebServlet("/PostViewServlet")
public class PostViewServlet extends HttpServlet {
    private static final long serialVersionUID=1L;
    @Override protected void doPost(HttpServletRequest req,HttpServletResponse res)throws IOException{
        HttpSession s=req.getSession(false);UsersBeans u=s==null?null:(UsersBeans)s.getAttribute("ub");res.setContentType("application/json;charset=UTF-8");
        if(u==null){res.setStatus(401);res.getWriter().write("{\"success\":false}");return;}
        try{int id=Integer.parseInt(req.getParameter("postId"));boolean ok=new PostDAO().recordPostView(id,u.getId());res.getWriter().write("{\"success\":"+ok+"}");}catch(Exception e){res.setStatus(400);res.getWriter().write("{\"success\":false}");}
    }
}
