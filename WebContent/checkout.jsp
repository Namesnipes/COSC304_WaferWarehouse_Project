<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="style.css">
<title>Wacky Wafer Warehouse Grocery CheckOut Line</title>
</head>
<body>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>
<%
String msg = request.getParameter("msg");
if(msg != null && msg.length() > 0){
    out.println("<h2>" + msg + "</h2>");
}
%>

<h1>Enter your info to complete the transaction:</h1>

<form method="get" action="order.jsp">

<%
getConnection();
con.setCatalog("orders");
String paymentSQL = "SELECT * FROM paymentmethod JOIN customer ON paymentmethod.customerId = customer.customerId WHERE customer.userId = ?";
PreparedStatement stmtPayment = con.prepareStatement(paymentSQL);
stmtPayment.setString(1,session.getAttribute("authenticatedUser").toString());
ResultSet rstPayment = stmtPayment.executeQuery();
String pt = "";
String pn = "";
String ped = "";
if(rstPayment.next()){
  pt = rstPayment.getString("paymentType");
  pn = rstPayment.getString("paymentNumber");
  ped = rstPayment.getString("paymentExpiryDate");
}
  out.print("Customer Id: <input type=\"text\" name=\"customerId\" size=\"20\">");
  out.print("<br>");
  out.print("<label for=\"paymentMethod\">Payment Method:</label>");
    out.print("<select name=\"paymentMethod\" id=\"paymentMethod\" value=" + pt + ">");
    out.print("<option value=\"WackyPay\">WackyPay</option>");
    out.print("<option value=\"Visa\">Visa</option>");
    out.print("<option value=\"Debit\">Debit</option>");
  out.print("</select>");
  out.print("<br>");
  out.print("Payment Number: <input type=\"text\" name=\"paymentNumber\" size=\"20\" value=" + pn + ">");
  out.print("<br>");
  out.print("Expiry Date: <input type=\"date\" name=\"expiryDate\" size=\"20\" value=" + ped + ">");
  out.print("<br>");
  out.print("<input type=\"submit\" value=\"Submit\"><input type=\"reset\" value=\"Reset\">");
  closeConnection();
%>

</form>

</body>
</html>

