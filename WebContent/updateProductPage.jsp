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
<title>Update Product</title>
</head>
<body>

<%@ include file="header.jsp" %>

<% 
out.print("<h3>Enter values into any submission box, then click 'Submit' to make changes</h3>");
%>

<form name="MyForm" method=post action="updateProduct.jsp">
    <table style="display:inline">
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Name: </font></div></td>
        <td><input type="text" name="productName"  size=20 maxlength=25></td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Category Name: </font></div></td>
        <td><input type="text" name="categoryName"  size=20 maxlength=25></td>
        </td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Description: </font></div></td>
        <td><input type="text" name="productDesc"  size=50 maxlength=200></td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Price: </font></div></td>
        <td><input type="text" name="productPrice" size=20 maxlength="10"></td>
    </tr>
    </table>
    <br/>
    <input class="submit" type="submit" name="Submit" value="Submit">
    </form>

</body>
</html>
