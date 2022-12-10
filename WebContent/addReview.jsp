<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<%@ include file="jdbc.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.lang.*" %>

<%
// Connect to database

    try{
        getConnection();
        con.setCatalog("orders");

        String productId = request.getParameter("id");
        String newReview = request.getParameter("productReview");

        if(newReview == null || productId == null)
        return;

        String sql = "UPDATE product SET productReview = ? WHERE productId = ?";

        PreparedStatement pstmt = con.prepareStatement(sql);
        pstmt.setString(1, newReview);
        pstmt.setString(2, productId);

        pstmt.executeUpdate();

    } catch(Exception e){
        out.print(e);
    } finally{
        closeConnection();
    }

%>
<jsp:forward page="listprod.jsp?id=" />