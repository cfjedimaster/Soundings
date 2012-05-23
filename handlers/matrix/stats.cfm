<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/matrix/stats.cfm
	Author       : Raymond Camden 
	Created      : October 7, 2005
	Last Updated : March 30, 2006
	History      : Fix to ordering (rkc 2/11/06)
				 : tableprefix fix (rkc 3/30/06)
	Purpose		 : Maxtrix
--->

<cfparam name="attributes.questionidfk">
<cfparam name="attributes.r_data" type="variablename">
<cfparam name="attributes.earliestdate" default="">
<cfparam name="attributes.latestdate" default="">


<cfset data = structNew()>
	
<!--- get my answer data --->
<cfset answers = application.question.getAnswers(attributes.questionidfk)>

<cfquery name="getAnswers" dbtype="query">
	select 		*
	from		answers
	where		rank >= 0
	order by 	rank asc
</cfquery>

<cfquery name="getItems" dbtype="query">
	select 		*
	from		answers
	where		rank < 0
	order by 	rank desc
</cfquery>

<!--- Pass to data a sorted list of answers to use in graphing. --->
<cfset data.sortedAnswers = valueList(getAnswers.id)>
<!--- Pass to data a sorted list of items to use in graphing. --->
<cfset data.sortedItems = valueList(getItems.id)>
	
<cfloop query="getItems">

	<cfset itemid = id>
	<cfset item = answer>
	<cfset data[itemid] = structNew()>
	
	<cfloop query="getAnswers">
		
		<cfquery name="getcount" datasource="#application.settings.dsn#">
			select	count(r.answeridfk) as total
			from	#application.settings.tableprefix#results r,
					#application.settings.tableprefix#survey_results sr

			where	r.answeridfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#id#">
			and		r.itemidfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#itemid#">
			and		r.owneridfk = sr.ownerid
			<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
			and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
			</cfif>
			<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
			and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
			</cfif>
		</cfquery>
	
		<cfset data[itemid][id] = structNew()>
		<cfset data[itemid][id].label = answer>
		<cfset data[itemid][id].count = getcount.total>
		<cfset data[itemid][id].rank = rank>
		<cfset data[itemid].label = item>
	</cfloop>

</cfloop>

<!--- 
For stats, we need a count of how many people answered this question. The problem is that we can have 3 answers when it's really just 3 points to the one q	
So we need to get a proper count. I think this makes sense.
--->
<cfquery name="getRealTotal" datasource="#application.settings.dsn#">
select distinct r.owneridfk 
from 	#application.settings.tableprefix#results r,
		#application.settings.tableprefix#survey_results sr
		
where r.questionidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.questionidfk#" maxlength="35">
<cfif application.settings.dbtype neq "msaccess">
and r.answeridfk != ''
<cfelse>
and r.answeridfk <> ''
</cfif>
and		r.owneridfk = sr.ownerid
<cfif structKeyExists(attributes, "earliestdate") and isDate(attributes.earliestdate)>
and		sr.completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.earliestdate#">
</cfif>
<cfif structKeyExists(attributes, "latestdate") and isDate(attributes.latestdate)>
and		sr.completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#attributes.latestdate#">
</cfif>
</cfquery>

<cfset data.realTotal = getRealTotal.recordCount>
	
<cfset caller[attributes.r_data] = data>				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">