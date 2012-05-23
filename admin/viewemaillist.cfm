<cfsetting enablecfoutputonly=true>
<!---
	Name         : viewemaillist.cfm
	Author       : Raymond Camden 
	Created      : September 16, 2004
	Last Updated : September 16, 2004
	History      : 
	Purpose		 : 
--->

<cfif not isDefined("url.id")>
	<cfabort>
</cfif>

<cftry>
	<cfset survey = application.survey.getSurvey(url.id)>
	<cfcatch>
		<cfabort>
	</cfcatch>
</cftry>

<cfset list = application.survey.getEmailList(url.id)>

<cfmodule template="../tags/layout.cfm" templatename="plain" title="Email Restriction List">

<cfoutput>
<h2>Email Restriction List for #survey.name#</h2>

<p>
<cfloop query="list">
#emailaddress#<br>
</cfloop>
</p>
</cfoutput>

</cfmodule>

