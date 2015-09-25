<!-- at compile time -->
<%@ include file="import.jsp" %>
<%
	// get post variables NEED uncommenten
	//String simulationName = request.getParameter("simulationName");
	//String simulationDescription = request.getParameter("simulationDescription");
	//String strategyId = request.getParameter("strategyId");
	//String userId = request.getSession().getAttribute("loggedInUserId").toString();
	// NEED: methodName
	// NEED: methodArguments
	// NEED: simulationId -> NA toevoegen in de database simulatierecord terug uit db halen om id te weten
	
	// demo data NEED verwijderen
	String simulationName = "greece15";
	String simulationdescription = "griekenland jongeuh";
	String userId = "1";
	String strategyId = "1";
	String methodName = "test";
	String methodArguments = "15 20";
	
	DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
	dbInt.addSimulation(simulationName, simulationdescription, userId, strategyId);
	
	// TODO kan voor race condition zorgen als naam van sim veranderd is ondertussen
	QueryResult queryResult = dbInt.executeQuery(String.format("SELECT id FROM simulation WHERE name='%s'",simulationName));
	String simulationId = queryResult.iterator().next().get("id").toString();
	
	// bash process launcher
	ProcessBuilder b = new ProcessBuilder("/bin/bash","/home/nero/GIT/Bitbucket/NewbeursPython/WebSlaves/launch_new_task",methodName,methodArguments,simulationId);
	b.start();
	
	out.write(request.getParameter("simulationName"));
	out.write("jquery done");
%>