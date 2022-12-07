<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="auth.jsp"%>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="./style.css">
    <%@ include file="header.jsp" %>
    <title>Customer List</title>
</head>
<body>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<% 
session = request.getSession(true);
if(userName != null){
    try{
        getConnection();
        con.setCatalog("orders");
        
        NumberFormat currFormat = NumberFormat.getCurrencyInstance();
        String sql = "SELECT customerId, firstName, lastName FROM customer;";
        PreparedStatement stmt = con.prepareStatement(sql);
        ResultSet rst = stmt.executeQuery();

        out.print("<table border='1' width='300' cellspacing='8' cellpadding='8'><tr style='background-color:rgb(18, 112, 84);color:rgb(66, 28, 14)'><th><b>Customer ID</b></th><th><b>Name</b></th></tr>");
        while(rst.next()) {
            String id = rst.getString("customerId");
            String name = rst.getString("firstName") + " " + rst.getString("lastName");
            out.print("<tr><td>"+id+"</td><td><a href=\"customer.jsp?customerId="+id+"\">"+name+"</a></td></tr>");
        }
    } catch(SQLException e){
    out.println(e);
    }
} else {
    return;
}
%>