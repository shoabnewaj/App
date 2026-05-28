package com.ychat;

import java.io.File;
import org.apache.catalina.Context;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;
import org.apache.catalina.startup.Tomcat;

public class Main {
    public static void main(String[] args) throws Exception {
        // Enable detailed logging
        java.util.logging.Handler[] handlers = java.util.logging.Logger.getLogger("").getHandlers();
        for (java.util.logging.Handler handler : handlers) {
            handler.setLevel(java.util.logging.Level.FINE);
        }
        java.util.logging.Logger.getLogger("org.apache.catalina").setLevel(java.util.logging.Level.FINE);

        // Port detection for Railway
        String webPort = System.getenv("PORT");
        if (webPort == null || webPort.isEmpty()) {
            webPort = "8080";
        }

        Tomcat tomcat = new Tomcat();
        tomcat.setPort(Integer.parseInt(webPort));
        
        // Bind to all interfaces to avoid 502 errors
        tomcat.getConnector().setProperty("address", "0.0.0.0");

        // JSP and static file path configuration
        String webappDirLocation = "src/main/webapp/";
        File webappDir = new File(webappDirLocation);
        
        if (!webappDir.exists()) {
            webappDirLocation = "."; // Fallback for Railway environment root
        }

        Context ctx = tomcat.addWebapp("/", new File(webappDirLocation).getAbsolutePath());
        ctx.setParentClassLoader(Main.class.getClassLoader());
        
        // Configure Tomcat to scan target/classes for annotations
        File additionWebInfClasses = new File("target/classes");
        System.out.println("DEBUG: additionWebInfClasses absolute path is: " + additionWebInfClasses.getAbsolutePath());
        System.out.println("DEBUG: additionWebInfClasses exists: " + additionWebInfClasses.exists());
        
        if (additionWebInfClasses.exists()) {
            System.out.println("DEBUG: target/classes directory has contents: " + java.util.Arrays.toString(additionWebInfClasses.list()));
            WebResourceRoot resources = new StandardRoot(ctx);
            resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                    additionWebInfClasses.getAbsolutePath(), "/"));
            ctx.setResources(resources);
        } else {
            System.out.println("WARNING: additionWebInfClasses does not exist! Running directory: " + new File(".").getAbsolutePath());
        }

        // Enable JarScanner to scan all directories and classpath for annotations
        if (ctx.getJarScanner() instanceof org.apache.tomcat.util.scan.StandardJarScanner) {
            org.apache.tomcat.util.scan.StandardJarScanner jarScanner = 
                (org.apache.tomcat.util.scan.StandardJarScanner) ctx.getJarScanner();
            jarScanner.setScanAllDirectories(true);
            jarScanner.setScanClassPath(true);
        }

        System.out.println("Starting Tomcat on port: " + webPort);

        tomcat.start();
        tomcat.getServer().await();
    }
}
