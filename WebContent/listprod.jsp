<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./style.css">
<title>The Wacky Wafer Warehouse</title>
</head>
<body>
<h1 style="display: block;/*! */margin: 0;line-height: 50px;border: solid;/*! border-radius: 10px; */border-style: dashed;"> The Wacky Wafer Warehouse </h1>
<div class="header">
	<div class="buttonContainer">
		<a href = "listprod.jsp" class="b1"> Products </a>
		<a href = "listorder.jsp" class="b1"> Order List </a>
		<a href = "showcart.jsp" class="b1"> Shopping Cart </a>
	</div>
</div>
<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>
<pre>
<% // Get product name to search for
String name = request.getParameter("productName");
		
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

//Connect to database
getConnection();

//set db to orders
con.setCatalog("orders");

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00

NumberFormat currFormat = NumberFormat.getCurrencyInstance();

//return all products from the db that match what the user searched
String sql = "SELECT * FROM product WHERE productName LIKE ?";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1,"%" + name + "%");
ResultSet rst = stmt.executeQuery();
out.print("<table border=\"3\" width=\"300\" cellspacing=\"10\" cellpadding=\"10\">");

out.print("<thead><tr><th></th><th>Product Name</th><th>Price</th></thead></tr>");

//display those bad boys (products)
while(rst.next()){
	String productId = rst.getString("productId");
	String productName = rst.getString("productName");
	String productPrice = rst.getString("productPrice");
	String productImg = rst.getString("productImageURL");
	if(productImg == null) productImg = "";

	//using urlencoder is overkill apparently you could just surround the productname in double quotes ("") but its too late now
	String url = "addcart.jsp?id=" + 
					URLEncoder.encode(productId, StandardCharsets.UTF_8) + "&name=" +
					URLEncoder.encode(productName, StandardCharsets.UTF_8) + "&price=" +
					URLEncoder.encode(productPrice, StandardCharsets.UTF_8) + "&img="+
					URLEncoder.encode(productImg,StandardCharsets.UTF_8);
	out.print("<tr><td><a href='"+url+"'> Add to cart </a></td>");
	out.print("<td>"+rst.getString("productName")+"</td><td>"+currFormat.format(rst.getDouble("productPrice"))+"</td></tr>");
}
out.println("</table>");

closeConnection();

%>
</pre>
</body>
</html>