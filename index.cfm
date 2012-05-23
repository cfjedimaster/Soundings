<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : September 2, 2004
	Last Updated : March 10, 2006
	History      : work w/o mapping (rkc 3/10/06)
	Purpose		 : Displays surveys
--->
<cfimport taglib="./tags/" prefix="tags">

<cfset surveys = application.survey.getSurveys(bActiveOnly=1,publicList=1)>

<!--- Loads header --->
<tags:layout templatename="main" title="Welcome to Soundings">

<!--- Now display the table. This changes based on what our data is. --->
<cfoutput>
<h2>Welcome to Soundings</h2>

<p>
Welcome to Soundings, the Survey application. Below you will find a list of active surveys. Surveys that are restricted in some way will be marked. 
</p>

<h2>Active Surveys</h2>

<cfif surveys.recordCount eq 0>
	<p>
	Sorry, but there are no surveys available at this time.
	</p>
<cfelse>
	<cfloop query="surveys">
		<cfset emailList = application.survey.getEmailList(id)>
		<p>
		<a href="survey.cfm?id=#id#">#name#</a> 
		<cfif surveypassword neq "" or emailList.recordCount>(Restricted)</cfif>
		<cfif dateend neq "">(Ends on: #dateFormat(dateend,"mm/dd/yyyy")#)</cfif> 
		<br>
		#description#
		</p>
	</cfloop>
</cfif>

</cfoutput>
	
</tags:layout>

<cfsetting enablecfoutputonly=false>
