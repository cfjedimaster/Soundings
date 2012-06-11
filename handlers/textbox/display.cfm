<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textbox/display.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : April 10, 2006
	History      : minor format change (rkc 10/7/05)
				   restrict to 255 (rkc 10/12/05)
				   minor html change (rkc 4/10/06)
	Purpose		 : Supports Textbox, single and multi
--->

<cfparam name="attributes.single" default="true">
<cfparam name="attributes.step">

<cfif isDefined("form.submit")>
	<cfif (not isDefined("form.question#attributes.step#") or not len(form["question#attributes.step#"])) and attributes.question.required>
		<cfset errors = "You must answer the question.">
	<cfelse>
		<cfset form["question#attributes.step#"] = htmlEditFormat(form["question#attributes.step#"])>
		<cfif attributes.single>
			<cfset form["question#attributes.step#"] = left(form["question#attributes.step#"], 255)>
		</cfif>
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
<div class="question">#attributes.step#) <label for="question#attributes.step#">#attributes.question.question#</label> <cfif attributes.question.required EQ 1><strong class="required">*</strong></cfif></div>
<div class="answers">
		<cfif attributes.single>
		<input type="text" name="question#attributes.step#" id="question#attributes.step#" value="#attributes.answer#" maxlength="255">		
		<cfelse>
		<textarea name="question#attributes.step#" id="question#attributes.step#" cols=40 rows=10>#attributes.answer#</textarea>
		</cfif>
</div>	
</cfoutput>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">