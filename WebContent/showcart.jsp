<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="style.css">
<title>Your Shopping Cart</title>
</head>
<body>
<h1 style="display: block;/*! */margin: 0;line-height: 50px;border: solid;/*! border-radius: 10px; */border-style: dashed;"> The Wacky Wafer Warehouse </h1>
<div class="header">
	<div class="buttonContainer">
		<a href = "listprod.jsp" class="b1"> Products </a>
		<a href = "listorder.jsp" class="b1"> Order List </a>
		<a href = "showcart.jsp" class="b1"> Shopping Cart </a>
	</div>
</div>
<div class="item"> </div>
<%
// Get the current list of products
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String delete = request.getParameter("delete");
if(delete != null){
	if (productList.containsKey(delete)){
		productList.remove(delete);
	}
}

String minus = request.getParameter("minus");
if(minus != null){
	if (productList.containsKey(minus)){
		ArrayList<Object> product = (ArrayList<Object>) productList.get(minus);
		int curAmount = ((Integer) product.get(3)).intValue();
		int nextAmt = curAmount-1;
		if(nextAmt >= 1){
			product.set(3, new Integer(nextAmt));
		}
	}
}

if (productList == null)
{	out.println("<H1>Your shopping cart is empty!</H1>");
	productList = new HashMap<String, ArrayList<Object>>();
}
else
{
	NumberFormat currFormat = NumberFormat.getCurrencyInstance();
	out.print("<div class=\"wrapper\">");
	out.println("<h1>Your Shopping Cart 🛒</h1>");
	double total =0;
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) 
	{	Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		Object price = product.get(2);
		Object itemqty = product.get(3);
		double pr = 0;
		int qty = 0;
		
		try
		{
			pr = Double.parseDouble(price.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try
		{
			qty = Integer.parseInt(itemqty.toString());
		}
		catch (Exception e)
		{
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}
		out.println("<div class=\"shoppingCartItem\">");
		out.println("<div class=\"cartImg\" style=\"background-image: url(./imgs/" + product.get(4) + ")\"></div>");
		out.print("<div class=\"cartInfo\">"
	 	+ "<p style=\"margin: 0;\"><b>Product ID " + product.get(0) + "</b><br>" + product.get(1) + "</p>"
  		+ "</div>");
		out.print("<div class=\"quantityInfo\">"
		+ "<button type=\"button\" onclick=\"location.href='addcart.jsp?id=" + product.get(0) + "&name=add';\">+</button>"
		+ "<p style=\"display: inline-block;width: 20px;text-align: center;\">" + qty + "</p>"
		+ "<button type=\"button\" onclick=\"location.href='?minus="+ product.get(0) + "';\">-</button>"
	 	+ "</div>");
		out.print("<div class=\"priceInfo\">"
        + "<b style=\"display:block;\">" + currFormat.format(pr) + "</b>"
        + "<a href=\"?delete=" + product.get(0) + "\">Remove</a>"
      	+ "</div>");
		  out.print("<div class=\"subtotalInfo\">"
		  + "<b style=\"display:block;\"> x" + qty + " = "+ currFormat.format(pr*qty) + "</b>"
			+ "</div></div>");
		total = total +pr*qty;
	}
	out.print("<div class=\"total\">");
	out.println("Total: " + currFormat.format(total));
	out.print("</div>");
	out.println("<h2><a href=\"checkout.jsp\">Check Out</a></h2>");
	out.println("<h2><a href=\"listprod.jsp\">Continue Shopping</a></h2>");
	out.print("</div>");
}
%>
</body>
</html> 

