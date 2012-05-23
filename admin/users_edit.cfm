<cfsetting enablecfoutputonly=true>
<!---
	Name         : user_edit.cfm
	Author       : Raymond Camden 
	Created      : August 3, 2007
	Last Updated : 
	History      : 
--->
<cfimport taglib="../tags/" prefix="tags">

<!--- Security Check --->
<cfif not isBoolean(session.user.isAdmin) or not session.user.isAdmin>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif isDefined("form.cancel") or not isDefined("url.id")>
	<cflocation url="users.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset form = request.udf.cleanStruct(form)>
	<cfset errors = "">
	<cfif not len(form.username)>
		<cfset errors = errors & "You must specify a username.<br>">
	</cfif>
	<cfif url.id is 0 and not len(form.password)>
		<cfset errors = errors & "You must specify a password for a new user.<br>">
	</cfif>
		
	<cfif not len(errors)>

		<cfset data = structNew()>
		<cfset data.username = form.username>
		<cfif len(trim(form.password))>
			<cfset data.password = form.password>
		</cfif>
		<cfset data.isAdmin = form.isAdmin>
		
		<cftry>	
			<cfif url.id neq 0>
				<cfset user = application.user.getUser(url.id)>
				<cfset data.id = user.id>
				<cfset data.originalusername = user.username>
				<cfset application.user.updateUser(argumentCollection=data)>
			<cfelse>
				<cfset application.user.addUser(argumentCollection=data)>		
			</cfif>
			<cfset msg = "User, #form.username#, has been updated.">
			<cflocation url="users.cfm?msg=#urlEncodedFormat(msg)#" addToken="false">
			<cfcatch>
				<cfset errors = cfcatch.message><cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>
				
	</cfif>
</cfif>

<!--- get user if not new --->
<cfif url.id neq 0>
	<cfset user = application.user.getUser(url.id)>
	<cfparam name="form.username" default="#user.username#">
	<cfif not isBoolean(user.isAdmin) or not user.isAdmin>
		<cfparam name="form.isadmin" default="false">
	<cfelse>
		<cfparam name="form.isadmin" default="true">
	</cfif>
<cfelse>
	<cfparam name="form.username" default="">
	<cfparam name="form.isadmin" default="false">
</cfif>

<tags:layout templatename="admin" title="User Editor">

<cfoutput>
<p>
Please use the form below to enter details about the user. All required fields are marked (*). 
Because passwords are hashed in the database, you cannot set the current password. If you enter
a new password it will overwrite the old one.
</p>

<p>
Admin users are allowed to edit other users and work with question types. If you are working
with a user that should only create surveys, be sure to set Admin to false.
</p>

<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#cgi.query_string#" method="post" autocomplete="off">
<table cellspacing=0 cellpadding=5 class="adminEditTable" width="100%">
	<tr valign="top">
		<td width="200"><b>(*) Username:</b></td>
		<td><input type="text" name="username" value="#form.username#" size="50"></td>
	</tr>
	<tr valign="top">
		<td width="200"><b>(*) Admin:</b></td>
		<td>
		<input type="radio" name="isadmin" value="1" <cfif form.isAdmin>checked</cfif>>Yes<br />
		<input type="radio" name="isadmin" value="0" <cfif not form.isAdmin>checked</cfif>>No<br />
		
		</td>
	</tr>
	<tr valign="top">
		<td width="200"><b>New Password:</b></td>
		<td><input type="password" name="password" value="" size="50"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="Save">
		<input type="submit" name="cancel" value="Cancel"></td>
	</tr>
</table>
</form>
</p>
</cfoutput>

</tags:layout>

<cfsetting enablecfoutputonly=false>