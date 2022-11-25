<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>
<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat" %>
<%@ include file="jdbc.jsp" %>

<%
// TODO: Write SQL query that prints out total order amount by day
try{
    NumberFormat currFormat = NumberFormat.getCurrencyInstance();
    String sql = "SELECT orderDate, SUM(totalAmount) AS 'Daily Total' FROM ordersummary GROUP BY orderDate ORDER BY orderDate ASC";
    getConnection();
    con.setCatalog("orders");
    PreparedStatement stmt = con.prepareStatement(sql);
    ResultSet rst = stmt.executeQuery();
    out.print("<div><b>Order Date, Total Order Amount</b></div>");
    while(rst.next()){
        out.print("<div>");
        String datestr = rst.getString("orderDate").split(" ")[0];
        out.print(datestr);
        out.print(", ");
        out.print(currFormat.format(rst.getDouble("Daily Total")));
        out.print("</div>");

    }
} catch(SQLException e){
    out.println(e);
} finally{
    closeConnection();
}

%>

</body>
</html>

