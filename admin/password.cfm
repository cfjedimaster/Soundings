<cfsetting enablecfoutputonly=true>
<!---
	Name         : password.cfm
	Author       : Raymond Camden 
	Created      : September 01, 2004
	Last Updated : October 8, 2005
	History      : Refresh settings on pword change (10/8/05)
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<cfif isDefined("form.cancel")>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset errors = "">
	<!---
	<cfif hash(form.oldpassword) is not application.settings.password>
		<cfset errors = errors & "The old password did not match.<br>">
	</cfif>
	--->
	<cfif not len(form.newpassword) or form.newpassword neq form.newpassword2>
		<cfset errors = errors & "Your new password was blank or did not match the confirmation.<br>">
	</cfif>
	<cfif not len(errors)>
		<cftry>
			<cfset application.user.updatePassword(session.user.username,form.oldpassword,form.newpassword)>
			<cfset msg = "Your password has been updated.">
			<cfcatch>
				<cfset errors = cfcatch.message>
			</cfcatch>
		</cftry>
	</cfif>	
</cfif>

<tags:layout templatename="admin" title="Set Password">

<cfoutput>
<p>
Use the form below to update your password. You must enter the old password first.
</p>

<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<cfif isDefined("msg")>
	<p><b>#msg#</b></p>
<cfelse>
<form action="#cgi.script_name#" method="post">
<table cellspacing=0 cellpadding=5 class="adminEditTable" width="500">
	<tr valign="top">
		<td width="200"><b>(*) Old Password:</b></td>
		<td><input type="password" name="oldpassword" value="" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>(*) New Password:</b></td>
		<td><input type="password" name="newpassword" value="" size="50"></td>
	</tr>
	<tr valign="top">
		<td nowrap="true"><b>(*) Confirm Password:</b></td>
		<td><input type="password" name="newpassword2" value="" size="50"></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="Save"> <input type="submit" name="cancel" value="Cancel"></td>
	</tr>
</table>
</form>
</p>
</cfif>
</cfoutput>

</tags:layout>

<cfsetting enablecfoutputonly=false>