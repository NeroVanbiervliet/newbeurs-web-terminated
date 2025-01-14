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
			<style type="text/css">
				td,th
				{
				    padding:0 15px 0 15px;
				}
			</style>
			<title>Stock category list</title>
			<!-- TODO moet hier niet bij dat het javascript is? -->
			
		</head>
		<body>
			<!-- at runtime -->
			<jsp:include page="header.jsp" />
			
			<!-- at runtime TODO compile time van maken?  -->
			<jsp:include page="navigation.html" />
			
			<h4>
				StockSelection manual
			</h4>
			<div>
				There are two ways to use the stock selector
				<ol>
					<li>
						Enter a collection of tickers [ticker1,ticker2,...,tickerN]. Tickers that are not found in the database are ignored. Mind the [square] brackets!<br>
						Example: [AUB.AX,EIG,AIZ] 
					</li>
					<li>
						Enter a number of restrictions {category1=value1,...,categoryN=valueN} the stocks should satisfy. Mind the {curly} brackets!<br>
						Example: {exchange=BRU,cap=small}
					</li>
				</ol>
			</div>
				
			<!-- TODO br niet netjes -->	
			<br>	
				
			<h4>
				List of possible categories and values
			</h4>
						
			<table>
				
				<!-- table header -->
				<tr>
					<th>category</th>
					<th>values occuring in database</th>
				</tr>
				
				<%
					HashMap<String,String> tableData = new HashMap<String,String>();
					DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real");
					String query = "SELECT criterium,value,COUNT(value) as count FROM stockCategory GROUP BY value ORDER BY count DESC;";
					QueryResult queryResult = dbInt.executeQuery(query);
					
					String category;
					String value;
					String newValue;
					
					for(HashMap<String,Object> entry : queryResult)
					{
							category = entry.get("criterium").toString();
							value = entry.get("value").toString();
							
							if(tableData.keySet().contains(category))
							{
								newValue = tableData.get(category) + ", " + value;
								tableData.put(category, newValue);
							}
							else
							{
								tableData.put(category, value);
							}
					}		
					
					// itereren over tableData
					for(String key : tableData.keySet())
					{
						String values = tableData.get(key);
						// max number of characters the values string can be long
						int maxLength = 100;
						
						// check if values string is not to long
						if(values.length() > maxLength)
						{
							values = values.substring(0,maxLength) + " (...)";
						}
						
						out.write("<tr>");
							out.write("<td>");
							out.write(key);
							out.write("</td>");
							
							out.write("<td>");
							out.write(values);
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