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
	String simulationName = "greece";
	String simulationdescription = "griekenland jongeuh";
	String userId = "1";
	String strategyId = "1";
	String methodName = "test";
	String methodArguments = "15 20";
	String simulationId = "1";
	
	DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
	//dbInt.addSimulation(simulationName, simulationdescription, userId, strategyId);
	
	// bash process launcher
	ProcessBuilder b = new ProcessBuilder("/bin/bash","/home/nero/GIT/",methodName,methodArguments,simulationId);
	b.start();
	
	
	out.write("done");
%>