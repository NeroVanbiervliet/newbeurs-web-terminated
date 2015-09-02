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
			<!-- vervangen door lokale jquery (er staat al één in WEB-INF -->
			<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
			<script>			
				function updateInfo()
				{
					var strategyId = document.getElementById("strategySelector").value-1;
					var infoToShow = strategyInfo[strategyId];
					document.getElementById("strategyInfoBox").value = infoToShow;
				}
				
				// add event handler to form
				$( "#simulationForm" ).submit(function(event){
					 
					// Stop form from submitting normally
					event.preventDefault();
					
					var data = $('simulationForm').serialize();
					
					// Send the data using post
					$.post('launch_simulation.jsp', data,function(result){
			            $("#ajaxResult").html(result);
			            alert("ding");
			        });
					
					
				});
				
			</script>
		</head>
		<body onload="updateInfo()">
			<!-- at runtime -->
			<jsp:include page="header.jsp" />
			
			<!-- at runtime TODO compile time van maken?  -->
			<jsp:include page="navigation.html" />
			
			<form action="." id="simulationForm">
				<p>
					<label for="simulationName">Simulation name</label>
					<input type="text" name="simulationName">
				</p>
				
				<p>
					<label for="simulationDescription">Description</label>
					<input type="text" name="description">
				</p>
				
				<!-- build up array containing strategy descriptions -->
				<script>
					<% 
						DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
						QueryResult queryResult = dbInt.getAllTableEntries("strategy LEFT JOIN method ON strategy.method=method.id");
												
						// verbetering mogelijk
						// geklooi hieronder is omdat ik niet zeker ben dat bij for each over queryResult hij wel in volgorde van id overloopt	
							
						int numOfStrategies = queryResult.getNumOfEntries();
						String[] strategyDescriptions = new String[numOfStrategies];
						
						int index;
								
						for(HashMap<String,Object> strategy : queryResult)
						{
							// index is 1 minder dan id want index van array telt vanaf 0, id vanaf 1
							index = Integer.parseInt(strategy.get("id").toString())-1;
							strategyDescriptions[index] = strategy.get("description").toString();
						}
						
						// javascript array schrijven
						out.write("var strategyInfo = [");
						for(String description : strategyDescriptions)
						{
							out.write(String.format("\"%s\",",description));
						}
						// TODO laatste komma weghalen die na de laatste description wordt geprint
						out.write("];");
					%>
				</script>
				
				<p>
					
					
					<label for="strategy">Strategy</label>
					<select id="strategySelector" onchange="updateInfo()" name="strategy">
					<% 	
						// queryResult object already created in above code between script tags
						queryResult = dbInt.getAllTableEntries("strategy");
							
						for(HashMap<String,Object> strategy : queryResult)
						{
							// <option value="first_script.py">first_script.py</option>
							out.write(String.format("<option value=\"%s\">%s</option>",strategy.get("id"),strategy.get("name")));	
						}
					%>
					</select>
				</p>	
				
				<p>
					<label for="strategyInfoBox">Strategy readme</label>
					<textarea id="strategyInfoBox" readonly></textarea>
				</p>
				
				<p class="submit">			
					<input type="submit" value="initiate simulation">
				</p>
			</form>
			<div id="ajaxResult"></div>
		</body>
		
	<%} %>
</html>