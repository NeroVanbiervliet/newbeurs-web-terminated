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
			<title>Manage strategies</title>
			<!-- TODO moet hier niet bij dat het javascript is? -->
			<script>
			
				// internet code met eigen aanpassingen
				// TODO jQuery gebruiken voor ajax (simpelere code)
				// TODO jQuery gebruiken om event te triggeren ipv uit html jquery triggeren (zoals op init_sim.jsp: input stockSelection)
				
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
		                
		            	// TODO flashen van 'changes saved' nog oplossen
		            	
		            	document.getElementById("ajaxResult").innerHTML=reqObj.responseText;
		                
		                // na 3 seconden = 3000 ms terug de tekst weg doen
	                	window.setTimeout(function () {
	                		document.getElementById("ajaxResult").innerHTML="";
	                	}, 3000);
		            }
		        }
			</script>
		</head>
		<body>
			<!-- at runtime -->
			<jsp:include page="header.jsp" />
			
			<!-- at runtime TODO compile time van maken?  -->
			<jsp:include page="navigation.html" />
			
			<form>
				<% 	
					DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
					
					// getting entries from strategy table
					QueryResult queryResult = dbInt.getAllTableEntries("strategy");

					// TODO knop naast elke checkbos om strategy te archiveren 
					// adding checkboxes and textboxes
					for(HashMap<String, Object> row : queryResult)
					{
						out.write("<p>");
						out.write(String.format("<label for=\"%s\">%s</label>",row.get("id").toString(),row.get("name").toString()));
						if((Boolean) row.get("isActive"))
						{
							// checkbox isActive, checked
							out.write(String.format("<input type=\"checkbox\" name=\"strategyCheckBox\" id=\"%s\" value=\"%s\" onchange=\"updateIsActive(this)\" checked>",row.get("id"),row.get("id")));
							
						}
						else
						{
							// checkbox isActive, unchecked
							out.write(String.format("<input type=\"checkbox\" name=\"strategy\" id=\"%s\" value=\"%s\" onchange=\"updateIsActive(this)\">",row.get("id"),row.get("id")));
						}
						
						// textbox parameters
						out.write(String.format("<input type=\"text\" name=\"strategyTextBox\" onblur=\"updateParameters(this)\" id=\"%s\" value=\"%s\">",row.get("id"),row.get("parameters")));

						out.write("</p>");
						// TODO description nog tonen zodat je weet wat welk argument wil zeggen
					}
				%>
			</form>
			<!-- displays the result of the ajax request -->
			<!-- TODO maken dat de tekst die zegt dat de veranderingen opgeslaan zijn terug weg gaat na een paar seconden -->
			<div id="ajaxResult"></div>
			<!-- at runtime -->
			<jsp:include page="footer.jsp" />
		</body>
		
	<%} %>
</html>