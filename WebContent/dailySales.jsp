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
    <%@ include file="header.jsp" %>
    <title>Daily Sales</title>
</head>
<body>

<%
// TODO: Write SQL query that prints out total order amount by day
try{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String sql = "SELECT orderDate, SUM(totalAmount) AS 'Daily Total' FROM ordersummary GROUP BY orderDate ORDER BY orderDate ASC";
    getConnection();
    con.setCatalog("orders");
    PreparedStatement stmt = con.prepareStatement(sql);
    ResultSet rst = stmt.executeQuery();
    out.println("<div><table border='1' width='300' cellspacing='10' cellpadding='5'><tr style='background-color:rgb(18, 112, 84);color:rgb(66, 28, 14)'><th>Order Date</th><th>Total Order Amount</th></tr>");
    while(rst.next()){
        String dateStr = rst.getString("orderDate").split(" ")[0];
        String amount = currFormat.format(rst.getDouble("Daily Total"));

        out.print("<tr><td>"+dateStr+"</td><td>"+amount+"</td></tr>"); 
        out.print("</div>");
    }
    out.print("</table>");
} catch(SQLException e){
    out.println(e);
} finally{
    closeConnection();
}

%>