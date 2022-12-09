<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ page language="java" import="java.util.*,java.sql.*,javax.mail.*,javax.mail.internet.*,javax.activation.*"%>
<%@ include file="jdbc.jsp" %>
<link rel="stylesheet" href="./style.css">
<%@ include file="header.jsp" %>

<form name="MyForm" method=get action="forgotPassword.jsp">
	<table style="display:inline">
	<tr>
		<td><div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Email:</font></div></td>
		<td><input type="text" name="email"  size=10 maxlength=100></td>
	</tr>
	<input class="submit" type="submit" value="Send me an email">
	</table>
</form>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		String email = request.getParameter("email");
        String pw = request.getParameter("password");
		String code = request.getParameter("code");
        if(email == null && pw == null && code == null) return;
		if(code == null && email != null){
			session.setAttribute("email",email);
			session.setAttribute("code",1234);
			out.print(sendEmail(out,"http://localhost/shop/forgotPassword.jsp?code=1234&email="+email,email));
		} else {
            if(pw != null && code.equals(session.getAttribute("code").toString()) && email != null){
                out.print(changePassword(pw,email,out));
            } else if(code.equals(session.getAttribute("code").toString())){
                out.print("<form method=\"get\" action=\"forgotPassword.jsp\" size=\"200\">" +
                    "<input type=\"hidden\" name=\"code\" value="+code+">" +
                    "<input type=\"hidden\" name=\"email\" value="+email+">" +
                    "<label>New Password: </label><input type=\"text\" name=\"password\" size=\"50\"><br>" +
                    "<input type=\"submit\" value=\"Submit\"><input type=\"reset\" value=\"Reset\">" +
                    "<br>" +
                    "</form>");
			} else {
				out.print("NOOOOOOOOOOOOOOOOOOOO");
			}
		}
		//authenticatedUser = createUser(out,request,session);
		//out.print(authenticatedUser);
	}
	catch(IOException e)
	{	System.err.println(e); }
%>



<%!
int changePassword(String password, String email,JspWriter out) throws IOException{
    int rows = 0;
    try{
        getConnection();
        con.setCatalog("orders");
        String updateSQL = "UPDATE customer SET password = ? WHERE email = ?";
        PreparedStatement stmt = con.prepareStatement(updateSQL);
        stmt.setString(1,password);
        stmt.setString(2,email);
        rows = stmt.executeUpdate();
    } catch(Exception e){
        out.print(e);
        //closeConnection();
        return 0;
    }
    //closeConnection();
	return rows;
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
            message.setSubject("Reset your password.");
            message.setText(code);

            Transport.send(message);

            return "We sent you a link in your email.";

        } catch (Exception e) {
            return e.toString();
        }
}
%>

