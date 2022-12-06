<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="style.css">
<title>Wacky Wafer Warehouse Order Processing</title>
<h1 style="display: block;/*! */margin: 0;line-height: 50px;border: solid;/*! border-radius: 10px; */border-style: dashed;"> The Wacky Wafer Warehouse </h1>
<div class="header">
	<div class="buttonContainer">
		<a href = "index.jsp" class="b1"> Home </a>
	</div>
</div>
</head>
<body>
<pre>
<% 
String custId = request.getParameter("customerId");
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

getConnection();
con.setCatalog("orders");

//get customer id entered from database
String sql = "SELECT COUNT(*) as numCustomer, firstName, lastName FROM customer WHERE customerId = ? GROUP BY firstName,lastName";
PreparedStatement stmt = con.prepareStatement(sql);
stmt.setString(1,custId);
ResultSet rst = stmt.executeQuery();

// Determine if valid customer id was entered
Boolean valid = false;
try{
	rst.next();

	int numResults = rst.getInt(1);
	if(numResults == 1){
		out.println("<h1>Wacky ID accepted!</h1>");
		valid = true;
	} else {
		out.println("<header>Wacky entry! However, you've entered an invalid ID.</header>");
		return;
	}
} catch(Exception e){
	out.println("The ID you entered isn't wacky enough! Please enter another wacky (and valid) ID!");
	return;
}

// Determine if there are products in the shopping cart

if(productList.size() <= 0){
	out.println("Your shopping cart is empty");
	return;
}

//calculate price total
double total = 0;
for (ArrayList value : productList.values()) {
	Object price = value.get(2);
	Object itemqty = value.get(3);
	if(price != null && itemqty != null){
		total += Integer.parseInt(itemqty.toString()) 
		* Double.parseDouble(price.toString());
	}
}

//insert order into ordersummary with orderDate,totalAmount and customerId values
Date d = new Date();
java.sql.Date sqlDate = new java.sql.Date(d.getTime());
String insertOrderSQL = "INSERT INTO ordersummary (orderDate,totalAmount,customerId) VALUES (?, ?, ?)";
PreparedStatement pstmt2 = con.prepareStatement(insertOrderSQL, Statement.RETURN_GENERATED_KEYS);
pstmt2.setDate(1,sqlDate);
pstmt2.setDouble(2,total);
pstmt2.setString(3,custId);	
pstmt2.executeUpdate();

//an orderid was generated for the last insert statement, we get it here
ResultSet keys = pstmt2.getGeneratedKeys();
keys.next();
int orderId = keys.getInt(1);

//insert each product seperately into orderproduct table
NumberFormat currFormat = NumberFormat.getCurrencyInstance();
out.print("<table border='3' width='500' cellspacing='2'>"
	+ "<tr><th style='text-align: center' width='10%'>Product ID</th>"
	+ "<th style='text-align: center' width='50%'>Product Name</th>"
	+ "<th style='text-align: center' width='10%'>Quantity</th>"
	+ "<th style='text-align: center' width='15'>Price</th>"
	+ "<th style='text-align: center' width='15'>Total</th></tr>");
Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
while (iterator.hasNext()) {
	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
	ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
	String insertProductSQL = "";
	String productId = (String) product.get(0);
	String productName = (String) product.get(1);
    String price = (String) product.get(2);
	try{
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
		out.print("<tr><td>"+productId+"</td><td>"+productName+"</td><td>"+qty+"</td><td>"+currFormat.format(pr)+"</td></tr>");
		insertProductSQL += "INSERT INTO orderproduct (orderId,productId,quantity,price) VALUES (?,?,?,?)";
		PreparedStatement pstmt3 = con.prepareStatement(insertProductSQL);
		pstmt3.setInt(1,orderId);
		pstmt3.setString(2,productId);
		pstmt3.setInt(3,qty);
		pstmt3.setDouble(4,pr);
		pstmt3.executeUpdate();
	} catch (Exception e){
		out.println("Broken cart... reseting cart");
		productList = new HashMap<String, ArrayList<Object>>();
		session.setAttribute("productList", productList);
		return;
}
}

out.println("<tr><td></td><td></td><td></td><td></td><td>"+currFormat.format(total)+"</td></tr></table>");
out.println("Order completed. Will be shipped soon...");
out.println("Your order number: " + orderId);
out.println("Shipping to customer: " + custId + " " + rst.getString(2) + " " + rst.getString(3));
productList = new HashMap<String, ArrayList<Object>>();
session.setAttribute("productList", productList);

closeConnection();
%>
</pre>
</BODY>
</HTML>

