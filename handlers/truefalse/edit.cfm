<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/truefalse/edit.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : October 7, 2005
	History      : try/catch
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.yesno" default="false">

<cfif isDefined("attributes.question")>
	<cfparam name="form.question" default="#attributes.question.question#">
	<cfparam name="form.rank" default="#attributes.question.rank#">
	<cfparam name="form.required" default="#attributes.question.required#">
<cfelse>
	<cfparam name="form.question" default="">
	<cfparam name="form.rank" default="#attributes.toprank+1#">
	<cfparam name="form.required" default="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset form = request.udf.cleanStruct(form)>
	<cfset errors = "">

	<cfif not len(form.question)>
		<cfset errors = errors & "You must enter a question.<br>">
	</cfif>
	
	<cfif form.rank is "" or not isNumeric(form.rank) or form.rank lte 0>
		<cfset errors = errors & "Rank must be 1 or above.<br>">
	</cfif>
		
	<cfif not len(errors)>
		<cftry>
			<cfif not isDefined("attributes.question")>
				<cfset qid = application.question.addQuestion(question=form.question,rank=form.rank,required=form.required,surveyidfk=attributes.surveyidfk,questiontypeidfk=attributes.questionType.id)>
			<cfelse>
				<cfset application.question.updateQuestion(id=attributes.question.id,question=form.question,rank=form.rank,required=form.required,surveyidfk=attributes.surveyidfk,questiontypeidfk=attributes.questiontype.id)>
				<cfset qid = attributes.question.id>
			</cfif>

			<cfinclude template="../nextquestionlogic.cfm">

			<cfset msg = "Your question has been saved.">
			<cflocation url="questions.cfm?surveyidfk=#attributes.surveyidfk#&msg=#urlEncodedFormat(msg)#" addToken="false">
			<cfcatch>
				<cfset errors = cfcatch.message>
			</cfcatch>
		</cftry>

	</cfif>
	
</cfif>

<cfoutput>

<cfif attributes.yesno>
	<p>
	Please use the form below to edit the Yes/No question. You only need to enter the question and the rank.
	</p>
<cfelse>
	<p>
	Please use the form below to edit the True/False question. You only need to enter the question and the rank.
	</p>
</cfif>

<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#attributes.queryString#" method="post">
<table cellspacing=0 cellpadding=5 class="adminEditTable" width="100%">
	<tr valign="top">
		<td width="200"><b>(*) Question:</b></td>
		<td><input type="text" name="question" value="#form.question#" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>(*) Rank:</b></td>
		<td><input type="text" name="rank" value="#form.rank#" size="2"></td>
	</tr>
	<tr valign="top">
		<td><b>(*) Required:</b></td>
		<td>
			<input type="radio" name="required" value="true" <cfif form.required>checked</cfif>>Yes<br>	
			<input type="radio" name="required" value="false" <cfif not form.required>checked</cfif>>No<br>
		</td>
	</tr>
	<cfinclude template="../nextquestion.cfm">
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="Save"> <input type="submit" name="cancel" value="Cancel"></td>
	</tr>
</table>
</form>
</p>

</cfoutput>

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">