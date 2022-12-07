<%@ page import="java.util.HashMap, java.sql.*, java.net.URLEncoder" %>
<%@ page import="java.nio.charset.StandardCharsets" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.io.IOException" %>
<%@ include file="jdbc.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="style.css">
<title>Your Shopping Cart</title>
</head>
<body>
<%@ include file="header.jsp" %>
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

if (productList.size() <= 0)
{	out.println("<h1>Your shopping cart is empty!</h1>");
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
		+ "<button type=\"button\" onclick=\"location.href='?minus="+ product.get(0) + "';\">-</button>"
		+ "<p style=\"display: inline-block;width: 20px;text-align: center;\">" + qty + "</p>"
		+ "<button type=\"button\" onclick=\"location.href='addcart.jsp?id=" + product.get(0) + "&name=add';\">+</button>"
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

	//popup
	
	Object user = session.getAttribute("authenticatedUser");
	if(user != null){
		HashMap<Object,Object> r = getMostBoughtProductInfoFromUserId(user.toString(),out);
		if(r != null){
			int q = Integer.parseInt(r.get("quantity").toString());
			String name = r.get("productName").toString();
			String price = r.get("price").toString();
			String imgurl = r.get("productImageURL").toString();
			String productId = r.get("productId").toString();
			if(productList.get(productId) != null){
				
			}
			String buyurl = "addcart.jsp?id=" + 
							URLEncoder.encode(productId, StandardCharsets.UTF_8) + "&name=" +
							URLEncoder.encode(name, StandardCharsets.UTF_8) + "&price=" +
							URLEncoder.encode(price, StandardCharsets.UTF_8) + "&img="+
							URLEncoder.encode(imgurl,StandardCharsets.UTF_8);
			if(r != null){
				out.print("<div style=\"background: rgba(255, 255, 255,0.4);width: 300px;height: 250px;border-style: double;\">");
				out.print("<h3 style=\"text-align: center;\">Mmm! You've bought " + q + " <b>" + name + "</b> in the past.</h3> ");
					out.print("<div style=\"margin: 0 auto;width: 100px;\">");
						out.print("<img src=\"./imgs/" + imgurl + "\" style=\"margin: 0 auto;\" width=\"100px\" height=\"100px\">");
					out.print("</div>");
				out.print("<a href=\"" + buyurl + "\" style=\"text-align: center;display: block;\"> How about another one? </a>");
				out.print("</div>");
				out.print("</div>");
			}
		}
	}
}
%>

<%!
HashMap<Object,Object> getMostBoughtProductInfoFromUserId(String id, JspWriter out) throws IOException
{
	//this statement will return all products since mssql doesnt have LIMIT?? why??
	try{
		getConnection();
		con.setCatalog("orders");
		String sql = "SELECT firstName,orderproduct.productId,productName,productPrice,productImageURL,SUM(quantity) as numberBought FROM "
					+ "((ordersummary JOIN customer ON ordersummary.customerId = customer.customerId) FULL JOIN orderproduct ON ordersummary.orderId = orderproduct.orderId) JOIN product ON product.productId = orderproduct.productId "
					+ "WHERE customer.userId = ? "
					+ "GROUP BY firstName,orderproduct.productId,productName,productImageURL,productPrice "
					+ "ORDER BY numberBought DESC;";
		PreparedStatement stmt = con.prepareStatement(sql);
		stmt.setString(1,id);
		ResultSet rst = stmt.executeQuery();
		HashMap<Object,Object> output = new HashMap<>();
		if(rst.next()){
			output.put("quantity",rst.getString("numberBought"));
			output.put("productName", rst.getString("productName"));
			output.put("productImageURL", rst.getString("productImageURL"));
			output.put("price", rst.getString("productPrice"));
			output.put("productId", rst.getString("productId"));
			closeConnection();
			return output;
		} else {
			closeConnection();
			return null;
		}
	} catch(SQLException e){
		out.print(e);
		return null;
	}
}
%>
</body>
</html>