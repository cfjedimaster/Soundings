<cfsetting enablecfoutputonly=true>

<cfparam name="attributes.step">

<cfif isDefined("form.submit")>
	<cfif (not isDefined("form.question#attributes.step#") or not len(form["question#attributes.step#"])) and attributes.question.required>
		<cfset errors = "You must answer the question.">
	<cfelse>
		<cfif len(form["question#attributes.step#"])>
			<!--- upload to attachment dir --->
			<cffile action="upload" destination="#application.settings.attachmentdir#" nameconflict="makeunique" result="result" filefield="question#attributes.step#">
			<!--- todo, better handling of errors here --->
			<!--- for now, we save just server file --->
			<cfset form["question#attributes.step#"] = result.serverfile>
		<cfelse>
			<cfset form["question#attributes.step#"] = "">
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
	<input type="file" name="question#attributes.step#" id="question#attributes.step#" value="#attributes.answer#">		
</div>	
</cfoutput>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">