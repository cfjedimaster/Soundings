<cfsetting enablecfoutputonly=true>
<!---
	Name         : surveys.cfm
	Author       : Raymond Camden 
	Created      : September 6, 2004
	Last Updated : December 12, 2007
	History      : Added a quick way to go to questions (rkc 11/14/07)
				   Typo in table header (rkc 12/12/07)
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<tags:layout templatename="admin" title="Survey Editor">

	<!--- handle deletions --->
	<cfif isDefined("form.mark") and len(form.mark)>
		<cfloop index="id" list="#form.mark#">
			<cfset application.survey.deleteSurvey(id)>
		</cfloop>
		<cfoutput>
		<p>
		<b>Survey(s) deleted.</b>
		</p>
		</cfoutput>
	</cfif>
	
	<!--- get surveys --->
	<cfif not session.user.isAdmin>
		<cfset surveys = application.survey.getSurveys(useridfk=session.user.id)>
	<cfelse>
		<cfset surveys = application.survey.getSurveys()>
	</cfif>
	
	<cfset queryAddColumn(surveys, "questions", arrayNew(1))>
	<cfloop query="surveys">
		<cfset querySetCell(surveys, "questions", "<a href='questions.cfm?surveyidfk=#id#'>Questions</a>", currentRow)>
	</cfloop>
	
	<tags:datatable data="#surveys#" list="name,description,active" editlink="surveys_edit.cfm" linkcol="name" label="Survey"
					deleteMsg="Warning - this will delete the survey including all related questions and responses.">
		<tags:datacol colname="name" label="Name" width="200" />	
		<tags:datacol colname="description" label="Description" width="400" />	
		<cfif session.user.isAdmin>
			<tags:datacol colname="username" label="User" width="100" />	
		</cfif>
		<tags:datacol colname="active" label="Active" width="50" format="YesNo" />	
		<tags:datacol colname="totalresults" label="Results" width="50"  />	
		<tags:datacol colname="questions" label="Questions" width="50"  />	

	</tags:datatable>

</tags:layout>

<cfsetting enablecfoutputonly=false>