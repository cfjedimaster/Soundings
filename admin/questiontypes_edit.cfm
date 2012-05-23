<cfsetting enablecfoutputonly=true>
<!---
	Name         : questiontypes_edit.cfm
	Author       : Raymond Camden 
	Created      : September 7, 2004
	Last Updated : September 7, 2004
	History      : 
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<!--- Security Check --->
<cfif not isBoolean(session.user.isAdmin) or not session.user.isAdmin>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<cfif isDefined("form.cancel") or not isDefined("url.id")>
	<cflocation url="questiontypes.cfm" addToken="false">
</cfif>

<cfscript>
function validHandlerRoot(s) {
	if(reFindNoCase("[^a-z0-9]",s)) return false;
	return true;
}
</cfscript>

<cfif isDefined("form.save")>
	<cfset form = request.udf.cleanStruct(form)>
	<cfset errors = "">
	<cfif not len(form.name)>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(form.handlerRoot) or not validHandlerRoot(form.handlerRoot)>
		<cfset errors = errors & "You must specify a valid handler root. This must be a string of letters or numbers with no spaces.<br>">
	</cfif>
	
	<cfif not len(errors)>

		<cfif url.id neq 0>
			<cfset application.questionType.updateQuestionType(url.id, form.name, form.handlerRoot)>
		<cfelse>
			<cfset application.questionType.addQuestionType(form.name, form.handlerRoot)>
		</cfif>
				
		<cfset msg = "QuestionType, #form.name#, has been updated.">
		<cflocation url="questiontypes.cfm?msg=#urlEncodedFormat(msg)#">
	</cfif>
</cfif>

<!--- get questionType if not new --->
<cfif url.id gte 1>
	<cfset qt = application.questionType.getQuestionType(url.id)>
	<cfparam name="form.name" default="#qt.name#">
	<cfparam name="form.handlerRoot" default="#qt.handlerRoot#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.handlerRoot" default="">
</cfif>

<tags:layout templatename="admin" title="QuestionType Editor">

<cfoutput>
<p>
Please use the form below to enter details about the QuestionType. All required fields are marked (*). QuestionTypes
allow you to define the types of questions in use by Soundings. The handlerroot should be a folder underneath the handlers folder.
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
		<td align="right"><b>(*) Handler Root:</b></td>
		<td><input type="text" name="handlerRoot" value="#form.handlerRoot#" size="50"></td>
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