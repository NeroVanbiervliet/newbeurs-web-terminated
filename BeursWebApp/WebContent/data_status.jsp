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
			<link rel="shortcut icon" href="images/oak_o_logo.ico">
			<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
			<title>Data status</title>
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
			<style type="text/css">
				td,th
				{
				    padding:15px 15px 0 15px;
				}
			</style>
			<script>
				 $(document).ready( function() {
				 	$('.update-source-button').click(function(){
				    	
				 		var dataSourceId = $(this).parent().attr('id');
				 		var dataSourceScript = $(this).parent().attr('pyScript');
				 		var url = "startDataSourceUpdate.jsp";
		                
		                // Send the data using post 
		                // {deNaamDieJeAanDeDataWilGeven : jqueryVarMetData}
		                var posting = $.post(url, {dataSourceScript : dataSourceScript});
		                
		                // Put the results in a div
		                posting.done(function(data) {
		                    $("#"+dataSourceId).empty().append(data);
		                }); 
				     });
			     });
			</script>			
		</head>
		<body>
			<!-- at runtime -->
			<jsp:include page="header.jsp" />
			
			<!-- at runtime TODO compile time van maken?  -->
			<jsp:include page="navigation.html" />
			
			<div class="text-danger">Warning: check that no simulations using the data you want to update are currently running!</div>
			
			<table>
			
				<!-- table header -->
				<tr>
					<th>id</th>
					<th>script</th>
					<th>description</th>
					<th>last update</th>
				</tr>
			
				<%
					// TODO automatisch checken welke strategien die data gebruiken en update knop dan disabelen	
				
					// data ophalen
					DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
					String query = "SELECT * ";
					query += "FROM dataStatus ";
					query += "ORDER BY id ASC ";
					QueryResult queryResult = dbInt.executeQuery(query);
					
					// iterate over all entries
					for(HashMap<String,Object> dataSource : queryResult)
					{
						out.write("<tr>");
						
							// dataSource id
							out.write("<td>");
							String dataSourceId = dataSource.get("id").toString();
							out.write(dataSourceId);
							out.write("</td>");
							
							// dataSource script
							out.write("<td>");
							String dataSourceScript = dataSource.get("script").toString();
							out.write(dataSourceScript);
							out.write("</td>");
							
							// datSource description
							out.write("<td>");
							out.write(dataSource.get("description").toString());
							out.write("</td>");
							
							// dataSource last update
							out.write("<td>");
							out.write(dataSource.get("lastUpdated").toString().substring(0,10));
							out.write("</td>");
							
							// knop om te updaten
							out.write("<td>");
							out.write(String.format("<div id=\"%s\" pyScript=\"%s\"><input type=\"button\" class=\"btn btn-primary btn-xs update-source-button\" value=\"update\"></div>",dataSourceId,dataSourceScript));
							out.write("</td>");
							
						out.write("</tr>");
					}
				%> 
			</table>
			
			<!-- at runtime -->
			<jsp:include page="footer.jsp" />
		</body>
		
	<%} %>
</html>