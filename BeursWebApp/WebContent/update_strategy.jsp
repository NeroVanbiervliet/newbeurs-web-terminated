<%@ include file="import.jsp" %>
<%
	// TODO lijn hieronder weggedaan, waarom zou je 5 seconden moeten sleepen? 
	// try{Thread.sleep(5000);}catch(Exception e){}
	String id = request.getParameter("id");
	String isActive = request.getParameter("isActive");
	
	// in de sql server aanpassen
	// TODO root weg, webapp
	DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","root");
	dbInt.setIsActive(id, isActive);
	
	out.write("Changes saved");
%>