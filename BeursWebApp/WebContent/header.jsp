<div>
	Welcome, user <%= request.getSession().getAttribute("loggedInUserName") %>
	[<% request.getSession().getAttribute("loggedInUserId"); %>]
</div>

