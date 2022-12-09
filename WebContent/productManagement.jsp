<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="./style.css">
    <%@ include file="header.jsp" %>
    <title>Product Management</title>
</head>

<body>

<h1 align="center">Product Management</h2>

<h3 align="center"><a href="addProduct.jsp" code style="text-decoration:none;">Add Product</a></h3>
<h3 align="center"><a href="listprod.jsp" code style="text-decoration:none;">Update Product</a></h3>
<h3 align="center"><a href="deleteProduct.jsp" code style="text-decoration:none;">Delete Product</a></h3>
<br>
<h3 align="center"><a href="addWarehouse.jsp" code style="text-decoration:none;">Add Warehouse</a></h3>
<h3 align="center"><a href="updateWarehouse.jsp" code style="text-decoration:none;">Update Warehouse</a></h3>
<br>
<h3 align="center"><a href="updateCustomer.jsp" code style="text-decoration:none;">Update Customer</a></h3>
<br>
<h3 align="center"><a href="admin.jsp" code style="text-decoration:none;">Back to Admin Menu</a></h3>
</body>
</html>

    
