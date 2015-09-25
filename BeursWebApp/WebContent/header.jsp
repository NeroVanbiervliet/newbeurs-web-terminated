<div>
	Welcome, user <%= request.getSession().getAttribute("loggedInUserName") %>
	[userId=<%= request.getSession().getAttribute("loggedInUserId") %>]
</div>

