<!DOCTYPE html>
<html>
<head>
	<link rel="stylesheet" href="./style.css">
	<%@ include file="header.jsp" %>
<title>Register Screen</title>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

<h3>Create an account!</h3>
<br>
<form name="MyForm" method=post action="registerUser.jsp">
<table style="display:inline">
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">First Name:</font></div></td>
	<td><input type="text" name="firstName"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Last Name:</font></div></td>
	<td><input type="text" name="lastName"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div></td>
	<td><input type="text" name="username"  size=10 maxlength=10></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div></td>
	<td><input type="password" name="password" size=10 maxlength="10"></td>
</tr>
<tr>
	<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email:</font></div></td>
	<td><input type="email" name="email" size=10 maxlength="50"></td>
</tr>
</table>
<br/>
<input class="submit" type="submit" name="Submit2" value="Register">
</form>

</div>

</body>
</html>

