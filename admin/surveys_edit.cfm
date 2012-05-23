<cfsetting enablecfoutputonly=true>
<!---
	Name         : survey_edit.cfm
	Author       : Raymond Camden 
	Created      : September 7, 2004
	Last Updated : March 30, 2006
	History      : support for clearing results (rkc 3/30/06)
--->
<cfimport taglib="../tags/" prefix="tags">

<cfif isDefined("form.cancel") or not isDefined("url.id")>
	<cflocation url="surveys.cfm" addToken="false">
</cfif>

<cfif isDefined("form.save")>
	<cfset form = request.udf.cleanStruct(form,"thankyoumsg")>
	<cfset errors = "">
	<cfif not len(form.name)>
		<cfset errors = errors & "You must specify a name.<br>">
	</cfif>
	<cfif not len(form.description)>
		<cfset errors = errors & "You must specify a description.<br>">
	</cfif>
	<cfif len(form.dateBegin) and not isDate(form.dateBegin)>
		<cfset errors = errors & "If you specify a survey starting date, it must be a valid date.<br>">
		<cfset form.dateBegin = "">
	</cfif>
	<cfif len(form.dateEnd) and not isDate(form.dateEnd)>
		<cfset errors = errors & "If you specify a survey ending date, it must be a valid date.<br>">
		<cfset form.dateEnd = "">
	</cfif>
	<cfif len(form.dateBegin) and isDate(form.dateBegin) and len(form.dateEnd) and isDate(form.dateEnd)
	      and dateCompare(form.dateBegin,form.dateEnd,"s") gte 0>
		<cfset errors = errors & "If you specify a survey starting and ending date, the start date must be before the ending date.<br>">
	</cfif>
	<cfif len(form.resultMailTo)>
		<cfloop index="e" list="#form.resultMailTo#">
			<cfif not isValid("email", e)>
				<cfset errors = errors & "The value to send results to must be a valid email address or a list of valid email addresses. #e# is not valid.<br>">
			</cfif>
		</cfloop>
	</cfif>
	<cfif len(form.questionsperpage) and (
			not isNumeric(form.questionsperpage)
				or
			form.questionsperpage lte 0
		)>
		<cfset errors = errors & "The value for questions per page must be numeric and positive.<br/>">
	</cfif> 
	<cfif form.active>
		<cfif url.id eq 0>
			<cfset errors = errors & "A new survey cannot be active. You must first add questions.<br>">
		<cfelse>
			<!--- get questions --->
			<cfset q = application.question.getQuestions(url.id)>
			<cfif q.recordCount is 0>
				<cfset errors = errors & "This survey cannot be marked active until questions are added.<br>">
			</cfif>
		</cfif>
	</cfif>
	
	<!--- Nuke the old list --->	
	<cfif isDefined("form.nukeEL")>
		<cfset application.survey.resetEmailList(url.id)>
	</cfif>
		
	<cfif not len(errors)>

		<cfset data = structNew()>
		<cfset data.name = form.name>
		<cfset data.description = form.description>
		<cfset data.active = form.active>
		<cfif isDate(form.dateBegin)>
			<cfset data.dateBegin = form.dateBegin>
		</cfif>
		<cfif isDate(form.dateEnd)>
			<cfset data.dateEnd = form.dateEnd>
		</cfif>
		<cfset data.resultMailTo = form.resultMailTo>
		<cfset data.surveyPassword = form.surveyPassword>
		<cfset data.thankYouMsg = form.thankYouMsg>
		
		<cfset data.templateidfk = form.templateidfk>
		<cfset data.allowembed = form.allowembed>
		<cfset data.showinpubliclist = form.showinpubliclist>
		<cfif form.questionsperpage neq "">
			<cfset data.questionsperpage = form.questionsperpage>
		</cfif>
			
		<cfif url.id neq 0>
			<cfset data.id = url.id>
			<cfset application.survey.updateSurvey(argumentCollection=data)>
		<cfelse>
			<cfset data.useridfk = session.user.id>
			<cfset url.id = application.survey.addSurvey(argumentCollection=data)>		
		</cfif>
		
		<cfif len(trim(form.emailList))>
			<cfset emails = arrayNew(1)>
			<cffile action="UPLOAD" filefield="form.emailList" destination="#expandPath("./uploads")#" nameconflict="MAKEUNIQUE">
			<cfset theFile = cffile.serverDirectory & "/" & cffile.serverFile>
			<cffile action="read" file="#theFile#" variable="buffer">
			<!--- attempt to read the buffer --->
			<cfloop index="line" list="#buffer#" delimiters="#chr(10)#">
				<cfif len(trim(line)) and request.udf.isEmail(trim(line))>
					<cfset arrayAppend(emails, trim(line))>
				</cfif>
			</cfloop>
			<cfset application.survey.resetEmailList(url.id)>
			<cfif arrayLen(emails)>
				<cfset application.survey.addEmailList(url.id,emails)>
			</cfif>
			<!--- cleanup --->
			<cffile action="delete" file="#theFile#">
		</cfif>
				
		<cfset msg = "Survey, #form.name#, has been updated.">
		<cflocation url="surveys.cfm?msg=#urlEncodedFormat(msg)#">
	</cfif>
</cfif>

<cfif isDefined("form.dupe") and url.id neq 0>
	<cfset application.survey.duplicateSurvey(url.id)>
	<cfset msg = "Survey, #form.name#, has been duplicated.">
	<cflocation url="surveys.cfm?msg=#urlEncodedFormat(msg)#">
</cfif>

<cfif isDefined("form.clear") and url.id neq 0>
	<cfset application.survey.clearResults(url.id)>
	<cfset msg = "Survey, #form.name#, has had its results cleared.">
	<cflocation url="surveys.cfm?msg=#urlEncodedFormat(msg)#">
</cfif>

<!--- get survey if not new --->
<cfif url.id neq 0>
	<cfif not session.user.isAdmin>
		<cfset survey = application.survey.getSurvey(url.id, session.user.id)>
	<cfelse>
		<cfset survey = application.survey.getSurvey(url.id)>
	</cfif>
	<!--- get the templates based on the survey owner, which may not be me if I'm a admin --->
	<cfset templates = application.template.getTemplates(survey.useridfk)>
	<cfset emailList = application.survey.getEmailList(url.id)>
	<cfparam name="form.name" default="#survey.name#">
	<cfparam name="form.description" default="#survey.description#">
	<cfparam name="form.active" default="#survey.active#">
	<cfparam name="form.dateBegin" default="#survey.dateBegin#">
	<cfparam name="form.dateEnd" default="#survey.dateEnd#">
	<cfparam name="form.resultMailTo" default="#survey.resultMailTo#">
	<cfparam name="form.surveyPassword" default="#survey.surveyPassword#">
	<cfparam name="form.thankYouMsg" default="#survey.thankYouMsg#">
	<cfparam name="form.templateidfk" default="#survey.templateidfk#">
	<cfparam name="form.allowembed" default="#survey.allowembed#">
	<cfparam name="form.showinpubliclist" default="#survey.showinpubliclist#">
	<cfparam name="form.questionsperpage" default="#survey.questionsperpage#">
<cfelse>
	<cfparam name="form.name" default="">
	<cfparam name="form.description" default="">
	<cfparam name="form.active" default="false">
	<cfparam name="form.dateBegin" default="">
	<cfparam name="form.dateEnd" default="">
	<cfparam name="form.resultMailTo" default="">
	<cfparam name="form.surveyPassword" default="">
	<cfparam name="form.thankYouMsg" default="">
	<cfparam name="form.templateidfk" default="">
	<cfparam name="form.allowembed" default="">
	<cfparam name="form.showinpubliclist" default="">
	<cfparam name="form.questionsperpage" default="">
	<cfset templates = application.template.getTemplates(session.user.id)>
</cfif>

<tags:layout templatename="admin" title="Survey Editor">

<cfoutput>
<script>
function viewEmailList() {
	window.open("viewemaillist.cfm?id=#url.id#","viewEmailList","width=500,height=600");
}
</script>

<p>
Please use the form below to enter details about the survey. All required fields are marked (*). The values
for date survey begins and ends allows you to restrict by date when surveys can be answered. If a survey password
is set, then it must be provided before the user can take the survey.
</p>

<cfif structKeyExists(variables, "survey") and survey.active>
	<!--- create a link to index.cfm --->
	<cfset rootURL = cgi.script_name>
	<cfset rootURL = listDeleteAt(rootURL, listLen(rootURL, "/"), "/")>
	<!--- pop out one more --->
	<cfset rootURL = listDeleteAt(rootURL, listLen(rootURL, "/"), "/")>
	<!--- now add root server --->
	<cfset rootServer = cgi.server_name>
	<cfif cgi.server_port neq 80>
		<cfset rootServer = rootServer & ":#cgi.server_port#">
	</cfif>
	<cfset rootURL = "http://" & rootServer & rootURL>
	<cfif right(rootURL,1) is not "/">
		<cfset rootURL = rootURL & "/">
	</cfif>
	
<!--- my silly rounded corners from spiffycorners.com --->
<style>
.spiffy{display:block}
.spiffy *{
  display:block;
  height:1px;
  overflow:hidden;
  font-size:.01em;
  background:##235577}
.spiffy1{
  margin-left:3px;
  margin-right:3px;
  padding-left:1px;
  padding-right:1px;
  border-left:1px solid ##a0b5c4;
  border-right:1px solid ##a0b5c4;
  background:##5a7f99}
.spiffy2{
  margin-left:1px;
  margin-right:1px;
  padding-right:1px;
  padding-left:1px;
  border-left:1px solid ##e9eef1;
  border-right:1px solid ##e9eef1;
  background:##4c7590}
.spiffy3{
  margin-left:1px;
  margin-right:1px;
  border-left:1px solid ##4c7590;
  border-right:1px solid ##4c7590;}
.spiffy4{
  border-left:1px solid ##a0b5c4;
  border-right:1px solid ##a0b5c4}
.spiffy5{
  border-left:1px solid ##5a7f99;
  border-right:1px solid ##5a7f99}
.spiffyfg{
  background:##235577;padding:5px;}
</style>
	
<div>
  <b class="spiffy">
  <b class="spiffy1"><b></b></b>
  <b class="spiffy2"><b></b></b>
  <b class="spiffy3"></b>
  <b class="spiffy4"></b>
  <b class="spiffy5"></b></b>

  <div class="spiffyfg">
	<span style="color:##ffffff;font-weight:bold">
	Users can take your survey by visiting this URL:<br /> #rootURL#survey.cfm?id=#survey.id#<br />
	<cfif survey.allowEmbed>
	<br />
	This survey can be embedded in other sites using this HTML:<br/>
	&lt;iframe src="#rootURL#survey.cfm?id=#survey.id#&embed=true" style="border: 1px solid black; width:500px; height: 500px;"&gt;<br/>
	&lt;/iframe&gt;
	</cfif>
	</span>
  </div>

  <b class="spiffy">
  <b class="spiffy5"></b>
  <b class="spiffy4"></b>
  <b class="spiffy3"></b>
  <b class="spiffy2"><b></b></b>
  <b class="spiffy1"><b></b></b></b>
</div>
</cfif>

<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#cgi.query_string#" method="post" enctype="multipart/form-data">
<table cellspacing=0 cellpadding=5 class="adminEditTable" width="100%">
	<tr valign="top">
		<td width="200"><b>(*) Name:</b></td>
		<td><input type="text" name="name" value="#form.name#" size="50"></td>
	</tr>
	<cfif session.user.isAdmin and structKeyExists(variables, "survey")>
	<tr valign="top">
		<td width="200"><b>User:</b></td>
		<td>#survey.username#</td>
	</tr>
	</cfif>
	<tr valign="top">
		<td><b>(*) Description:</b></td>
		<td><textarea name="description" rows=6 cols=35 wrap="soft">#form.description#</textarea></td>
	</tr>
	<tr valign="top">
		<td><b>Template:</b></td>
		<td>
		<select name="templateidfk">
		<option value="" <cfif form.templateidfk is "">selected</cfif>>No Template</option>
		<cfloop query="templates">
		<option value="#id#" <cfif form.templateidfk is id>selected</cfif>>#name#</option>
		</cfloop>
		</select>
		</td>
	</tr>	
	<tr valign="top">
		<td><b>Message Displayed at End:</b></td>
		<td><textarea name="thankyoumsg" rows=6 cols=35 wrap="soft">#form.thankyoumsg#</textarea></td>
	</tr>

	<cfif url.id eq 0>
		<input type="hidden" name="active" value="0">
	<cfelse>
	<tr valign="top">
		<td><b>(*) Active:</b></td>
		<td><select name="active">
		<option value="1" <cfif form.active>selected</cfif>>Yes</option>
		<option value="0" <cfif not form.active>selected</cfif>>No</option>
		</select></td>
	</tr>
	</cfif>
	<tr valign="top">
		<td><b>(*) Allow Embedding:</b></td>
		<td><select name="allowembed">
		<option value="1" <cfif isBoolean(form.allowembed) and form.allowembed>selected</cfif>>Yes</option>
		<option value="0" <cfif not isBoolean(form.allowembed) or not form.allowembed>selected</cfif>>No</option>
		</select></td>
	</tr>
	<tr valign="top">
		<td><b>(*) Show in Public List:</b></td>
		<td><select name="showinpubliclist">
		<option value="1" <cfif isBoolean(form.showinpubliclist) and form.showinpubliclist>selected</cfif>>Yes</option>
		<option value="0" <cfif not isBoolean(form.showinpubliclist) or not form.showinpubliclist>selected</cfif>>No</option>
		</select></td>
	</tr>
	<tr valign="top">
		<td><b>Questions Per Page:</b></td>
		<td><input type="text" name="questionsperpage" value="#form.questionsperpage#"><br/>
		If blank, defaults to #application.settings.perpage#. <b>Notice:</b> If your survey
		makes use of <i>any</i> post-question conditionals, you must set this value to 1 or
		the survey will not work correctly.
		</td>
	</tr>
	<tr valign="top">
		<td><b>Date Survey Begins:</b></td>
		<td><input type="text" name="dateBegin" value="#dateFormat(form.dateBegin)# #timeFormat(form.dateBegin)#" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>Date Survey Ends:</b></td>
		<td><input type="text" name="dateEnd" value="#dateFormat(form.dateEnd)# #timeFormat(form.dateEnd)#" size="50"></td>
	</tr>	
	<tr valign="top">
		<td><b>Mail Results To:</b></td>
		<td><input type="text" name="resultMailTo" value="#form.resultMailTo#" size="50" maxlength="255"></td>
	</tr>
	<tr valign="top">
		<td><b>Survey Password:</b></td>
		<td><input type="text" name="surveyPassword" value="#form.surveyPassword#" size="50"></td>
	</tr>
	<tr>
		<td colspan="2">
		<b>Email Restriction List:</b><br>
		Along with using a survey password, a survey can be restricted to a set of email addresses. In order to do this,
		you must create a text file of addresses (one per line) and upload it using the field below. This operation will overwrite any
		existing list of email addresses.
		<cfif url.id neq 0>
			This survey currently <b><cfif not emailList.recordCount>does not<cfelse>has</cfif></b> a restricted email list. <cfif emailList.recordCount>You can view this list <a href="javaScript:viewEmailList()">here</a>.</cfif>
		</cfif>
		<br><br>
		<input type="file" name="emailList">
		<br>
		<input type="checkbox" name="nukeEL"> Remove Current Email List		
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="Save">
		<cfif url.id neq 0> 
		<input type="submit" name="dupe" value="Duplicate"> 
		<input type="submit" name="clear" value="Clear Results"> 
		</cfif> 
		<input type="submit" name="cancel" value="Cancel"></td>
	</tr>
</table>
</form>
</p>
</cfoutput>

</tags:layout>

<cfsetting enablecfoutputonly=false>