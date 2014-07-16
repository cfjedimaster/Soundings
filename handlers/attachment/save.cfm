<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textbox/save.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : March 30, 2006
	History      : Be anal on 255 limit (rkc 10/12/05)
				 : tableprefix fix (rkc 3/30/06)
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.single" default="true">

<cfif len(attributes.answer)>
	<cfquery datasource="#application.settings.dsn#">
		insert into #application.settings.tableprefix#results(owneridfk,questionidfk,other)
		values(
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="320" value="#attributes.owner#">,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="#left(attributes.answer,255)#">
		)
	</cfquery>
</cfif>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">