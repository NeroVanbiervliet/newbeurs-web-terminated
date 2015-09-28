<div class="container ng-scope" ng-view="">
	<div class="alert alert-info">
		Welcome, user <%= request.getSession().getAttribute("loggedInUserName") %>
		[userId=<%= request.getSession().getAttribute("loggedInUserId") %>]
	</div>

<!-- /div staat in footer -->