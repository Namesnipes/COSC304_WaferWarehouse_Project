<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
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
<%@ include file="header.jsp" %>
<h1>Search for the products you want to buy:</h1>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
<br>
<label for="categoryName">Filter by:</label>
  <select name="categoryName" id="categoryName">
    <option value="All">All</option>
	<option value="Wafers">Wafers</option>
	<option value="Donuts">Donuts</option>
	<option value="Cakes">Cakes</option>
	<option value="Pies">Pies</option>
	<option value="Muffins">Muffins</option>
	<option value="Cookies">Cookies</option>
	<option value="Ice Cream">Ice Creams</option>
  </select>
</form>
<pre>
<% // Get product name to search for
String name = request.getParameter("productName");
String cname = request.getParameter("categoryName");
		
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
int cid = getCategoryIdFromName(cname,out);

String sql = "SELECT product.productId,productName,productPrice,productImageURL,categoryId,SUM(quantity) as q FROM "
			+"product FULL JOIN orderproduct ON product.productId = orderproduct.productId "
			+"WHERE productName LIKE ? ";
if(cid != -1){
	sql += "AND categoryId = ? ";
}
sql += "GROUP BY product.productId,productName,productPrice,productImageURL,categoryId ORDER BY q DESC";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1,"%" + name + "%");
if(cid != -1){
	stmt.setInt(2,cid);
}
ResultSet rst = stmt.executeQuery();
out.print("<table border=\"3\" width=\"300\" cellspacing=\"10\" cellpadding=\"10\">");

out.print("<thead><tr><th class=\"noBorder tableHeader\"><h3>Category</h3></th><th class=\"noBorder tableHeader\"><h3>Pic</h3></th><th class=\"noBorder tableHeader\"><h3>Product</h3></th><th class=\"noBorder tableHeader\"><h3>Price</h3></th><th class=\"noBorder\"></th></thead></tr>");

//display those bad boys (products)
Boolean firstProduct = true;
while(rst.next()){
	String productId = rst.getString("productId");
	String productName = rst.getString("productName");
	String productPrice = rst.getString("productPrice");
	String productImg = rst.getString("productImageURL");
	int categoryId = rst.getInt("categoryId");
	int buys = rst.getInt("q");
	String categoryName = getCategoryNameFromId(categoryId);
	if(productImg == null) productImg = "";

	//using urlencoder is overkill apparently you could just surround the productname in double quotes ("") but its too late now
	String url = "addcart.jsp?id=" + 
					URLEncoder.encode(productId, StandardCharsets.UTF_8) + "&name=" +
					URLEncoder.encode(productName, StandardCharsets.UTF_8) + "&price=" +
					URLEncoder.encode(productPrice, StandardCharsets.UTF_8) + "&img="+
					URLEncoder.encode(productImg,StandardCharsets.UTF_8);

	String updateProdUrl = "updateProductPage.jsp?productId=" + productId;

	String reviewProdUrl ="reviewProd.jsp?id=" + productId;

	String productPage = "product.jsp?id=" + URLEncoder.encode(productId, StandardCharsets.UTF_8);
	out.print("<tr>");
	out.print("<td>" + categoryName + "</td>");

	out.print("<td>");
	if(productImg != null && productImg.length() > 0){
		out.print("<img src=./imgs/" + productImg + " width=\"100;\" height=\"100\">");
	}
	out.print("</td>");
	out.print("<td><a href='"+productPage+"'>"+productName+"</a>\n" + buys + " bought ");
	if(firstProduct && cname.equals("All") && name.length() == 0){
		out.print("<span style=\"color:#EB0000\">(</span><span style=\"color:#EB6C00\">m</span><span style=\"color:#EBD900\">o</span><span style=\"color:#90EB00\">s</span><span style=\"color:#24EB00\">t</span> <span style=\"color:#00EB48\">p</span><span style=\"color:#00EBB4\">o</span><span style=\"color:#00B4EB\">p</span><span style=\"color:#0048EB\">u</span><span style=\"color:#2400EB\">l</span><span style=\"color:#9000EB\">a</span><span style=\"color:#EB00D9\">r</span><span style=\"color:#EB006C\">)</span>");
		firstProduct = false;
	}
	out.print("</td>");
	out.print("<td>"+currFormat.format(rst.getDouble("productPrice"))+"</td>");
	out.print("<td><a href='"+url+"'>Add to cart</a><br><br><a href='"+updateProdUrl+"'>Edit Product Info</a><br><br><a href='"+reviewProdUrl+"'>Leave a Review</a></td></tr>");

}
out.println("</table>");

closeConnection();

%>

<%!
String getCategoryNameFromId(int id){
	String n = "noname";
	try{
		String sql = "SELECT categoryName FROM category WHERE categoryId = ?";
		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setInt(1,id);
		ResultSet rst = stmt.executeQuery();
		rst.next();
		n = rst.getString("categoryName");
	} catch(Exception e){

	}
	return n;
}
%>

<%!
int getCategoryIdFromName(String name,JspWriter out)  throws IOException
{
	int id = -1;
	try{
		String sql = "SELECT categoryId FROM category WHERE categoryName = ?";
		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1,name);
		ResultSet rst = stmt.executeQuery();
		rst.next();
		id = rst.getInt("categoryId");
	} catch(Exception e){
		//out.print(e);
	}
	return id;
}
%>
</pre>
</body>
</html>