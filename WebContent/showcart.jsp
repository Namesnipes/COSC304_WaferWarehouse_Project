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

if (productList == null || productList.size() <= 0)
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
		+ "<button type=\"button\" onclick=\"run('minus'," + product.get(0) + ",this.nextSibling," + pr + ");\">-</button>"
		+ "<p style=\"display: inline-block;width: 20px;text-align: center;\">" + qty + "</p>"
		+ "<button type=\"button\" onclick=\"run('add'," + product.get(0) + ",this.previousSibling," + pr + ");\">+</button>"
	 	+ "</div>");
		out.print("<div class=\"priceInfo\">"
        + "<b style=\"display:block;\">" + currFormat.format(pr) + "</b>"
        + "<a href=\"?delete=" + product.get(0) + "\">Remove</a>"
      	+ "</div>");
		  out.print("<div class=\"subtotalInfo\">"
		  + " x" + qty + " = "+ currFormat.format(pr*qty)
			+ "</div></div>");
		total = total +pr*qty;
		
	}
	out.print("<div class=\"total\">");
	out.println("Total: " + currFormat.format(total));
	out.print("</div>");

	//for AJAX
	String url = "http://" + request.getServerName() + "/" + request.getContextPath();
	out.print("<script>");
	/*
	 * function run(operation, id, quantityElement, price, priceElement) {

    // Creating Our XMLHttpRequest object 
    var xhr = new XMLHttpRequest();

    // Making our connection  
    var url = "";
    var add = 0;
    if (operation === "add") {
        url = 'http://localhost/shop/addcart.jsp?id=' + id + '&name=add';
        add = 1
    }
    if (operation === "minus") {
        url = 'http://localhost/shop/addcart.jsp?minus=' + id;
        add = -1
    }
    xhr.open("GET", url, true);

    // function execute after request is successful 
    xhr.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
            var newNum = parseInt(quantityElement.innerText) + add
            if (operation === "minus" && newNum === 0) {
                newNum = 1;
            } else {
                var total = parseFloat(document.getElementsByClassName("total")[0].innerText.replace(/[^\d.-]/g, ''))
                total = total + (add * price)
                console.log(Math.round(total * 100) / 100)
                document.getElementsByClassName("total")[0].innerText = "Total: " + "$" + Math.round(total * 100) / 100
            }
            var priceElement = quantityElement.parentElement.parentElement.getElementsByClassName("subtotalInfo")[0]
            quantityElement.innerText = newNum
            console.log(newNum * price)
            priceElement.innerText = "x" + newNum + " = " + "$" + (Math.round(newNum * price * 100) / 100)

        }
    }
    xhr.send()
}
	 */
	out.print("function run(e,t,n,a,s){var l=new XMLHttpRequest,o=\"\",r=0;\"add\"===e&&(o=\"" + url + "/addcart.jsp?id=\"+t+\"&name=add\",r=1),\"minus\"===e&&(o=\"http://localhost/shop/addcart.jsp?minus=\"+t,r=-1),l.open(\"GET\",o,!0),l.onreadystatechange=function(){if(4==this.readyState&&200==this.status){var t=parseInt(n.innerText)+r;if(\"minus\"===e&&0===t)t=1;else{var s=parseFloat(document.getElementsByClassName(\"total\")[0].innerText.replace(/[^\\d.-]/g,\"\"));s+=r*a,console.log(Math.round(100*s)/100),document.getElementsByClassName(\"total\")[0].innerText=\"Total: $\"+Math.round(100*s)/100}var l=n.parentElement.parentElement.getElementsByClassName(\"subtotalInfo\")[0];n.innerText=t,console.log(t*a),l.innerText=\"x\"+t+\" = $\"+Math.round(t*a*100)/100}},l.send()}");
	out.print("</script>");
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