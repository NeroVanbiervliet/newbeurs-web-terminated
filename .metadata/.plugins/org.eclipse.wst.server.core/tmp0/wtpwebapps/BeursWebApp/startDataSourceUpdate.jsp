<%@ include file="import.jsp" %>
<%
	String dataSourceScript = request.getParameter("dataSourceScript");
	
	//bash process launcher
	ProcessBuilder b = new ProcessBuilder("/usr/bin/python",pythonPath+"DataUpdate/"+dataSourceScript);
	b.start();	 
%>

<div class="text-success">Update started</div>