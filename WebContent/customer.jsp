<%@ include file="auth.jsp"%>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
%>

<%
session = request.getSession(true);
if(userName != null){
	getConnection();
	con.setCatalog("orders");

	String sql = "SELECT customerId, firstName, lastName, email, phonenum, address, city, state, postalCode, country, userId"
		+	" FROM customer WHERE userId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setString(1, userName);
	ResultSet rst = pstmt.executeQuery();
	if(rst.next()){
		out.println("<div><b>Customer ID: </b>" + rst.getString("customerId") + "</div>");
		out.println("<div><b>Name: </b>" + rst.getString("firstName") + " " + rst.getString("lastName") + "</b></div>");
		out.println("<div><b>Email: </b>" + rst.getString("email") + "</div>");
		out.println("<div><b>Phone number: </b>" + rst.getString("phonenum") + "</div>");
		out.println("<div><b>Address: </b>" + rst.getString("address") + "</div>");
		out.println("<div><b>City: </b>" + rst.getString("city") + "</div>");
		out.println("<div><b>State: </b>" + rst.getString("state") + "</div>");
		out.println("<div><b>Postal Code: </b>" + rst.getString("postalCode") + "</div>");
		out.println("<div><b>Country: </b>" + rst.getString("country") + "</div>");
		out.println("<div><b>User ID: </b>" + rst.getString("userId") + "</div>");
	}

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

