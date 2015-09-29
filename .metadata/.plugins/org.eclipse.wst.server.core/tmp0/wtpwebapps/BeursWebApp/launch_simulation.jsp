<%@page import="java.util.HashMap"%>
<%@ page import="supportClasses.DatabaseInteraction" %>
<%@ page import="supportClasses.QueryResult" %>
<%
	// get post variables NEED uncommenten
	String simulationName = request.getParameter("simulationName");
	String simulationDescription = request.getParameter("description");
	String strategyId = request.getParameter("strategyId");
	String userId = request.getSession().getAttribute("loggedInUserId").toString();
	String startDate = request.getParameter("startDate").toString();
	String endDate = request.getParameter("endDate").toString();	

	// check if the name does not already exist in the database
	DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");	
	QueryResult queryResult = dbInt.getAllTableEntries("simulation");
	boolean simNameIsUnique = true;
	for(HashMap<String,Object> simulation : queryResult)
	{
		if(simulation.get("name").toString().equals(simulationName))
		{
			simNameIsUnique = false;
		}
	}
	
	
	if(simNameIsUnique)
	{
		dbInt.addSimulation(simulationName, simulationDescription, userId, strategyId);
		
		// TODO kan voor race condition zorgen als naam van sim veranderd is ondertussen
		queryResult = dbInt.executeQuery(String.format("SELECT id FROM simulation WHERE name='%s'",simulationName));
		String simulationId = queryResult.iterator().next().get("id").toString();
		
		// methodName en args halen uit strategy record uit database
		queryResult = dbInt.executeQuery(String.format("SELECT method, parameters FROM strategy WHERE id='%s'",strategyId));
		String methodId = queryResult.iterator().next().get("method").toString();
		String methodArguments = queryResult.iterator().next().get("parameters").toString();
		queryResult = dbInt.executeQuery(String.format("SELECT name FROM strategy WHERE id='%s'",methodId));
		String methodName = queryResult.iterator().next().get("name").toString();
		
		// bash process launcher
		// NEED url aanpassen
		ProcessBuilder b = new ProcessBuilder("/bin/bash","/home/nero/GIT/Bitbucket/pythonBeurs/WebSlaves/launch_new_task",methodName,methodArguments,simulationId,startDate,endDate);
		b.start();		
	
	
%>

<div class="alert alert-success ng-scope">
	simulation started!
</div>

<%
	}
	else
	{
%>

<div class="alert alert-danger ng-scope">
	name is not unique
</div>

<%
	}
%>
