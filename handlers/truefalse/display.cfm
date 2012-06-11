<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/truefalse/display.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : April 10, 2006
	History      : New row for answers (rkc 10/7/05)
				 : Minor HTML mod (rkc 4/10/06)
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.yesno" default="false">
<cfparam name="attributes.question">
<cfparam name="attributes.r_result" default="result">
<cfparam name="attributes.answer">
<cfparam name="attributes.step">

<cfset showForm = true>

<cfif isDefined("form.submit")>
	<cfif not isDefined("form.question#attributes.step#") and attributes.question.required>
		<cfset errors = "You must answer the question.">
	<cfelse>
		<!--- param for non required results --->
		<cfparam name="form.question#attributes.step#" default="">
		<cfset caller[attributes.r_result] = form["question#attributes.step#"]>
		<cfset attributes.answer = form["question#attributes.step#"]>
	</cfif>
</cfif>


<cfif isDefined("errors")>
	<cfoutput>
	<p class="error">#errors#</p>
	</cfoutput>
</cfif>
	
<cfoutput>
<div class="question">#attributes.step#) #attributes.question.question# <cfif attributes.question.required EQ 1><strong class="required">*</strong></cfif></div>
<div class="answers">
<cfif attributes.yesno>
		<input type="radio" name="question#attributes.step#" id="question#attributes.step#_yes" value="yes" <cfif attributes.answer is "yes">checked</cfif>><label for="question#attributes.step#_yes">Yes</label><br>
		<input type="radio" name="question#attributes.step#" id="question#attributes.step#_no" value="no" <cfif attributes.answer is "no">checked</cfif>><label for="question#attributes.step#_no">No</label><br>
		<cfelse>
		<input type="radio" name="question#attributes.step#" id="question#attributes.step#_true" value="true" <cfif attributes.answer is "true">checked</cfif>><label for="question#attributes.step#_true">True</label><br>
		<input type="radio" name="question#attributes.step#" id="question#attributes.step#_false" value="false" <cfif attributes.answer is "false">checked</cfif>><label for="question#attributes.step#_false">False</label><br>		
  </cfif>
</div>
</cfoutput>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">