<cfsetting enablecfoutputonly=true>
<!---
	Name         : users.cfm
	Author       : Raymond Camden 
	Created      : August 3, 2007
	Last Updated : 
	History      : 
	Purpose		 : 
--->

<!--- Security Check --->
<cfif not isBoolean(session.user.isAdmin) or not session.user.isAdmin>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfimport taglib="../tags/" prefix="tags">

<cfparam name="form.surveyidfk" default="">

<tags:layout templatename="admin" title="User Editor">

	<!--- handle deletions --->
	<cfif isDefined("form.mark") and len(form.mark)>
		<cfloop index="id" list="#form.mark#">
			<cfset application.user.deleteUser(id)>
		</cfloop>
		<cfoutput>
		<p>
		<b>Users(s) deleted.</b>
		</p>
		</cfoutput>
	</cfif>
	
	<!--- get surveys --->
	<cfset users = application.user.getUsers()>

	<tags:datatable data="#users#" list="username" editlink="users_edit.cfm" linkcol="username" linkval="username" label="User">
		<tags:datacol colname="username" label="Username" width="200" />	
		<tags:datacol colname="isadmin" label="Admin" format="yesno" />	

	</tags:datatable>


</tags:layout>

<cfsetting enablecfoutputonly=false>