<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textbox/stats.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : March 30, 2006
	History      : tableprefix fix (rkc 3/30/06)
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.questionidfk">
<cfparam name="attributes.r_data" type="variablename">
<cfparam name="attributes.single" default="true">
<cfparam name="attributes.earliestdate" default="">
<cfparam name="attributes.latestdate" default="">

<cfquery name="getcount" datasource="#application.settings.dsn#">
	select	
			r.other
	from	#application.settings.tableprefix#results r,
			#application.settings.tableprefix#survey_results sr

	where	r.questionidfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">
			and		r.owneridfk = sr.ownerid
			<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
			and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
			</cfif>
			<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
			and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
			</cfif>

</cfquery>	

<cfset caller[attributes.r_data] = getcount>				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">