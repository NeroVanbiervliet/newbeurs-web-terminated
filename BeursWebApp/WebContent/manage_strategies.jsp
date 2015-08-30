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
			<!-- TODO moet hier niet bij dat het javascript is? -->
			<script>
				function sendInfo(checkbox)
				{
					var checkState = checkbox.checked.toString();
					var id = checkbox.value.toString();
					document.getElementById("testDiv").innerHTML = id.concat(checkState);
				}
			</script>
		</head>
		<body>
			<!-- at runtime -->
			<jsp:include page="header.jsp" />
			
			<!-- at runtime TODO compile time van maken?  -->
			<jsp:include page="navigation.html" />
			
			<% 	
				// NEED moet user webapp worden
				DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","root");
				
				// getting entries from strategy table
				QueryResult queryResult = dbInt.getAllTableEntries("strategy");
				
				// making form
				out.write("<form>");
				
				// adding checkboxes
				// <input type=\"checkbox\" name=\"strategy\" value=\"%s\" checked> I have a car<br>
				for(HashMap<String, Object> row : queryResult)
				{
					if((Boolean) row.get("isActive"))
					{
						out.write(String.format("<input type=\"checkbox\" name=\"strategy\" value=\"%s\" onchange=\"sendInfo(this)\" checked>",row.get("id")));
					}
					else
					{
						out.write(String.format("<input type=\"checkbox\" name=\"strategy\" value=\"%s\">",row.get("id")));
					}
					
					out.write((String)row.get("name") + "<br>");
				}
				
				// closing form
				out.write("</form>");
			%>
			
			<div id="testDiv"></div>
			
		</body>
		
	<%} %>
</html>