<cfparam name="attributes.data">

<cfset question = {}>
<cfset question.question = attributes.data[1].value>
<cfset question.required = attributes.data[3].value>

<cfset answers = queryNew("id,rank,answer")>

<cfif arrayLen(attributes.data) gte 4>
	<cfset currAnswers = 0>
	<cfset currItems = 0>
	<!--- first handle items that were persisted --->
	<cfloop index="x" from="4" to="#arrayLen(attributes.data)#">
		<!---
		<cfif (findNoCase("answer_new", attributes.data[x].name) and len(attributes.data[x].value))>
		--->
		<cfif reFindNoCase("answer[0-9]+", attributes.data[x].name)>
			<cfset queryAddRow(answers)>
			<cfset querySetCell(answers, "id", "doesntmatter")>
			<cfset querySetCell(answers, "rank", attributes.data[x+1].value)>
			<cfset querySetCell(answers, "answer", attributes.data[x].value)>
			<cfset currAnswers++>
		<cfelseif reFindNoCase("item[0-9]+", attributes.data[x].name)>
			<cfset queryAddRow(answers)>
			<cfset querySetCell(answers, "id", "doesntmatter")>
			<cfset querySetCell(answers, "rank", -1 * attributes.data[x+1].value)>
			<cfset querySetCell(answers, "answer", attributes.data[x].value)>			
			<cfset currItems++>
		</cfif>
	</cfloop>
	<!--- now do it again for  new stuff - this could be done better I bet... --->
	<cfloop index="x" from="4" to="#arrayLen(attributes.data)#">
		<cfif (findNoCase("answer_new", attributes.data[x].name) and len(attributes.data[x].value))>
			<cfset queryAddRow(answers)>
			<cfset querySetCell(answers, "id", "doesntmatter")>
			<cfset querySetCell(answers, "rank", ++currAnswers)>
			<cfset querySetCell(answers, "answer", attributes.data[x].value)>
		<cfelseif findNoCase("item_new", attributes.data[x].name) and len(attributes.data[x].value)>
			<cfset queryAddRow(answers)>
			<cfset querySetCell(answers, "id", "doesntmatter")>
			<cfset querySetCell(answers, "rank", -1 * (++currItems))>
			<cfset querySetCell(answers, "answer", attributes.data[x].value)>			
		</cfif>
	</cfloop>
</cfif>

<cfmodule template="display.cfm"
	step="1" question="#question#" answers="#answers#" answer="" r_result="resultDoesntMatter" />

<cfexit method="exitTag">