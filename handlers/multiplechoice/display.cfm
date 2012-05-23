<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoice/display.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : October 12, 2005
	History      : minor format change (rkc 10/7/05)
				   255 limit (rkc 10/12/05)
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.single" default="true">
<cfparam name="attributes.other" default="false">
<cfparam name="attributes.question">
<cfparam name="attributes.r_result" default="result">
<cfparam name="attributes.answer">
<cfparam name="attributes.step">

<cfset showForm = true>
<cfset forceOther = false>

<cfif isDefined("form.submit")>
	<cfif not isDefined("form.question#attributes.step#") and attributes.question.required>
		<cfset errors = "You must answer the question.">
	<cfelseif attributes.other and isDefined("form.question#attributes.step#") and form["question#attributes.step#"] is "" and not len(trim(form["question#attributes.step#_other"]))>
		<cfset forceOther = true>
		<cfset errors = "If you select Other for an answer, you must fill something out.">
	<cfelse>
		<cfparam name="form.question#attributes.step#" default="">
		<!--- removed 255 - breaks with uuids 
		<cfset form["question#attributes.step#"] = left(form["question#attributes.step#"], 255)>
		--->
		<cfset form["question#attributes.step#"] = form["question#attributes.step#"]>
		<cfset attributes.answer = structNew()>
		<cfset attributes.answer.list = form["question#attributes.step#"]>
		<cfif isDefined("form.question#attributes.step#_other") and len(form["question#attributes.step#_other"])>
			<cfset attributes.answer.other = htmlEditFormat(form["question#attributes.step#_other"])>
		</cfif>
		<cfset caller[attributes.r_result] = attributes.answer>
	</cfif>
</cfif>

<cfif not structKeyExists(attributes, "answers")>
	<cfset answers = application.question.getAnswers(attributes.question.id)>	
<cfelse>
	<cfset answers = attributes.answers>
</cfif>

<!--- 
If a value exists in the answer that is NOT in the list, then its the Other
--->
<cfif isStruct(attributes.answer) and structKeyExists(attributes.answer,"other")>
	<cfparam name="form.question#attributes.step#_other" default="#attributes.answer.other#">
<cfelse>
	<cfparam name="form.question#attributes.step#_other" default="">
</cfif>


<cfif isDefined("errors")>
	<cfoutput>
	<p class="error">#errors#</p>
	</cfoutput>
</cfif>

<cfoutput>
<p>
<div class="question">#attributes.step#) #attributes.question.question# <cfif attributes.question.required EQ 1><strong class="required">*</strong></cfif></div>
<div class="answers">
		<cfif attributes.single>
			<cfset type="radio">
		<cfelse>
			<cfset type="checkbox">
		</cfif>
		<cfloop query="answers">
		<input type="#type#" name="question#attributes.step#" id="question#attributes.step#_#id#" value="#id#" <cfif isStruct(attributes.answer) and structKeyExists(attributes.answer,"list") and listFindNoCase(attributes.answer.list,id)>checked</cfif>><label for="question#attributes.step#_#id#">#answer#</label><br>
		</cfloop>
		<cfif attributes.other>
		<input type="#type#" name="question#attributes.step#" id="question#attributes.step#__" value="" <cfif len(form["question#attributes.step#_other"]) or forceOther>checked</cfif>><label for="question#attributes.step#__">Other</label>
		<input type="text" name="question#attributes.step#_other" value="#form["question#attributes.step#_other"]#" maxlength="255">
		</cfif>
</div>
</p>
</cfoutput>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">