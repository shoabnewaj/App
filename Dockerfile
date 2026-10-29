# Stage 1: Build the WAR file using Maven and JDK 21
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app
COPY pom.xml .
COPY src ./src

# Package the application skipping tests for faster builds
RUN mvn clean package -DskipTests

# Stage 2: Run the WAR file in Tomcat 10.1 (Jakarta EE 10 compatible) with JDK 21
FROM tomcat:10.1-jdk21-temurin

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the built WAR file from the builder stage to Tomcat's webapps directory as ROOT.war
COPY --from=builder /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

# Remove embedded tomcat jars from inside ROOT.war if present so standalone Tomcat 10.1 starts cleanly
RUN mkdir -p /tmp/war_fix && cd /tmp/war_fix && jar -xf /usr/local/tomcat/webapps/ROOT.war && \
    rm -f WEB-INF/lib/tomcat-embed-*.jar WEB-INF/lib/ecj-*.jar && \
    jar -cf /usr/local/tomcat/webapps/ROOT.war . && rm -rf /tmp/war_fix

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]