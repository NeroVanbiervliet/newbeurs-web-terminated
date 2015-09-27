<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<!-- at compile time -->
<%@ include file="import.jsp" %>
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
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			
			<title>Adjust title!</title>
		</head>
		<body>
			<!-- at runtime -->
			<jsp:include page="header.jsp" />
			
			<!-- at runtime TODO compile time van maken?  -->
			<jsp:include page="navigation.html" />
			
			<table>
			<% 
				DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
				QueryResult queryResult = dbInt.getAllTableEntries("simulation");
				
				out.write("<tr>");
				for(String columnName : queryResult.getColumnNames())
				{
					out.write(String.format("<th>%s</th>",columnName));
				}
				out.write("</tr>");
				
				for(HashMap<String,Object> simulation : queryResult)
				{
					out.write("<tr>");
					for(String key : simulation.keySet())
					{
						if(simulation.get(key) != null)
						{
							out.write(String.format("<td>%s</td>",simulation.get(key).toString()));
						}
						else
						{
							out.write("<td></td>");
						}
					}
					out.write("</tr>");
				}
			%>
			</table>
			
		</body>
		
	<%} %>
</html>