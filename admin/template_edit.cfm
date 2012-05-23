<cfsetting enablecfoutputonly=true>
<!---
	Name         : template.cfm
	Author       : Raymond Camden 
	Created      : December 9, 2008
	Last Updated : December 9, 2008
	History      : 
	Purpose		 : 
--->

<cfimport taglib="../tags/" prefix="tags">

<cfif isDefined("form.cancel") or not isDefined("url.id")>
	<cflocation url="templates.cfm" addToken="false">
</cfif>

<!--- get template if not new --->
<cfif url.id neq "0">
	<cfif not session.user.isAdmin>
		<cfset t = application.template.getTemplate(url.id,session.user.id)>
	<cfelse>
		<cfset t = application.template.getTemplate(url.id)>
	</cfif>
	<cfparam name="form.name" default="#t.name#">
	<cfparam name="form.header" default="#t.header#">
	<cfparam name="form.footer" default="#t.footer#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.header" default="">
	<cfparam name="form.footer" default="">
</cfif>
<cfif isDefined("form.save")>
	<cfset errors = "">
	<cfif not len(form.name)>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<!--- I don't care about header or footer, they can leave blank if they want... --->
	
	<cfif not len(errors)>

		<cfif url.id neq 0>
			<cfset application.template.updateTemplate(url.id, form.name, form.header, form.footer, t.useridfk)>
		<cfelse>
			<cfset application.template.addTemplate(form.name, form.header, form.footer, session.user.id)>
		</cfif>
				
		<cfset msg = "Template, #form.name#, has been updated.">
		<cflocation url="templates.cfm?msg=#urlEncodedFormat(msg)#">
	</cfif>
</cfif>

<tags:layout templatename="admin" title="Template Editor">

<cfoutput>
<p>
Please use the form below to enter details about the template. All required fields are marked (*). Templates
allow you to apply your own header and footer to a survey. Please see the documentation for CSS items used by
questions.
</p>

<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#cgi.query_string#" method="post">
<table width="100%" cellspacing=0 cellpadding=5 class="adminEditTable">
	<tr valign="top">
		<td align="right"><b>(*) Name:</b></td>
		<td><input type="text" name="name" value="#form.name#" size="50"></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Header:</b></td>
		<td><textarea name="header" rows=6 cols=35 wrap="soft">#form.header#</textarea></td>
	</tr>
	<tr valign="top">
		<td align="right"><b>Footer:</b></td>
		<td><textarea name="footer" rows=6 cols=35 wrap="soft">#form.footer#</textarea></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="Save"> <input type="submit" name="cancel" value="Cancel"></td>
	</tr>
</table>
</form>
</p>
</cfoutput>

</tags:layout>

<cfsetting enablecfoutputonly=false>