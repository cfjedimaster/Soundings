<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/mc/stats.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : March 30, 2006
	History      : tableprefix fix (rkc 3/30/06)
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.questionidfk">
<cfparam name="attributes.r_data" type="variablename">
<cfparam name="attributes.other" default="false">
<cfparam name="attributes.getother" default="false">
<cfparam name="attributes.earliestdate" default="">
<cfparam name="attributes.latestdate" default="">

<cfif not attributes.getother>

	<cfset data = structNew()>
	
	<!--- get my answer data --->
	<cfset answers = application.question.getAnswers(attributes.questionidfk)>
	
	<cfloop query="answers">

		<cfquery name="getcount" datasource="#application.settings.dsn#">
			<!---
			select	count(r.answeridfk) as total
			from	#application.settings.tableprefix#results r,
					#application.settings.tableprefix#survey_results sr
			where	r.answeridfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#id#">
			and		r.owneridfk = sr.ownerid
			<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
			and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
			</cfif>
			<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
			and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
			</cfif>
			--->
			select	count(r.answeridfk) as total
			from	#application.settings.tableprefix#results r
			where	r.answeridfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#id#">
			<cfif (structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)) or
			(structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate))>
			and r.owneridfk in (
				select ownerid 
				from #application.settings.tableprefix#survey_results sr 
				where 1=1
				<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
				and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
				</cfif>
				<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
				and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
				</cfif>
			)
			</cfif>
			
		</cfquery>

		<cfif getcount.recordCount>	
			<cfset data[id] = getcount.total>
		<cfelse>
			<cfset data[id] = 0>
		</cfif>
		
	</cfloop>
	
	<cfif attributes.other>
	
		<cfquery name="getother" datasource="#application.settings.dsn#">
			select 	count(r.other) as totalother
			from	#application.settings.tableprefix#results r,
					#application.settings.tableprefix#survey_results sr
			where	r.questionidfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">
			and		r.answeridfk is null
			and		r.owneridfk = sr.ownerid
			<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
			and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
			</cfif>
			<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
			and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
			</cfif>
		</cfquery>
		
		<cfif getother.recordCount>
			<cfset data.other = getother.totalother>
		<cfelse>
			<cfset data.other = 0>
		</cfif>	
	
	</cfif>

<cfelse>
	<!--- In this mode we are just getting the "other" data --->
	<cfquery name="data" datasource="#application.settings.dsn#">
		select	r.other
		from	#application.settings.tableprefix#results r,
					#application.settings.tableprefix#survey_results sr
		where	r.questionidfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">
		and		r.answeridfk is null
		and		r.owneridfk = sr.ownerid
		<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
		and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
		</cfif>
		<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
		and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
		</cfif>
		
	</cfquery>
	
</cfif>

<cfset caller[attributes.r_data] = data>				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">