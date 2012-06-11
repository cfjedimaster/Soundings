<cfif not structKeyExists(variables, "qid")>
	<cfthrow message="Invalid use of nextquestionlogic.cfm">
</cfif>

<cfset data = arrayNew(1)>

<cfset counter = 1>
<cfloop condition="structKeyExists(form,'nextquestionaction_#counter#')">
	<cfif form["nextquestionaction_#counter#"] is "goto">
		<cfset newdata = structNew()>
		<cfset newdata.nextquestion = form["nextquestion_#counter#"]>
	
		<cfif structKeyexists(form, "questionfilter_#counter#") and form["questionfilter_#counter#"] is "onlyif">
			<cfset newdata.nextquestionvalue = form["nextquestionvalue_#counter#"]>
		<cfelse>
			<cfset newdata.nextquestionvalue = "">
		</cfif>
		<cfset arrayAppend(data, newdata)>
	</cfif>
	<cfset counter++>
</cfloop>

<cfif structKeyExists(form, "nextquestionaction_new") and form.nextquestionaction_new is "goto">
	<cfset newdata = structNew()>
	<cfset newdata.nextquestion = form.nextquestion_new>

	<cfif structKeyexists(form, "questionfilter_new") and form.questionfilter_new is "onlyif">
		<cfset newdata.nextquestionvalue = form.nextquestionvalue_new>
	<cfelse>
		<cfset newdata.nextquestionvalue = "">
	</cfif>
	<cfset arrayAppend(data, newdata)>
</cfif>

<cfset application.question.setQuestionBranches(qid, data)>
