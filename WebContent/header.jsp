<h1 style="display: block;/*! */margin: 0;line-height: 50px;border: solid;/*! border-radius: 10px; */border-style: dashed;"> The Wacky Wafer Warehouse </h1>
<div class="header">
	<div class="buttonContainer">
		<a href = "index.jsp" class="b1"> Home </a>
		<a href = "listprod.jsp" class="b1"> Products </a>
		<a href = "listorder.jsp" class="b1"> Order List </a>
		<a href = "showcart.jsp" class="b1"> Shopping Cart </a>
		<%
		Object username = session.getAttribute("authenticatedUser");
		if(username == null){
			out.print("<a href=login.jsp class=logInHeader> Log In </a>");
		} else {
			out.print("<p class=logInHeader style=\"line-height: unset\">Logged in as: " + username + "</p>");
		}
		%>

	</div>
</div>