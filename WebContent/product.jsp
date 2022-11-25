<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
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

try{
    
    String productId = request.getParameter("id");
        
    String sql = "SELECT * FROM product WHERE productId = ?";
    PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, productId);
    ResultSet rst = pstmt.executeQuery();
    rst.next();

    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String productName = rst.getString(2);
    String productPrice = rst.getString(3);
    String productImg = rst.getString(4);

    Double pr = 0.0;
    try{
            pr = Double.parseDouble(productPrice.toString());
	    }
		catch (Exception e)
	    {
			out.println("Invalid price for product, price: "+productPrice);
	    }
    
    //html
    out.println("<h1>" + productName + "</h1>");
    out.println("<div style=\"height: 100px;\">");
    if(productImg != null){
        out.println("<div class=\"cartImg\" style=\"background-image: url(./imgs/" + productImg + ")\"></div>");
    }
    out.println("<div style=\"position: relative;left: 10px;\"><b>Id: </b>" + rst.getString(1) + "</div>");
    out.println("<div style=\"position: relative;left: 10px;\"><b>Price: </b>" + currFormat.format(pr) + "</div>");
    out.println("</div>");
    // TODO: If there is a productImageURL, display using IMG tag

} catch (Exception ex) {
    out.println(ex);
}

		
// TODO: Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>

