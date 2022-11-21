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
<h1 style="display: block;/*! */margin: 0;line-height: 50px;border: solid;/*! border-radius: 10px; */border-style: ridge;"> The Wacky Wafer Warehouse </h1>
<div class="header">
	<div class="buttonContainer">
		<a href = "listprod.jsp" class="b1"> Products </a>
		<a href = "listorder.jsp" class="b1"> Order List </a>
		<a href = "showcart.jsp" class="b1"> Shopping Cart </a>
	</div>
</div>
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
	out.println("<table border='4'><tr style='background-color:rgb(13, 238, 13);color:orangered'><td><th>Order Id</th></td><td><th>Customer Id</th></td><td><th>Customer Name</th></td><td><th>Total Amount</th></td></tr></table>");
	ResultSet rst = stmt.executeQuery(sql);

	// Query to retrieve product info from each order

	String sql2 = "SELECT OP.productId AS 'Product ID', quantity AS 'Quantity', productPrice AS 'Price' FROM orderProduct OP JOIN product P ON OP.productId = P.productId WHERE orderId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql2);

	while(rst.next()) {
		String orderId = rst.getString("orderId");
		String customerId = rst.getString("customerId");
		String name = rst.getString("firstName")+" "+rst.getString("lastName");
		String total = currFormat.format(rst.getDouble("totalAmount"));


		out.println("<table border='2'><tr><td><th>"+orderId
						+"\t</th></td><td><th>"+customerId
						+"\t</th></td><td><th>"+name
						+"\t</th></td><td><th>"+total
						+"</th></td></tr></table>");

		pstmt.setInt(1, Integer.parseInt(orderId));
		ResultSet rst2 = pstmt.executeQuery();
		
		out.println("\tProduct ID"+"\t"+"Quantity"+"\t"+"Price");

		while(rst2.next()) {
			String price = currFormat.format(rst2.getDouble("Price"));

			out.println("\t"+ rst2.getString("Product ID")+"\t\t"
			+ rst2.getString("Quantity")+"\t\t"
			+ price);
		}
		out.println();
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

