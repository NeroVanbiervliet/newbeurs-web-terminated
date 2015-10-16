<div class="container ng-scope" ng-view="">
	<div class="alert alert-info">
		Welcome, <strong><%= request.getSession().getAttribute("loggedInUserName") %></strong>
	</div>

<!-- /div staat in footer -->