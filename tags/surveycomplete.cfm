<cfsetting enablecfoutputonly=true>
<!---
	Name         : surveycomplete.cfm
	Author       : Raymond Camden 
	Created      : September 24, 2004
	Last Updated : March 10, 2006
	History      : work w/o mapping (rkc 3/10/06)
	Purpose		 : 
--->

<cfparam name="attributes.survey">
<cfparam name="attributes.data">
<cfparam name="attributes.owner" default="#createUUID()#">

<!--- Logic to handle survey completion:
	Loop through each question. 
	Check it's type.
	Fire the save handler on each type passing in the answer the user provided.
--->

<cfset questions = application.question.getQuestions(attributes.survey.id)>
<cfloop query="questions">
	<cfset answer = "">
	<cfif structKeyExists(attributes.data.answers, id)>
		<cfset answer = attributes.data.answers[id]>
	</cfif>
	<cfmodule template="../handlers/#handlerRoot#/save.cfm" 
			  answer="#answer#" questionidfk="#id#" 
			  owner="#attributes.owner#"/>
</cfloop>

<!--- do root completion mark --->
<cfset application.survey.completeSurvey(attributes.survey.id, attributes.owner)>

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">
