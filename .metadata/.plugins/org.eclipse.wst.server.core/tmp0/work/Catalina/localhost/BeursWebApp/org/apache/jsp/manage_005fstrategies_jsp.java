/*
 * Generated by the Jasper component of Apache Tomcat
 * Version: Apache Tomcat/7.0.47
 * Generated at: 2015-10-08 21:49:28 UTC
 * Note: The last modified time of this file was set to
 *       the last modified time of the source file after
 *       generation to assist with modification tracking.
 */
package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;
import java.io.*;
import java.util.*;
import supportClasses.DatabaseInteraction;
import supportClasses.QueryResult;
import com.sun.corba.se.spi.ior.Writeable;
import supportClasses.QueryResult;
import java.sql.Date;
import supportClasses.DatabaseInteraction;
import supportClasses.OakDatabaseException;

public final class manage_005fstrategies_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final javax.servlet.jsp.JspFactory _jspxFactory =
          javax.servlet.jsp.JspFactory.getDefaultFactory();

  private static java.util.Map<java.lang.String,java.lang.Long> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.HashMap<java.lang.String,java.lang.Long>(2);
    _jspx_dependants.put("/import.jsp", Long.valueOf(1444134208000L));
    _jspx_dependants.put("/login_checker.jsp", Long.valueOf(1444134186000L));
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
      response.setContentType("text/html; charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;

      out.write("\n");
      out.write("<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">\n");
      out.write("<!-- at compile time -->\n");
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
      out.write("\n");
      out.write("\n");
      out.write("<html>\n");
      out.write("\t<!-- check for logged in user -->\n");
      out.write("\t<!-- at compile time -->\n");
      out.write("\t");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");


// login expiry time 
// 600000 = 10 min
int milliSecondsTillLoginExpired = 600000;

request.getSession().setAttribute("loginStatus", "failed");

// check if there is a post request
String postOrigin = request.getParameter("postOrigin");
if(postOrigin == null)
{
	// no post request
	// check if login is not expired
	Object loggedInTimestamp = request.getSession().getAttribute("loggedInTimestamp");
	if(loggedInTimestamp != null)
	{
		long timeSinceLogin = (System.currentTimeMillis() % 1000 ) - (Long) loggedInTimestamp;
		
		if(timeSinceLogin > milliSecondsTillLoginExpired)
		{
			// the previous login is expired, new login is required
			request.getSession().setAttribute("loginStatus", "expired");
		}
		else // login is still valid
		{
			request.getSession().setAttribute("loginStatus", "succeeded");
		}
	}
	else
	{
		// a fresh, first time login is required
		request.getSession().setAttribute("loginStatus", "fresh");
	}
}
else if(postOrigin.equals("login_form"))
{
	// replacealls zijn om SQL injection tegen te gaan
	// TODO nog meer anti SQL injection
	String account = request.getParameter("account").replaceAll("'", "''");
	String password = request.getParameter("password").replaceAll("'", "''");
	
	DatabaseInteraction dbInt = new DatabaseInteraction("backtest_real","webapp");
	
	
	boolean isCorrect;
	try 
	{
		isCorrect = dbInt.isCorrectPassword(account, password);
	} 
	catch (OakDatabaseException e) // usernaam is niet gevonden in de database
	{
		isCorrect = false;
	}
	
	// session variables setten
	if(isCorrect)
	{
		request.getSession().setAttribute("loggedInUserName", account);
		
		QueryResult queryResult = dbInt.getUserInfo(account);
		String userId = queryResult.iterator().next().get("id").toString();
		
		request.getSession().setAttribute("loggedInUserId", userId);
		
		request.getSession().setAttribute("loggedInTimestamp", System.currentTimeMillis() % 1000);
		request.getSession().setAttribute("loginStatus", "succeeded");
	}
	else // login failed
	{
		request.getSession().removeAttribute("loggedInUserName");
		request.getSession().removeAttribute("loggedInUserId");
		request.getSession().removeAttribute("loggedInTimestamp");
		request.getSession().setAttribute("loginStatus", "failed");
	}
	
}


      out.write("\n");
      out.write("\t\n");
      out.write("\t<!--  TODO form resubmission http://stackoverflow.com/questions/3923904/preventing-form-resubmission -->\n");
      out.write("\t");
 	String loginStatus = (String) request.getSession().getAttribute("loginStatus");
		if(!loginStatus.equals("succeeded")){ 
      out.write('\n');
      out.write('	');
      out.write('	');
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "login_form.jsp" + "?" + org.apache.jasper.runtime.JspRuntimeLibrary.URLEncode("loginStatus", request.getCharacterEncoding())+ "=" + org.apache.jasper.runtime.JspRuntimeLibrary.URLEncode((java.lang.String) org.apache.jasper.runtime.PageContextImpl.proprietaryEvaluate("${loginStatus}", java.lang.String.class, (javax.servlet.jsp.PageContext)_jspx_page_context, null, false), request.getCharacterEncoding()), out, false);
      out.write('\n');
      out.write('	');
} 
		else // logInStatus is succeeded
		{
      out.write("\n");
      out.write("\t\t\n");
      out.write("\t\t<!-- main content of page -->\n");
      out.write("\t\t<head>\n");
      out.write("\t\t\t<link rel=\"shortcut icon\" href=\"images/oak_o_logo.ico\">\n");
      out.write("\t\t\t<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">\n");
      out.write("\t\t\t<title>Manage strategies</title>\n");
      out.write("\t\t\t<!-- TODO moet hier niet bij dat het javascript is? -->\n");
      out.write("\t\t\t<script>\n");
      out.write("\t\t\t\n");
      out.write("\t\t\t\t// internet code met eigen aanpassingen\n");
      out.write("\t\t\t\t// TODO jQuery gebruiken voor ajax (simpelere code)\n");
      out.write("\t\t\t\t// TODO jQuery gebruiken om event te triggeren ipv uit html jquery triggeren (zoals op init_sim.jsp: input stockSelection)\n");
      out.write("\t\t\t\t\n");
      out.write("\t\t\t\treqObj=null;\n");
      out.write("\t\t        function updateIsActive(checkbox)\n");
      out.write("\t\t        {\n");
      out.write("\t\t        \tvar checkState = checkbox.checked.toString();\n");
      out.write("\t\t\t\t\tvar id = checkbox.value.toString();\n");
      out.write("\t\t\t\t\t\n");
      out.write("\t\t            if(window.XMLHttpRequest){\n");
      out.write("\t\t                reqObj=new XMLHttpRequest();\n");
      out.write("\t\t            }else {\n");
      out.write("\t\t                reqObj=new ActiveXObject(\"Microsoft.XMLHTTP\");\n");
      out.write("\t\t            }\n");
      out.write("\t\t            \n");
      out.write("\t\t            reqObj.onreadystatechange=process;\n");
      out.write("\t\t            reqObj.open(\"POST\",\"./update_strategy.jsp?id=\"+id+\"&isActive=\"+checkState,true);\n");
      out.write("\t\t            reqObj.send(null);\n");
      out.write("\t\t        }\n");
      out.write("\t\t        \n");
      out.write("\t\t        function updateIsActive(checkbox)\n");
      out.write("\t\t        {\n");
      out.write("\t\t        \tvar checkState = checkbox.checked.toString();\n");
      out.write("\t\t\t\t\tvar id = checkbox.value.toString();\n");
      out.write("\t\t\t\t\t\n");
      out.write("\t\t            if(window.XMLHttpRequest){\n");
      out.write("\t\t                reqObj=new XMLHttpRequest();\n");
      out.write("\t\t            }else {\n");
      out.write("\t\t                reqObj=new ActiveXObject(\"Microsoft.XMLHTTP\");\n");
      out.write("\t\t            }\n");
      out.write("\t\t            \n");
      out.write("\t\t            reqObj.onreadystatechange=process;\n");
      out.write("\t\t            reqObj.open(\"POST\",\"./update_strategy.jsp?id=\"+id+\"&isActive=\"+checkState,true);\n");
      out.write("\t\t            reqObj.send(null);\n");
      out.write("\t\t        }\n");
      out.write("\t\t        \n");
      out.write("\t\t        function updateParameters(textbox)\n");
      out.write("\t\t        {\n");
      out.write("\t\t        \tvar id = textbox.id.toString();\n");
      out.write("\t\t        \tvar parameters = textbox.value.toString();\n");
      out.write("\t\t        \t\n");
      out.write("\t\t        \tif(window.XMLHttpRequest){\n");
      out.write("\t\t                reqObj=new XMLHttpRequest();\n");
      out.write("\t\t            }else {\n");
      out.write("\t\t                reqObj=new ActiveXObject(\"Microsoft.XMLHTTP\");\n");
      out.write("\t\t            }\n");
      out.write("\t\t            \n");
      out.write("\t\t            reqObj.onreadystatechange=process;\n");
      out.write("\t\t            reqObj.open(\"POST\",\"./update_strategy.jsp?id=\"+id+\"&parameters=\"+parameters,true);\n");
      out.write("\t\t            reqObj.send(null);\n");
      out.write("\t\t        }\n");
      out.write("\t\t        \n");
      out.write("\t\t        function process(){\n");
      out.write("\t\t            if(reqObj.readyState==4){\n");
      out.write("\t\t                \n");
      out.write("\t\t            \t// TODO flashen van 'changes saved' nog oplossen\n");
      out.write("\t\t            \t\n");
      out.write("\t\t            \tdocument.getElementById(\"ajaxResult\").innerHTML=reqObj.responseText;\n");
      out.write("\t\t                \n");
      out.write("\t\t                // na 3 seconden = 3000 ms terug de tekst weg doen\n");
      out.write("\t                \twindow.setTimeout(function () {\n");
      out.write("\t                \t\tdocument.getElementById(\"ajaxResult\").innerHTML=\"\";\n");
      out.write("\t                \t}, 3000);\n");
      out.write("\t\t            }\n");
      out.write("\t\t        }\n");
      out.write("\t\t\t</script>\n");
      out.write("\t\t</head>\n");
      out.write("\t\t<body>\n");
      out.write("\t\t\t<!-- at runtime -->\n");
      out.write("\t\t\t");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "header.jsp", out, false);
      out.write("\n");
      out.write("\t\t\t\n");
      out.write("\t\t\t<!-- at runtime TODO compile time van maken?  -->\n");
      out.write("\t\t\t");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "navigation.html", out, false);
      out.write("\n");
      out.write("\t\t\t\n");
      out.write("\t\t\t<form>\n");
      out.write("\t\t\t\t");
 	
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
				
      out.write("\n");
      out.write("\t\t\t</form>\n");
      out.write("\t\t\t<!-- displays the result of the ajax request -->\n");
      out.write("\t\t\t<!-- TODO maken dat de tekst die zegt dat de veranderingen opgeslaan zijn terug weg gaat na een paar seconden -->\n");
      out.write("\t\t\t<div id=\"ajaxResult\"></div>\n");
      out.write("\t\t\t<!-- at runtime -->\n");
      out.write("\t\t\t");
      org.apache.jasper.runtime.JspRuntimeLibrary.include(request, response, "footer.jsp", out, false);
      out.write("\n");
      out.write("\t\t</body>\n");
      out.write("\t\t\n");
      out.write("\t");
} 
      out.write("\n");
      out.write("</html>");
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
