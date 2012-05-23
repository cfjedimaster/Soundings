<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/truefalse/stats.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : March 30, 2006
	History      : tableprefix fix (rkc 3/30/06)
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.questionidfk">
<cfparam name="attributes.r_data" type="variablename">
<cfparam name="attributes.earliestdate" default="">
<cfparam name="attributes.latestdate" default="">

<cfset data = structNew()>

<cfquery name="totalTrue" datasource="#application.settings.dsn#">
	select	count(r.truefalse) as totalTrue
	from	#application.settings.tableprefix#results r,
			#application.settings.tableprefix#survey_results sr
	where	questionidfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">
	and		r.owneridfk = sr.ownerid
	and		r.truefalse = 1
	<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
	and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
	</cfif>
	<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
	and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
	</cfif>
	
</cfquery>
<cfquery name="totalFalse" datasource="#application.settings.dsn#">
	select	count(r.truefalse) as totalFalse
	from	#application.settings.tableprefix#results r,
			#application.settings.tableprefix#survey_results sr
	where	questionidfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">
	and		r.owneridfk = sr.ownerid
	and		r.truefalse = 0
	<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
	and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
	</cfif>
	<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
	and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
	</cfif>
</cfquery>

<cfset data.true = totalTrue.totalTrue>
<cfset data.false = totalFalse.totalFalse>

<cfset caller[attributes.r_data] = data>				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">