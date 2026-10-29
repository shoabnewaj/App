package ychatapp.model.bo;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;
import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class EmailService {
    private static Properties mailProps = new Properties();
    private static boolean configLoaded = false;

    static {
        loadConfig();
    }

    private static void loadConfig() {
        // Try to load from project root first
        File rootFile = new File("email.properties");
        if (rootFile.exists()) {
            try (InputStream is = new FileInputStream(rootFile)) {
                mailProps.load(is);
                configLoaded = true;
                System.out.println("Email configuration loaded from project root email.properties.");
            } catch (Exception e) {
                System.err.println("Error loading email.properties from root: " + e.getMessage());
            }
        }
        
        // If not loaded, try classpath resource
        if (!configLoaded) {
            try (InputStream is = EmailService.class.getResourceAsStream("/email.properties")) {
                if (is != null) {
                    mailProps.load(is);
                    configLoaded = true;
                    System.out.println("Email configuration loaded from classpath /email.properties.");
                }
            } catch (Exception e) {
                System.err.println("Error loading email.properties from classpath: " + e.getMessage());
            }
        }

        // Apply defaults if missing
        if (mailProps.getProperty("smtp.host") == null) mailProps.setProperty("smtp.host", "smtp.gmail.com");
        if (mailProps.getProperty("smtp.port") == null) mailProps.setProperty("smtp.port", "587");
        if (mailProps.getProperty("smtp.auth") == null) mailProps.setProperty("smtp.auth", "true");
        if (mailProps.getProperty("smtp.starttls") == null) mailProps.setProperty("smtp.starttls", "true");
    }

    public static boolean sendVerificationEmail(String recipientEmail, String username, String code) {
        String host = mailProps.getProperty("smtp.host");
        String port = mailProps.getProperty("smtp.port");
        String usernameConfig = mailProps.getProperty("smtp.username");
        String passwordConfig = mailProps.getProperty("smtp.password");
        String auth = mailProps.getProperty("smtp.auth");
        String starttls = mailProps.getProperty("smtp.starttls");

        // Log the verification code to console for development bypass
        System.out.println("=================================================");
        System.out.println("[Y-Chat Verification System]");
        System.out.println("To: " + recipientEmail + " (" + username + ")");
        System.out.println("Verification Code: " + code);
        System.out.println("=================================================");

        if (usernameConfig == null || usernameConfig.trim().isEmpty() ||
            passwordConfig == null || passwordConfig.trim().isEmpty()) {
            System.out.println("[WARN] SMTP username/password not configured in email.properties. Falling back to console verification code.");
            return false; // Tells the servlet that real email sending was bypassed
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", auth);
            props.put("mail.smtp.starttls.enable", starttls);
            props.put("mail.smtp.connectiontimeout", "4000"); // 4 seconds connection timeout
            props.put("mail.smtp.timeout", "4000");           // 4 seconds read timeout

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(usernameConfig, passwordConfig);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(usernameConfig, "Y-ChatApp Security"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("Y-ChatApp Password Reset Verification Code");
            
            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 20px; border: 1px solid #e2e8f0; border-radius: 12px;'>"
                    + "<h2 style='color: #2563eb;'>Y-ChatApp Password Recovery</h2>"
                    + "<p>Hello <strong>" + username + "</strong>,</p>"
                    + "<p>We received a request to reset your password. Use the verification code below to proceed:</p>"
                    + "<div style='background-color: #f1f5f9; padding: 15px; text-align: center; font-size: 24px; font-weight: bold; letter-spacing: 5px; color: #1e293b; border-radius: 8px; margin: 20px 0;'>"
                    + code + "</div>"
                    + "<p style='color: #64748b; font-size: 13px;'>This code is valid for 5 minutes. If you did not make this request, you can safely ignore this email.</p>"
                    + "<hr style='border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;'>"
                    + "<p style='font-size: 11px; color: #94a3b8;'>Y-ChatApp Social Network Security Team</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Real verification email sent successfully to " + recipientEmail);
            return true;
        } catch (Exception e) {
            System.err.println("[ERROR] Failed to send real email to " + recipientEmail + ": " + e.getMessage());
            return false;
        }
    }

    public static boolean sendRegistrationConfirmationEmail(String recipientEmail, String username) {
        String host = mailProps.getProperty("smtp.host");
        String port = mailProps.getProperty("smtp.port");
        String usernameConfig = mailProps.getProperty("smtp.username");
        String passwordConfig = mailProps.getProperty("smtp.password");

        System.out.println("=================================================");
        System.out.println("[Y-Chat Registration Welcome System]");
        System.out.println("To: " + recipientEmail + " (" + username + ")");
        System.out.println("Status: Registration Confirmed & Account Activated!");
        System.out.println("=================================================");

        if (usernameConfig == null || usernameConfig.trim().isEmpty() ||
            passwordConfig == null || passwordConfig.trim().isEmpty()) {
            System.out.println("[WARN] SMTP username/password not configured in email.properties. Simulated registration confirmation email.");
            return false;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", mailProps.getProperty("smtp.auth", "true"));
            props.put("mail.smtp.starttls.enable", mailProps.getProperty("smtp.starttls", "true"));
            props.put("mail.smtp.connectiontimeout", "4000");
            props.put("mail.smtp.timeout", "4000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(usernameConfig, passwordConfig);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(usernameConfig, "Y-ChatApp Community"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("🎉 Welcome to Y-ChatApp! Registration Confirmed");
            
            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 25px; border: 1px solid #e2e8f0; border-radius: 16px; background-color: #ffffff;'>"
                    + "<h2 style='color: #0866FF; font-size: 24px; margin-bottom: 10px;'>🎉 Welcome to Y-ChatApp!</h2>"
                    + "<p style='font-size: 15px; color: #334155;'>Hello <strong>" + username + "</strong>,</p>"
                    + "<p style='font-size: 14px; color: #475569; leading-height: 1.6;'>Congratulations! Your Y-ChatApp account registration is confirmed and ready to use. You can now connect with friends, share stories, post reels, use our AI Assistant, and explore the marketplace.</p>"
                    + "<div style='background: linear-gradient(135deg, #0866FF, #00C6FF); padding: 15px; text-align: center; border-radius: 12px; margin: 25px 0;'>"
                    + "<a href='http://localhost:8080/ychatApp/UsersLoginServlet' style='color: #ffffff; text-decoration: none; font-weight: bold; font-size: 16px;'>Go to Y-ChatApp Login</a>"
                    + "</div>"
                    + "<p style='color: #64748b; font-size: 13px;'>If you did not create an account on Y-ChatApp, please contact our support team immediately.</p>"
                    + "<hr style='border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;'>"
                    + "<p style='font-size: 11px; color: #94a3b8;'>© Y-ChatApp Social Platform Team. All rights reserved.</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Registration confirmation email sent to " + recipientEmail);
            return true;
        } catch (Exception e) {
            System.err.println("[ERROR] Failed to send registration email: " + e.getMessage());
            return false;
        }
    }

    public static boolean sendPasswordChangeConfirmationEmail(String recipientEmail, String username) {
        String host = mailProps.getProperty("smtp.host");
        String port = mailProps.getProperty("smtp.port");
        String usernameConfig = mailProps.getProperty("smtp.username");
        String passwordConfig = mailProps.getProperty("smtp.password");

        System.out.println("=================================================");
        System.out.println("[Y-Chat Security Alert System]");
        System.out.println("To: " + recipientEmail + " (" + username + ")");
        System.out.println("Status: Password Changed Successfully!");
        System.out.println("=================================================");

        if (usernameConfig == null || usernameConfig.trim().isEmpty() ||
            passwordConfig == null || passwordConfig.trim().isEmpty()) {
            System.out.println("[WARN] SMTP username/password not configured in email.properties. Simulated password change confirmation email.");
            return false;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", host);
            props.put("mail.smtp.port", port);
            props.put("mail.smtp.auth", mailProps.getProperty("smtp.auth", "true"));
            props.put("mail.smtp.starttls.enable", mailProps.getProperty("smtp.starttls", "true"));
            props.put("mail.smtp.connectiontimeout", "4000");
            props.put("mail.smtp.timeout", "4000");

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(usernameConfig, passwordConfig);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(usernameConfig, "Y-ChatApp Security Team"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipientEmail));
            message.setSubject("🔒 Security Alert: Your Y-ChatApp Password Was Changed");
            
            String htmlContent = "<div style='font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 25px; border: 1px solid #e2e8f0; border-radius: 16px; background-color: #ffffff;'>"
                    + "<h2 style='color: #dc2626; font-size: 22px; margin-bottom: 10px;'>🔒 Security Alert: Password Updated</h2>"
                    + "<p style='font-size: 15px; color: #334155;'>Hello <strong>" + username + "</strong>,</p>"
                    + "<p style='font-size: 14px; color: #475569; leading-height: 1.6;'>This email confirms that your Y-ChatApp account password was changed successfully.</p>"
                    + "<div style='background-color: #fef2f2; border: 1px solid #fecaca; padding: 15px; border-radius: 12px; margin: 20px 0; color: #991b1b; font-size: 13px;'>"
                    + "<strong>Did not request this change?</strong><br>If you did not update your password, please reset your password immediately or contact Y-ChatApp Support."
                    + "</div>"
                    + "<hr style='border: 0; border-top: 1px solid #e2e8f0; margin: 20px 0;'>"
                    + "<p style='font-size: 11px; color: #94a3b8;'>Y-ChatApp Social Network Security Team</p>"
                    + "</div>";

            message.setContent(htmlContent, "text/html; charset=utf-8");
            Transport.send(message);
            System.out.println("Password change confirmation email sent to " + recipientEmail);
            return true;
        } catch (Exception e) {
            System.err.println("[ERROR] Failed to send password change email: " + e.getMessage());
            return false;
        }
    }
}
