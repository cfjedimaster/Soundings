
<cfquery name="getUsers" datasource="#dsn#">
select	username
from	#tableprefix#users
</cfquery>

<cfloop query="getUsers">
	<cfset newId = createUUID()>
	<cfquery datasource="#dsn#">
	update	#tableprefix#users
	set		id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#newId#">,
			isAdmin = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
	where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#username#">
	</cfquery>
</cfloop>