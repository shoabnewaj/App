package ychatapp.Servlet;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import ychatapp.model.dao.PostDAO;
@WebListener
public class ScheduledPostPublisher implements ServletContextListener {
 private ScheduledExecutorService executor;
 @Override public void contextInitialized(ServletContextEvent event) {
  executor=Executors.newSingleThreadScheduledExecutor(r->{Thread t=new Thread(r,"ychat-scheduled-posts");t.setDaemon(true);return t;});
  executor.scheduleWithFixedDelay(()->new PostDAO().publishDuePosts(),0,1,TimeUnit.MINUTES);
 }
 @Override public void contextDestroyed(ServletContextEvent event){if(executor!=null)executor.shutdownNow();}
}
