<cfsetting enablecfoutputonly=true>
<!---
	Name         : questions.cfm
	Author       : Raymond Camden 
	Created      : September 6, 2004
	Last Updated : September 6, 2004
	History      : 
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<cfif isDefined("url.surveyidfk")>
	<cfset form.surveyidfk = url.surveyidfk>
</cfif>
<cfparam name="form.surveyidfk" default="">

<tags:layout templatename="admin" title="Question Editor">

	<!--- handle deletions --->
	<cfif isDefined("form.mark") and len(form.mark)>
		<cfloop index="id" list="#form.mark#">
			<cfset application.question.deleteQuestion(id)>
		</cfloop>
		<cfoutput>
		<p>
		<b>Questions(s) deleted.</b>
		</p>
		</cfoutput>
	</cfif>
	
	<!--- get surveys --->
	<cfif not session.user.isAdmin>
		<cfset surveys = application.survey.getSurveys(useridfk=session.user.id)>
	<cfelse>
		<cfset surveys = application.survey.getSurveys()>
	</cfif>

	<cfoutput>
	<script>
	function checkSubmit() {
		if(document.surveys.surveyidfk.selectedIndex != 0) document.surveys.submit();
	}
	</script>
	<p>
	<form action="#cgi.script_name#" method="get" name="surveys">
	Select a Survey <select name="surveyidfk" onChange="checkSubmit()">
	<option value="">---</option>
	<cfloop query="surveys">
		<option value="#id#" <cfif id is form.surveyidfk>selected</cfif>>#name#</option>
	</cfloop>
	</select>
	</form>
	</p>
	</cfoutput>
	
	<cfif form.surveyidfk neq "">
		<cfset questions = application.question.getQuestions(form.surveyidfk)>		

		<tags:datatable data="#questions#" list="question,questiontype,rank" editlink="questions_edit.cfm" linkcol="question" label="Question" queryString="surveyidfk=#form.surveyidfk#">
			<tags:datacol colname="question" label="Question" width="400" />	
			<tags:datacol colname="questiontype" label="Question Type" width="280" />	
			<tags:datacol colname="required" label="Req." width="30" format="YesNo"/>
			<tags:datacol colname="rank" label="Rank" width="40" />
		</tags:datatable>
		
	</cfif>	

</tags:layout>

<cfsetting enablecfoutputonly=false>