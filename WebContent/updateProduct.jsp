<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.lang.*" %>
<link rel="stylesheet" href="./style.css">
<%@ include file="header.jsp" %>
<%
try{
    out.print(updateProduct(out, request, session));
} catch(IOException e){
    System.err.println(e);
}

%>
<%!
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

String updateProduct(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException{
    
    // Get product info from url
    String productId = request.getParameter("productId");
    String productName = request.getParameter("productName");
    String categoryId = request.getParameter("categoryId");
    String productDesc = request.getParameter("productDesc");
    String productPrice = request.getParameter("productPrice");
    try{
        getConnection();
		con.setCatalog("orders");

        String updateProdString = "UPDATE product SET productName = ?, categoryId = ?, productDesc = ?, productPrice = ? WHERE productId = ?";
        PreparedStatement pstmt = con.prepareStatement(updateProdString);
        pstmt.setString(1, productName);
        pstmt.setString(2, categoryId);
        pstmt.setString(3, productDesc);
        pstmt.setString(4, productPrice);
        pstmt.setString(5, productId);
        int rows = pstmt.executeUpdate();
        return "<h2> Products updated in database: " + rows + "</h2><h2><a href=updateProductPage.jsp> Update another</a> or go to the home page";

    }catch (SQLException ex) {
        out.println(ex);
    } finally
	    {
		    try{
				closeConnection();
			}
				catch(SQLException ex){
                    out.println(ex);
			}
		}	 
    return "<h2> Products failed to update, <a href=updateProductPage.jsp> try again </a> </h2>";
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