<!--- get one user and them use him for surveys. Feel free to edit this to filter by a specific username --->

<cfquery name="getUsers" datasource="#dsn#" maxrows="1">
select	id
from	#tableprefix#users
</cfquery>

<cfquery datasource="#dsn#">
update	#tableprefix#surveys
set		useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#getUsers.id#" maxlength="35">
</cfquery>