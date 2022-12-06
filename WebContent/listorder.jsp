<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./style.css">
<title>Wacky Wafer Warehouse Order List</title>
</head>
<body>
<%@ include file="header.jsp" %>
<h1>Order List</h1>
<pre>
<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Make connection

try
{
	getConnection();

	// Set database to 'orders'

	con.setCatalog("orders");
	
		// Useful code for formatting currency values:
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
		// Example: out.println(currFormat.format(5.0);  // Prints $5.00	

	// Write query to retrieve all order summary records

	String sql = "SELECT * FROM ordersummary O JOIN customer C ON O.customerId = C.customerId";
	Statement stmt = con.createStatement();
	out.println("<table border='1' width='300' cellspacing='10' cellpadding='5'><tr style='background-color:rgb(18, 112, 84);color:rgb(66, 28, 14)'><th>Order Id</th><th>Customer Id</th><th>Customer Name</th><th>Total Amount</th></tr>");
	ResultSet rst = stmt.executeQuery(sql);

	// Query to retrieve product info from each order

	String sql2 = "SELECT OP.productId AS 'Product ID', quantity AS 'Quantity', productPrice AS 'Price' FROM orderProduct OP JOIN product P ON OP.productId = P.productId WHERE orderId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql2);

	while(rst.next()) {
		String orderId = rst.getString("orderId");
		String customerId = rst.getString("customerId");
		String name = rst.getString("firstName")+" "+rst.getString("lastName");
		String total = currFormat.format(rst.getDouble("totalAmount"));


		out.println("<table border='3' width='300' cellspacing='5' cellpadding='2'>"
						+"<tr><td><th>"+orderId+"</th></td>"
						+"<td><th>"+customerId+"</th></td>"
						+"<td><th>"+name+"</th></td>"
						+"<td><th>"+total+"</th></td></tr>"
						+"</table>");

		pstmt.setInt(1, Integer.parseInt(orderId));
		ResultSet rst2 = pstmt.executeQuery();
		
		out.println("\tProduct ID"+"\t"+"Quantity"+"\t"+"Price");

		while(rst2.next()) {
			String price = currFormat.format(rst2.getDouble("Price"));

			out.println("\t"+ rst2.getString("Product ID")+"\t\t"
			+ rst2.getString("Quantity")+"\t\t"
			+ price);
		}
		out.println("</table>");
	}

	// For each order in the ResultSet

		// Print out the order summary information
		// Write a query to retrieve the products in the order
		//   - Use a PreparedStatement as will repeat this query many times
		// For each product in the order
			// Write out product information 

}
catch (SQLException ex)
{
	out.println(ex);
}

// Close Connection

closeConnection();

%>
</pre>
</body>
</html>

