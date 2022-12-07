<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="./style.css">
    <%@ include file="header.jsp" %>
    <title>Customer Info</title>
</head>
<body>
<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
session = request.getSession(true);
if(userName != null){
	getConnection();
	con.setCatalog("orders");

	String custId = (String)request.getParameter("customerId");
	String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId"
		+	" FROM customer WHERE customerId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, custId);
	ResultSet rst = pstmt.executeQuery();
	out.print("<table border='1' width='400' cellspacing='8' cellpadding='5'>");
	if(rst.next()){
		out.println("<div><tr><td><b>Customer ID: </b></td><td>" + rst.getString("customerId") + "</td></tr></div>");
		out.println("<div><tr><td><b>Name: </b></td><td>" + rst.getString("firstName") + " " + rst.getString("lastName") + "</b></div>");
		out.println("<div><tr><td><b>Email: </b></td><td>" + rst.getString("email") + "</div>");
		out.println("<div><tr><td><b>Phone number: </b></td><td>" + rst.getString("phonenum") + "</div>");
		out.println("<div><tr><td><b>Address: </b></td><td>" + rst.getString("address") + "</div>");
		out.println("<div><tr><td><b>City: </b></td><td>" + rst.getString("city") + "</div>");
		out.println("<div><tr><td><b>State: </b></td><td>" + rst.getString("state") + "</div>");
		out.println("<div><tr><td><b>Postal Code: </b></td><td>" + rst.getString("postalCode") + "</div>");
		out.println("<div><tr><td><b>Country: </b></td><td>" + rst.getString("country") + "</div>");
		out.println("<div><tr><td><b>User ID: </b></td><td>" + rst.getString("userId") + "</div>");
	}
	out.print("</table>");

	// Make sure to close connection
	closeConnection();
} else {
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>
</body>
</html>

