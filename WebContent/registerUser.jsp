<%@ page language="java" import="java.io.*,java.sql.*"%>
<%@ page language="java" import="java.util.*,java.sql.*,javax.mail.*,javax.mail.internet.*,javax.activation.*"%>
<%@ include file="jdbc.jsp" %>
<%
	String authenticatedUser = null;
	session = request.getSession(true);

	try
	{
		authenticatedUser = createUser(out,request,session);
		out.print(authenticatedUser);
	}
	catch(IOException e)
	{	System.err.println(e); }

	if(authenticatedUser != null)
		response.sendRedirect("index.jsp");		// Successful login
	else
		response.sendRedirect("register.jsp");		// Failed login - redirect back to login page with a message 
%>


<%!
	String createUser(JspWriter out,HttpServletRequest request, HttpSession session) throws IOException
	{
		String username = request.getParameter("username");
		String password = request.getParameter("password");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");

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
void sendEmail(JspWriter out, int code, String email) throws IOException{
    final String username = "corklebeck@gmail.com";
    final String password = "";

        Properties prop = new Properties();
		prop.put("mail.smtp.host", "smtp.gmail.com");
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
            message.setFrom(new InternetAddress("corklebeck@gmail.com"));
            message.setRecipients(
                    Message.RecipientType.TO,
                    InternetAddress.parse(email)
            );
            message.setSubject("Your Code For Wacky Wafer Warehouse");
            message.setText("");

            Transport.send(message);

            out.print("Done");

        } catch (MessagingException e) {
            e.printStackTrace();
        }
}
%>

