<cfparam name="attributes.data">

<cfset question = {}>
<cfset question.question = attributes.data[1].value>
<cfset question.required = attributes.data[3].value>

<cfmodule template="display.cfm"
	step="1" question="#question#" answer="" r_result="resultDoesntMatter" />

<cfexit method="exitTag">