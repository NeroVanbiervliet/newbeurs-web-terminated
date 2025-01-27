<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- at compile time -->
<%@ include file="import.jsp" %>
<%@ page import="java.lang.Runtime" %>

<html>
	<!-- check for logged in user -->
	<!-- at compile time -->
	<%@ include file="login_checker.jsp" %>
	
	<!--  TODO form resubmission http://stackoverflow.com/questions/3923904/preventing-form-resubmission -->
	<% 	String loginStatus = (String) request.getSession().getAttribute("loginStatus");
		if(!loginStatus.equals("succeeded")){ %>
		<jsp:include page="login_form.jsp" >
		    <jsp:param name="loginStatus" value="${loginStatus}" />
		</jsp:include>
	<%} 
		else // logInStatus is succeeded
		{%>
		
		<!-- main content of page -->
		<head>
			<link rel="shortcut icon" href="images/oak_o_logo.ico">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>Kill simulation</title>
			<!-- TODO moet hier niet bij dat het javascript is? -->
			
		</head>
		<body>
			<!-- at runtime -->
			<jsp:include page="header.jsp" />
			
			<!-- at runtime TODO compile time van maken?  -->
			<jsp:include page="navigation.html" />
			
			<%
				// TODO als simulation gekilled wordt PID verwijderen uit db
				// volgende keer dat persoon zelfde sim wil killen zeggen dat die al gekilled is
				// zo kan je niet per ongeluk andere processen killen (PID herbruikt)
			
				String simId = request.getParameter("simId").toString();
				DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
				QueryResult queryResult = dbInt.executeQuery(String.format("SELECT * FROM simulation WHERE id=%s",simId));
				try
				{			
					String PID = queryResult.iterator().next().get("PID").toString();
					Runtime.getRuntime().exec("kill " + PID);	
					out.write("Simulation terminated.");
					
					dbInt.executeQuery(String.format("UPDATE simulation SET status='stopped' WHERE id=%s",simId));
				}
				catch(Exception e)
				{
					out.write("No PID found. Are you trying to kill a simulation that is already finished?");
				}
			%>

		</body>
		
	<%} %>
</html>