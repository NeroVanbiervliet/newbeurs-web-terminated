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
			
				// internet code met eigen aanpassingen
				// TODO jQuery gebruiken voor ajax (simpelere code)
				
				reqObj=null;
		        function updateIsActive(checkbox)
		        {
		        	var checkState = checkbox.checked.toString();
					var id = checkbox.value.toString();
					
		            if(window.XMLHttpRequest){
		                reqObj=new XMLHttpRequest();
		            }else {
		                reqObj=new ActiveXObject("Microsoft.XMLHTTP");
		            }
		            
		            reqObj.onreadystatechange=process;
		            reqObj.open("POST","./update_strategy.jsp?id="+id+"&isActive="+checkState,true);
		            reqObj.send(null);
		        }
		        
		        function updateIsActive(checkbox)
		        {
		        	var checkState = checkbox.checked.toString();
					var id = checkbox.value.toString();
					
		            if(window.XMLHttpRequest){
		                reqObj=new XMLHttpRequest();
		            }else {
		                reqObj=new ActiveXObject("Microsoft.XMLHTTP");
		            }
		            
		            reqObj.onreadystatechange=process;
		            reqObj.open("POST","./update_strategy.jsp?id="+id+"&isActive="+checkState,true);
		            reqObj.send(null);
		        }
		        
		        function updateParameters(textbox)
		        {
		        	var id = textbox.id.toString();
		        	var parameters = textbox.value.toString();
		        	
		        	if(window.XMLHttpRequest){
		                reqObj=new XMLHttpRequest();
		            }else {
		                reqObj=new ActiveXObject("Microsoft.XMLHTTP");
		            }
		            
		            reqObj.onreadystatechange=process;
		            reqObj.open("POST","./update_strategy.jsp?id="+id+"&parameters="+parameters,true);
		            reqObj.send(null);
		        }
		        
		        function process(){
		            if(reqObj.readyState==4){
		                document.getElementById("ajaxResult").innerHTML=reqObj.responseText;
		            }
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
				
				// TODO knop naast elke checkbos om strategy te archiveren 
				// adding checkboxes and textboxes
				for(HashMap<String, Object> row : queryResult)
				{
					if((Boolean) row.get("isActive"))
					{
						// checkbox isActive, checked
						out.write(String.format("<input type=\"checkbox\" name=\"strategyCheckBox\" value=\"%s\" onchange=\"updateIsActive(this)\" checked>",row.get("id")));
						
					}
					else
					{
						// checkbox isActive, unchecked
						out.write(String.format("<input type=\"checkbox\" name=\"strategy\" value=\"%s\" onchange=\"updateIsActive(this)\">",row.get("id")));
					}
					
					out.write((String)row.get("name"));
					// textbox parameters
					out.write(String.format("<input type=\"text\" name=\"strategyTextBox\" onblur=\"updateParameters(this)\" id=\"%s\" value=\"%s\">",row.get("id"),row.get("parameters")));
					// TODO veranderen door div rond elke strategie of zo
					out.write("<br>");
					// TODO description nog tonen zodat je weet wat welk argument wil zeggen
				}
				
				// closing form
				out.write("</form>");
			%>
			
			<!-- displays the result of the ajax request -->
			<!-- TODO maken dat de tekst die zegt dat de veranderingen opgeslaan zijn terug weg gaat na een paar seconden -->
			<div id="ajaxResult"></div>
			
		</body>
		
	<%} %>
</html>