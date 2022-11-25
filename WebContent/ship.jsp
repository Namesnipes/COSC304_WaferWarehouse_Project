<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<link rel="stylesheet" href="./style.css">
<title>Wacky Grocery Shipment Processing</title>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	//Connect to database
	getConnection();
	con.setCatalog("orders");

	String orderId = request.getParameter("orderId");
          
	//Check if valid order id
	
	String sql = "SELECT * FROM ordersummary WHERE orderId = ?";
	PreparedStatement stmt = con.prepareStatement(sql);
	try{
		Integer.parseInt(orderId);
	} catch(Exception e){
		out.println("<h2> Invalid ID: " + orderId + "</h2>");
		closeConnection();
		return;
	}
	stmt.setString(1,orderId);
	ResultSet rst = stmt.executeQuery();

	Boolean valid = false;
	if(rst.next()){
		valid = true;
	}
	//Start a transaction (turn-off auto-commit)
	con.setAutoCommit(false);
	//Retrieve all items in order with given id
	String sql2 = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";
	PreparedStatement stmt2 = con.prepareStatement(sql2);
	stmt2.setString(1,orderId);
	ResultSet rst2 = stmt2.executeQuery();
	//Create a new shipment record.
	Date d = new Date();
	java.sql.Date sqlDate = new java.sql.Date(d.getTime());
	String insertOrderSQL = "INSERT INTO shipment (shipmentDate,warehouseId) VALUES (?, ?)"; //shipment id is auto incremented dont set it explicitly
	PreparedStatement pstmt3 = con.prepareStatement(insertOrderSQL);
	pstmt3.setDate(1,sqlDate);
	pstmt3.setInt(2,1);	
	pstmt3.executeUpdate();
	// TODO: For each item verify sufficient quantity available in warehouse 1.
	String outstr = "";
	while(rst2.next()){
		int productId = rst2.getInt("productId");
		int quantityWanted = rst2.getInt("quantity");
		int quantityInStock = 0;

		String quantityCheckSql = "SELECT * FROM productInventory WHERE productId = ? AND warehouseId = ?";
		PreparedStatement quantityStmt = con.prepareStatement(quantityCheckSql);
		quantityStmt.setInt(1,productId);
		quantityStmt.setInt(2,1);
		ResultSet quantityRst = quantityStmt.executeQuery();
		//If any item does not have sufficient inventory, cancel transaction and rollback. Otherwise, update inventory for each item.
		if(quantityRst.next()){
			quantityInStock = quantityRst.getInt("quantity");
			if((quantityInStock-quantityWanted) < 0){
				con.rollback();
				closeConnection();
				out.println("<h2> Shipment not completed. Insufficient inventory for quantity " + quantityWanted + " of product id " + productId + " (" + quantityInStock + " in stock)</h2>");
				return;
			} else {
				String quantityUpdate = "UPDATE productInventory SET quantity = ? WHERE productId = ? AND warehouseId = ?";
				PreparedStatement quantityUpdStmt = con.prepareStatement(quantityUpdate);
				quantityUpdStmt.setInt(1,quantityInStock-quantityWanted);
				quantityUpdStmt.setInt(2,productId);
				quantityUpdStmt.setInt(3,1);
				quantityUpdStmt.executeUpdate();
				outstr += "<h2>Ordered Product:" + productId + " Qty: " + quantityWanted + " Previous inventory: " + quantityInStock + " New inventory: " + (quantityInStock-quantityWanted) + "</h2>";
			}
		}
	}
	out.println(outstr);
	// Auto-commit should be turned back on
	con.commit();
	con.setAutoCommit(true);
	closeConnection();
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
