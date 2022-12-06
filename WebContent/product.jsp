<%@ page import="java.util.HashMap" %>
<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<link rel="stylesheet" href="./style.css">
<title>Product Information</title>
</head>
<body>
<%@ include file="header.jsp" %>

<%
// Get product name to search for

getConnection();
con.setCatalog("orders");


    
    String productId = request.getParameter("id");
        
    String sql = "SELECT * FROM product WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, productId);
    ResultSet rst = pstmt.executeQuery();
    rst.next();

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String productName = rst.getString(2);
    String productPrice = rst.getString(3);
    String productDesc = rst.getString("productDesc");
    String productImgBinary = rst.getString("productImage");
    String productImg = rst.getString("productImageURL");
    if(productImg == null) productImg = "";
    Double pr = 0.0;
    try{
            pr = Double.parseDouble(productPrice.toString());
	    }
		catch (Exception e)
	    {
			out.println("Invalid price for product, price: "+productPrice);
	    }
    

    String url = "addcart.jsp?id=" + 
        URLEncoder.encode(productId, StandardCharsets.UTF_8) + "&name=" +
        URLEncoder.encode(productName, StandardCharsets.UTF_8) + "&price=" +
        URLEncoder.encode(productPrice, StandardCharsets.UTF_8) + "&img="+
        URLEncoder.encode(productImg,StandardCharsets.UTF_8);   
    //html
    out.println("<h1>" + productName + "</h1>");
    out.println("<div style=\"height: 100px;\">");
    if(productImgBinary != null){
        out.println("<img src=displayImage.jsp?id=" + productId + " width=100; height=100>");
    }
    if(productImg != ""){
        out.println("<img src=./imgs/" + productImg + " width=100; height=100>");
    }
    out.println("<div style=\"position: relative;left: 10px;\"><b>Id: </b>" + rst.getString(1) + "</div>");
    out.println("<div style=\"position: relative;left: 10px;\"><b>Description: </b>" + productDesc + "</div>");
    out.println("<div style=\"position: relative;left: 10px;\"><b>Price: </b>" + currFormat.format(pr) + "</div>");
    out.println("<a href=" + url + ">Add to Cart</a>");
    out.println("<a href=\"listprod.jsp\">Continue Shopping</a>");
    out.println("</div>");
%>

</body>
</html>

