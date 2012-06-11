<cfparam name="attributes.data">
<cfparam name="attributes.other" default="false">
<cfparam name="attributes.single" default="true">

<cfset question = {}>
<cfset question.id = "doesntmatter">
<cfset question.question = attributes.data[1].value>
<cfset question.required = attributes.data[3].value>

<cfset answers = queryNew("id,answer")>
<cfif arrayLen(attributes.data) gte 4>
	<cfloop index="x" from="4" to="#arrayLen(attributes.data)#">
		<cfif (findNoCase("answer_new", attributes.data[x].name) and len(attributes.data[x].value)) or
			  reFindNoCase("answer[0-9]+", attributes.data[x].name)>
			 
			<cfset queryAddRow(answers)>
			<cfset querySetCell(answers, "id", "doesntmatter")>
			<cfset querySetCell(answers, "answer", attributes.data[x].value)>
		</cfif>
	</cfloop>
</cfif>

<cfmodule template="display.cfm"
	step="1" question="#question#" answers="#answers#" answer="" r_result="resultDoesntMatter"
	other="#attributes.other#" single="#attributes.single#" />

<cfexit method="exitTag">