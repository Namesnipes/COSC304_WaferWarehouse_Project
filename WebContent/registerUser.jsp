<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ page language="java" import="java.util.*,java.sql.*,javax.mail.*,javax.mail.internet.*,javax.activation.*"%>
<%@ include file="jdbc.jsp" %>
<link rel="stylesheet" href="./style.css">
<%@ include file="header.jsp" %>

<form name="MyForm" method=post action="registerUser.jsp">
	<table style="display:inline">
	<tr>
		<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Code:</font></div></td>
		<td><input type="text" name="code"  size=10 maxlength=10></td>
	</tr>
	<input class="submit" type="submit" name="Submit2" value="Register">
	</table>
</form>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		String email = request.getParameter("email");
		String code = request.getParameter("code");
		if(code == null){
			session.setAttribute("username",request.getParameter("username"));
			session.setAttribute("password",request.getParameter("password"));
			session.setAttribute("firstName",request.getParameter("firstName"));
			session.setAttribute("lastName",request.getParameter("lastName"));
			session.setAttribute("email",email);
			session.setAttribute("code",1234);
			out.print(sendEmail(out,"1234",email));
		} else {
			if(code.equals(session.getAttribute("code").toString())){
				out.print("YES!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
				createUser(out,request,session);
				response.sendRedirect("index.jsp");
			} else {
				out.print("NOOOOOOOOOOOOOOOOOOOO");
			}
		}
		//authenticatedUser = createUser(out,request,session);
		//out.print(authenticatedUser);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null){}
		//response.sendRedirect("index.jsp");		// Successful login
	else{}
		//response.sendRedirect("register.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String createUser(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = session.getAttribute("username").toString();
		String password = session.getAttribute("password").toString();
		String firstName = session.getAttribute("firstName").toString();
		String lastName = session.getAttribute("lastName").toString();
		String email = session.getAttribute("email").toString();
		String retStr = null;
		if(username == null || password == null || firstName == null || lastName == null || email == null)
				return null;
		if((username.length() == 0) || (password.length() == 0) || (firstName.length() == 0) || (lastName.length() == 0) || (email.length() == 0))
				return null;

		try 
		{
			getConnection();
			con.setCatalog("orders");
			String sql = "INSERT INTO customer(firstName,lastName,userid,password,email) VALUES (?,?,?,?,?);";
			PreparedStatement pstmt = con.prepareStatement(sql);
			pstmt.setString(1, firstName);
			pstmt.setString(2, lastName);
            pstmt.setString(3, username);
            pstmt.setString(4, password);
            pstmt.setString(5, email);
			pstmt.executeUpdate();
			retStr = new String(username);	
		} 
		catch (SQLException ex) {
			out.println(ex);
		}
		finally
		{
			try{
				closeConnection();
			}
				catch(SQLException ex){
                    out.println(ex);
			}
		}	
		
		if(retStr != null)
		{
			session.setAttribute("authenticatedUser",username);
		}

		return retStr;
	}
%>

<%!
String sendEmail(JspWriter out, String code, String email) throws IOException{
    final String username = "wackywafers@outlook.com";
	char startPw = 119;
	char endPw = 33;
    final String password = startPw + "afers123" + endPw; //steal my email account I dare you. I will cry.

        Properties prop = new Properties();
		prop.put("mail.smtp.host", "outlook.office365.com");
		prop.put("mail.smtp.port", "587");
		prop.put("mail.smtp.auth", "true");
		prop.put("mail.smtp.starttls.enable", "true"); //TLS
        
        Session session = Session.getInstance(prop,
                new javax.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(username, password);
                    }
                });

        try {

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(email)
            );
            message.setSubject("Your Code For Wacky Wafer Warehouse");
            message.setText(code);

            Transport.send(message);

            return "We sent you a code in your email. Please enter it above.";

        } catch (Exception e) {
            return e.toString();
        }
}
%>

