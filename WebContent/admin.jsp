<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
</head>
<body>


// TODO: Include files auth.jsp and jdbc.jsp
<% include file="auth.jsp" %>
<% include file="jdbc.jsp" %>


// TODO: Write SQL query that prints out total order amount by day
String sql = "SELECT orderDate, SUM(totalAmount) AS 'Daily Total' FROM ordersummary GROUP BY orderDate ORDER BY orderDate ASC";

%>

</body>
</html>

