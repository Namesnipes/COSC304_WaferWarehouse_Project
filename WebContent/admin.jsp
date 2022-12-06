<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="./style.css">
    <title>Administrator Page</title>
</head>
<body>
<%@ include file="header.jsp" %>
<h3 align="center">Admin Menu</h3>

<h2 align="center"><a href="dailySales.jsp">Daily Sales</a></h2>

</body>
</html>

