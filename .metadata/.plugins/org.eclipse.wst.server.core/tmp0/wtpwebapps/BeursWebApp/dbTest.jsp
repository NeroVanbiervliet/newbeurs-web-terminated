<%@ include file="import.jsp" %>
<%@page import="java.util.HashMap"%>
<%
	DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","root");
	QueryResult queryResult = dbInt.getAllTableEntries("user");
	for(HashMap<String,Object> entry : queryResult)
	{
		for(String key : entry.keySet())
		{
			out.write(entry.get(key).toString());
			out.write("<br>");
		}
		out.write("------------------------");
		out.write("<br>");
	}

%>