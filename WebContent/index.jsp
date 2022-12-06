<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="./style.css">
        <title>The Wacky Wafer Warehouses Main Page</title>
</head>
<body>
<h1 align="center" style="display: block;/*! */margin: 0;line-height: 50px;border: solid;/*! border-radius: 10px; */border-style: dashed;">Welcome to The Wacky Wafer Warehouse!</h1>

<%
if(session.getAttribute("authenticatedUser") == null){
        out.println("<h2 align=\"center\"><a href=\"login.jsp\">Login</a></h2>");
}
%>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<%
if(session.getAttribute("authenticatedUser") != null) {
        out.print("<h2 align=\"center\"><a href=\"logout.jsp\">Log out</a></h2>");

        String userName = (String) session.getAttribute("authenticatedUser");
        out.print("<h1 align='center'>Hello "+userName+"!</h1>");
}
%>

<%
// TODO: Display user name that is logged in (or nothing if not logged in)

%>
</body>
</head>


