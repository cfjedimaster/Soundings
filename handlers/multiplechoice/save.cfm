<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoice/save.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : March 30, 2006
	History      : 255 limit (rkc 10/12/05)
				 : tableprefix fix (rkc 3/30/06)
	Purpose		 : Supports True/False, Yes/No
--->

<cfscript>
/**
 * Returns TRUE if the string is a valid CF UUID.
 * 
 * @param str 	 String to be checked. (Required)
 * @return Returns a boolean. 
 * @author Jason Ellison (jgedev@hotmail.com) 
 * @version 1, November 24, 2003 
 */
function IsCFUUID(str) {  	
	return REFindNoCase("^[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{16}$", str);
}
</cfscript>

<cfparam name="attributes.answer">
<cfparam name="attributes.questionidfk">
<cfparam name="attributes.owner">

<cfparam name="attributes.single" default="true">
<cfparam name="attributes.other" default="false">

<cfif isStruct(attributes.answer)>
	<cfloop index="answeritem" list="#attributes.answer.list#">
		<cfquery datasource="#application.settings.dsn#">
			insert into #application.settings.tableprefix#results(owneridfk,questionidfk,answeridfk)
			values(
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="320" value="#attributes.owner#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#answeritem#">
			)
		</cfquery>
	</cfloop>
<cfif structKeyExists(attributes.answer, "other")>
	<cfquery datasource="#application.settings.dsn#">
		insert into #application.settings.tableprefix#results(owneridfk,questionidfk,other)
		values(
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="320" value="#attributes.owner#">,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">,
			<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="255" value="#left(attributes.answer.other,255)#">
		)
	</cfquery>
</cfif>				
</cfif>
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">