<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ page import="ychatapp.model.beans.UsersBeans" %>
<html>
<head>
    <title>Session Debugger</title>
</head>
<body style="font-family: sans-serif; padding: 20px;">
    <h1>Session & Cookie Status</h1>
    <%
        HttpSession sessionObj = request.getSession(false);
        UsersBeans ub = (sessionObj != null) ? (UsersBeans) sessionObj.getAttribute("ub") : null;
        Integer userId = (sessionObj != null) ? (Integer) sessionObj.getAttribute("userId") : null;
    %>
    <h3>Session Details:</h3>
    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>Property</th>
            <th>Value</th>
        </tr>
        <tr>
            <td>Session Exists</td>
            <td><%= (sessionObj != null) %></td>
        </tr>
        <% if (sessionObj != null) { %>
        <tr>
            <td>Session ID</td>
            <td><%= sessionObj.getId() %></td>
        </tr>
        <tr>
            <td>Creation Time</td>
            <td><%= new java.util.Date(sessionObj.getCreationTime()) %></td>
        </tr>
        <tr>
            <td>Last Accessed Time</td>
            <td><%= new java.util.Date(sessionObj.getLastAccessedTime()) %></td>
        </tr>
        <tr>
            <td>Max Inactive Interval (seconds)</td>
            <td><%= sessionObj.getMaxInactiveInterval() %></td>
        </tr>
        <tr>
            <td>ub attribute (User Bean)</td>
            <td><%= (ub == null ? "null" : ub.getName() + " (ID: " + ub.getId() + ", Email: " + ub.getEmail() + ")") %></td>
        </tr>
        <tr>
            <td>userId attribute</td>
            <td><%= userId %></td>
        </tr>
        <% } %>
    </table>

    <h3>Cookies Received in Request:</h3>
    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>Cookie Name</th>
            <th>Cookie Value</th>
            <th>Domain</th>
            <th>Path</th>
            <th>Max Age</th>
            <th>Secure</th>
            <th>HttpOnly</th>
        </tr>
        <%
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
        %>
        <tr>
            <td><%= cookie.getName() %></td>
            <td><%= cookie.getValue() %></td>
            <td><%= cookie.getDomain() %></td>
            <td><%= cookie.getPath() %></td>
            <td><%= cookie.getMaxAge() %></td>
            <td><%= cookie.getSecure() %></td>
            <td><%= cookie.isHttpOnly() %></td>
        </tr>
        <%
                }
            } else {
        %>
        <tr>
            <td colspan="7" style="text-align: center; color: gray;">No cookies found</td>
        </tr>
        <%
            }
        %>
    </table>

    <h3>Request Information:</h3>
    <ul>
        <li>Request URL: <%= request.getRequestURL() %></li>
        <li>Context Path: <%= request.getContextPath() %></li>
        <li>Scheme: <%= request.getScheme() %></li>
        <li>Server Name: <%= request.getServerName() %></li>
        <li>Server Port: <%= request.getServerPort() %></li>
        <li>Secure Request: <%= request.isSecure() %></li>
    </ul>
</body>
</html>