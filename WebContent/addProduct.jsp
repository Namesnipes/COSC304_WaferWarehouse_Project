<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.lang.*" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="./style.css">
    <%@ include file="header.jsp" %>
    <title>Add Product</title>
</head>
<h1 align="center">Enter New Product Information</h3>

<form method="get" action="addProduct.jsp" size="200">
    <label>Product Name: </label><input type="text" name="productName" size="50"><br>
    <label>Category ID: </label><input type="number" name="categoryId" size="20"><br>
    <label>Description: </label><input type="text" name="productDesc" size ="100"><br>
    <label>Price: </label><input type="number" name="productPrice" size ="20"><br>
    <label>Image: </label><input type="file" name="productImageURL">
    
    <input type="submit" value="Submit"><input type="reset" value="Reset">
    <br>
</form>
<%
// Get new product information

// Connect to database
    getConnection();
    con.setCatalog("orders");

NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0);	// Prints $5.00

try{
    String newProductName = request.getParameter("productName");
        if(newProductName == null) return;
    String catId = request.getParameter("categoryId");
        if(catId == "") catId = null;
    String desc = request.getParameter("productDesc");
        if(desc == "") desc = null;
    String price = request.getParameter("productPrice");
        if(price == "") price = null;
    String productImg = request.getParameter("img");
        if(productImg == "") productImg = null;
    
    if(catId == null && desc == null && price == null && productImg == null)
        return;

    String sql = "INSERT INTO product(productName, categoryId, productDesc, productPrice, productImageURL) VALUES (?, ?, ?, ?, ?)";
    PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
    pstmt.setString(1, newProductName);
    pstmt.setString(2, catId);
    pstmt.setString(3, desc);
    pstmt.setString(4, price);
    pstmt.setString(5, productImg);

    pstmt.executeUpdate();

    ResultSet keys = pstmt.getGeneratedKeys();
    keys.next();
    int productId = keys.getInt(1);

    out.print("<h3 align=\"center\">"+newProductName+" has been added to the list of products with the following product ID: "+productId+"</h3>");


} catch(Exception e){
    out.print(e);
}
%>