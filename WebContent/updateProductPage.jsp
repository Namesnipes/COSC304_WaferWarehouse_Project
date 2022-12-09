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
String id = request.getParameter("productId");
String productName = "Product does not exist";
String productDesc = "Product id " + id + " does not exist";
String price = "Product does not exist";
String categoryId = "Product does not exist";
Boolean exists = false;
if(id != null){
    getConnection();
	con.setCatalog("orders");
	
	String sql = "SELECT * FROM product WHERE productId = ?";
	PreparedStatement pstmt = con.prepareStatement(sql);
    pstmt.setString(1, id);
	ResultSet rst = pstmt.executeQuery();
    if(rst.next()){
        exists = true;
        productName = rst.getString("productName");
        productDesc = rst.getString("productDesc");
        price = rst.getString("productPrice");
        categoryId = rst.getString("categoryId");
    }
} else {
    id = "";
}
%>

<form name="autofill" method=get action=updateProductPage.jsp>
    <tr>
        <p> <h2>Submit to autofill boxes below with existing information:</h2><br>(Enter "9999" into all boxes below to delete product)</p> 
        <%
            out.print("<input type=\"number\" name=\"productId\" value=" + id + "  size=10 maxlength=25>");
        %>
    </tr>
    <input type="submit" value="Submit">
</form>

<br><br>
<form name="MyForm" method=post action="updateProduct.jsp">
    <input name="productId" type="hidden" value=<% out.print(id); %>>
    <table style="display:inline">
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Product Name: </font></div></td>
        <% 
            out.print("<td><input type=\"text\" name=\"productName\" value='" + productName + "'  size=20 maxlength=25></td>");
        %>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Category Name: </font></div></td>
        <td>
        <% 
            out.print("<input type=\"text\" name=\"categoryId\" value=" + categoryId + " size=20 maxlength=25></td>");
        %>
        </td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Description: </font></div></td>
        <td>
            <%
            out.print("<textarea type=\"text\" name=\"productDesc\" size=20 maxlength=200>" + productDesc + "</textarea></td>");
            %>
        </td>
    </tr>
    <tr>
        <td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Price: </font></div></td>
        <td>
            <%
            out.print("<input type=\"text\" name=\"productPrice\" value=" + price + " size=20 maxlength=10></td>");
            %>
        </td>
    </tr>
    </table>
    <br/>
    <input class="submit" type="submit" name="Submit" value="Edit Product" <%if(!exists){out.print("disabled");} %> >
    </form>

    </form>

</body>


</html>
