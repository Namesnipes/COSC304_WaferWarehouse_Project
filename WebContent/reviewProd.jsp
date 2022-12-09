<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<link rel="stylesheet" href="./style.css">
<title>Review Product</title>
</head>
<body>
<%@ include file="header.jsp" %>

<h1 align="center">Write a Review: </h3>

<%
getConnection();
con.setCatalog("orders");

// get info from url
String productId = request.getParameter("id");
out.print("<form method=\"get\" action=\"addReview.jsp\" size=\"200\">" +
    "<input type=\"hidden\" name=\"id\" value="+productId+">" +
    "<label>Review: </label><br><textarea type=\"text\" name=\"productReview\" size=\"200\"></textarea><br>" +
    "<input type=\"submit\" value=\"Submit\"><input type=\"reset\" value=\"Reset\">" +
    "<br>" +
    "</form>");

%>

</div>
</body>
</html>
