<%@page import="com.sun.corba.se.spi.ior.Writeable"%>
<%@page import="supportClasses.QueryResult"%>
<%@page import="java.sql.Date"%>
<%@ page import="supportClasses.DatabaseInteraction" %>
<%@ page import="supportClasses.OakDatabaseException" %>
<%

// login expiry time 
// 600000 = 10 min
int milliSecondsTillLoginExpired = 600000;

request.getSession().setAttribute("loginStatus", "failed");

// check if there is a post request
String postOrigin = request.getParameter("postOrigin");
if(postOrigin == null)
{
	// no post request
	// check if login is not expired
	Object loggedInTimestamp = request.getSession().getAttribute("loggedInTimestamp");
	if(loggedInTimestamp != null)
	{
		long timeSinceLogin = (System.currentTimeMillis() % 1000 ) - (Long) loggedInTimestamp;
		
		if(timeSinceLogin > milliSecondsTillLoginExpired)
		{
			// the previous login is expired, new login is required
			request.getSession().setAttribute("loginStatus", "expired");
		}
		else // login is still valid
		{
			request.getSession().setAttribute("loginStatus", "succeeded");
		}
	}
	else
	{
		// a fresh, first time login is required
		request.getSession().setAttribute("loginStatus", "fresh");
	}
}
else if(postOrigin.equals("login_form"))
{
	// replacealls zijn om SQL injection tegen te gaan
	// TODO nog meer anti SQL injection
	String account = request.getParameter("account").replaceAll("'", "''");
	String password = request.getParameter("password").replaceAll("'", "''");
	
	DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
	
	
	boolean isCorrect;
	try 
	{
		isCorrect = dbInt.isCorrectPassword(account, password);
	} 
	catch (OakDatabaseException e) // usernaam is niet gevonden in de database
	{
		isCorrect = false;
	}
	
	// session variables setten
	if(isCorrect)
	{
		request.getSession().setAttribute("loggedInUserName", account);
		
		QueryResult queryResult = dbInt.getUserInfo(account);
		String userId = queryResult.iterator().next().get("id").toString();
		
		request.getSession().setAttribute("loggedInUserId", userId);
		
		request.getSession().setAttribute("loggedInTimestamp", System.currentTimeMillis() % 1000);
		request.getSession().setAttribute("loginStatus", "succeeded");
	}
	else // login failed
	{
		request.getSession().removeAttribute("loggedInUserName");
		request.getSession().removeAttribute("loggedInUserId");
		request.getSession().removeAttribute("loggedInTimestamp");
		request.getSession().setAttribute("loginStatus", "failed");
	}
	
}

%>