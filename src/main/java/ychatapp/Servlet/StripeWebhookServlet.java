package ychatapp.Servlet;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HexFormat;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
@WebServlet("/StripeWebhookServlet")
public class StripeWebhookServlet extends HttpServlet {
 protected void doPost(HttpServletRequest req,HttpServletResponse res)throws IOException{
  String secret=System.getenv("STRIPE_WEBHOOK_SECRET"); String signature=req.getHeader("Stripe-Signature");
  if(secret==null||secret.isBlank()||signature==null){res.sendError(400);return;}
  byte[] raw=req.getInputStream().readNBytes(1_048_577); if(raw.length>1_048_576){res.sendError(413);return;}
  String payload=new String(raw,StandardCharsets.UTF_8);
  if(!validSignature(payload,signature,secret)){res.sendError(400);return;}
  try{
   JsonObject event=JsonParser.parseString(payload).getAsJsonObject(); String type=event.get("type").getAsString();
   if("checkout.session.completed".equals(type)||"checkout.session.async_payment_succeeded".equals(type)){
    JsonObject session=event.getAsJsonObject("data").getAsJsonObject("object");
    if(session.has("payment_status")&&"paid".equals(session.get("payment_status").getAsString())&&!PaymentServlet.settlePaidSession(session,0)){res.sendError(500);return;}
   }
   res.setStatus(200);res.setContentType("text/plain");res.getWriter().write("ok");
  }catch(Exception e){getServletContext().log("Stripe webhook processing failed",e);res.sendError(400);}
 }
 static boolean validSignature(String payload,String header,String secret){
  try{String timestamp=null;for(String item:header.split(",")){String[] pair=item.split("=",2);if(pair.length==2&&"t".equals(pair[0]))timestamp=pair[1];}
   if(timestamp==null)return false;boolean match=false;long ts=Long.parseLong(timestamp);if(Math.abs(System.currentTimeMillis()/1000L-ts)>300)return false;
   Mac mac=Mac.getInstance("HmacSHA256");mac.init(new SecretKeySpec(secret.getBytes(StandardCharsets.UTF_8),"HmacSHA256"));String digest=HexFormat.of().formatHex(mac.doFinal((timestamp+"."+payload).getBytes(StandardCharsets.UTF_8)));
   for(String item:header.split(",")){String[] pair=item.split("=",2);if(pair.length==2&&"v1".equals(pair[0]))match|=MessageDigest.isEqual(digest.getBytes(StandardCharsets.US_ASCII),pair[1].getBytes(StandardCharsets.US_ASCII));}
   return match;
  }catch(Exception e){return false;}
 }
}
