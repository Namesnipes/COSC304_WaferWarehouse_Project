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

out.print("<form method=\"get\" action=\"reviewProd.jsp\" size=\"200\">" +
    "<input type=\"hidden\" name=\"id\">" +
    "<label>Review: </label><input type=\"text\" name=\"productReview\" size=\"50\"><br>" +
    "<input type=\"submit\" value=\"Submit\"><input type=\"reset\" value=\"Reset\">" +
    "<br>" +
    "</form>");

    try{
        String newReview = request.getParameter("productReview");

        if(newReview == null)
        return;

        String sql = "UPDATE product SET productReview = ? WHERE productId = ?";

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, newReview);
        pstmt.setString(2, productId);

        pstmt.executeUpdate();

    } catch(Exception e){
        out.print(e);
    }
%>


</div>
</body>
</html>
