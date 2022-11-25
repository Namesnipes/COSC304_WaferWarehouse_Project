<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
getConnection();
con.setCatalog("orders");

// TODO: Print Customer information
String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId"
	+	" FROM customer WHERE userId = ? AND password = ?";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1, userName);
ResultSet rst = pstmt.executeQuery();

// Make sure to close connection
closeConnection();
%>

</body>
</html>

