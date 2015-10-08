/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.47
 * Generated at: 2015-10-08 21:09:56 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.util.HashMap;
import java.io.*;
import java.util.*;
import supportClasses.DatabaseInteraction;
import supportClasses.QueryResult;

public final class launch_005fsimulation_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(1);
    _jspx_dependants.put("/import.jsp", Long.valueOf(1444134208000L));
  }

  private javax.el.ExpressionFactory _el_expressionfactory;
  private org.apache.tomcat.InstanceManager _jsp_instancemanager;

  public java.util.Map<java.lang.String,java.lang.Long> getDependants() {
    return _jspx_dependants;
  }

  public void _jspInit() {
    _el_expressionfactory = _jspxFactory.getJspApplicationContext(getServletConfig().getServletContext()).getExpressionFactory();
    _jsp_instancemanager = org.apache.jasper.runtime.InstanceManagerFactory.getInstanceManager(getServletConfig());
  }

  public void _jspDestroy() {
  }

  public void _jspService(final javax.servlet.http.HttpServletRequest request, final javax.servlet.http.HttpServletResponse response)
        throws java.io.IOException, javax.servlet.ServletException {

    final javax.servlet.jsp.PageContext pageContext;
    javax.servlet.http.HttpSession session = null;
    final javax.servlet.ServletContext application;
    final javax.servlet.ServletConfig config;
    javax.servlet.jsp.JspWriter out = null;
    final java.lang.Object page = this;
    javax.servlet.jsp.JspWriter _jspx_out = null;
    javax.servlet.jsp.PageContext _jspx_page_context = null;


    try {
      response.setContentType("text/html");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write('\n');
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<!-- NEED veranderen voor server -->\n");
 String  pythonPath = "/home/nero/GIT/Bitbucket/pythonBeurs/"; 
      out.write('\n');
 //String  pythonPath = "/home/beurs/"; 
      out.write("\n");
      out.write("<link rel=\"stylesheet\" href=\"");
      out.write((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${pageContext.request.contextPath}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null, false));
      out.write("/CSS/style.css\" />");
      out.write('\n');

	// get post variables 
	String simulationName = request.getParameter("simulationName");
	String simulationDescription = request.getParameter("description");
	String strategyId = request.getParameter("strategyId");
	String userId = request.getSession().getAttribute("loggedInUserId").toString();
	String stockSelection = request.getParameter("stockSelection").toString();
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
		queryResult = dbInt.executeQuery(String.format("SELECT name FROM method WHERE id='%s'",methodId));
		String methodName = queryResult.iterator().next().get("name").toString();
		
		// bash process launcher
		ProcessBuilder b = new ProcessBuilder("/bin/bash",pythonPath+"WebSlaves/launch_new_task",methodName,methodArguments,simulationId,startDate,endDate);
		b.start();		
	
	

      out.write("\n");
      out.write("\n");
      out.write("<div class=\"alert alert-success ng-scope\">\n");
      out.write("\tsimulation started!\n");
      out.write("</div>\n");
      out.write("\n");

	}
	else
	{

      out.write("\n");
      out.write("\n");
      out.write("<div class=\"alert alert-danger ng-scope\">\n");
      out.write("\tname is not unique\n");
      out.write("</div>\n");
      out.write("\n");

	}

      out.write('\n');
    } catch (java.lang.Throwable t) {
      if (!(t instanceof javax.servlet.jsp.SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          try { out.clearBuffer(); } catch (java.io.IOException e) {}
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
