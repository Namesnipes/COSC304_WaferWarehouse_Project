<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.lang.*" %>

<%
try{
    updateProduct(out, request, session);
} catch(IOException e){
    System.err.println(e);
}

%>
<%!
NumberFormat currFormat = NumberFormat.getCurrencyInstance();

String updateProduct(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException{
    
    // Get product info from url
    String productId = request.getParameter("id");
    String productName = request.getParameter("name");
    String categoryName = request.getParameter("categoryName");
    String productDesc = request.getParameter("productDesc");
    String productPrice = request.getParameter("price");

    try{
        getConnection();
		con.setCatalog("orders");

        String updateProdString = "UPDATE product SET";

        if(productName != null){
            updateProdString += " productName = "+ productId;
        }
        else if(categoryName != null){
            updateProdString += " categoryId = "+ getCategoryIdFromName(categoryName, out);
        }
        else if(productDesc != null){
            updateProdString += " productDesc = "+productDesc;
        }
        else if(productPrice != null){
            updateProdString += " productPrice = "+productPrice;
        }
        else if(updateProdString == "UPDATE product SET"){
            return "Failed to update product";
        }

        Statement stmt = con.createStatement();
        stmt.executeQuery(updateProdString);
        return "Product updated";

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
    
    return "";
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