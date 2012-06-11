<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/matrix/save.cfm
	Author       : Raymond Camden 
	Created      : October 7, 2005
	Last Updated : March 30, 2006
	History      : tableprefix fix (rkc 3/30/06)
	Purpose		 : Matrix save
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

<!--- Answer is a struct where each key is the item and it's value is the answer id fk --->

<cfif isStruct(attributes.answer)>
	<cfloop item="item" collection="#attributes.answer#">
		<cfif isCFUUID(item)>
			<cfif attributes.answer[item] is "" or isCFUUID(attributes.answer[item])>
				<cfquery datasource="#application.settings.dsn#">
				insert into #application.settings.tableprefix#results(owneridfk, questionidfk, answeridfk, itemidfk)
				values(
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="320" value="#attributes.owner#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.questionidfk#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#attributes.answer[item]#">,
				<cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#item#">
				)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>
</cfif>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">