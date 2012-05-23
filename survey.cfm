<cfheader name="P3P" value="CP=""CAO PSA OUR""">
<cfsetting enablecfoutputonly=true>
<!---
	Name         : surveycfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : March 10, 2006
	History      : work w/o mapping (rkc 3/10/06)
	Purpose		 : Displays a survey
--->
<cfimport taglib="./tags/" prefix="tags">

<cfif not isDefined("url.id") or not len(url.id)>
	<cflocation url="index.cfm" addToken="false">
</cfif>
<cftry>
	<cfset survey = application.survey.getSurvey(url.id)>
	<cfif not survey.active or (survey.datebegin neq "" and dateCompare(survey.datebegin,now()) is 1) or 
			(survey.dateend neq "" and dateCompare(now(), survey.dateend) is 1)>
		<cflocation url="index.cfm" addToken="false">
	</cfif>
	<cfif survey.templateidfk neq "">
		<cfset template = application.template.getTemplate(survey.templateidfk)>
	</cfif>
	<cfcatch>
		<cflocation url="index.cfm" addToken="false">
	</cfcatch>
</cftry>

<cfif structKeyExists(url, "embed")>
	<cfoutput><link rel="stylesheet" type="text/css" href="stylesheets/embed.css" media="screen, projection"></link></cfoutput>
	<tags:surveydisplay survey="#survey#" />
<cfelseif not structKeyExists(variables, "template")>
	<!--- Loads header --->
	<tags:layout templatename="main" title="Survey: #survey.name#">
	
		<tags:surveydisplay survey="#survey#"/>
			
	</tags:layout>
<cfelse>
	<cfoutput>#template.header#</cfoutput>
	<tags:surveydisplay survey="#survey#" />
	<cfoutput>#template.footer#</cfoutput>
</cfif>
<cfsetting enablecfoutputonly=false>
