<!---
	Name         : cfcs/user.cfc
	Author       : Raymond Camden 
	Created      : August 3, 2007
	Last Updated : 
	History      : 
	Purpose		 : 
--->

<cfcomponent displayName="User" hint="Basic User CFC" output="false">

	<cfset variables.utils = createObject("component","utils")>

	<cffunction name="init" access="public" returnType="user" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" >
		
		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.dbtype = arguments.settings.dbtype>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		<cfset variables.lockname = "soundings_20_userlock">		
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addUser" access="public" returnType="uuid" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="false" default="">
		<cfset var check = "">
		<cfset var newid = createUUID()>
		
		<cflock name="#variables.lockname#" type="exclusive" timeout="30">
			<!--- did we pick someone existing? --->

			<cfquery name="check" datasource="#variables.dsn#">
			select	username
			from	#variables.tableprefix#users
			where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">
			</cfquery>

			<cfif check.recordCount>
				<cfthrow message="A user by this name, #arguments.username#, already exists.">
			</cfif>

			
			<cfquery datasource="#variables.dsn#">
			insert into #variables.tableprefix#users(id,username,password,isadmin)
			values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#newid#" maxlength="35">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="255">,
			<cfqueryparam value="#variables.utils.getQueryParamValue(variables.dbtype,"CF_SQL_BIT", arguments.isAdmin)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">)
			</cfquery>
			
		</cflock>
		
		<cfreturn newid>		
	</cffunction>

	<cffunction name="authenticate" access="public" returnType="boolean" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.dsn#">
		select	username
		from	#variables.tableprefix#users
		where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">
		and		password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="255">
		</cfquery>
		
		<cfreturn q.recordCount is 1>
	</cffunction>

	<cffunction name="deleteUser" access="public" returnType="void" output="false">
		<cfargument name="username" type="string" required="true">

		<!--- todo, remove his templates and surveys? not sure --->
		<cfquery datasource="#variables.dsn#">
		delete	from #variables.tableprefix#users
		where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="getUser" access="public" returnType="struct" output="false">
		<cfargument name="username" type="string" required="true">
		<cfset var q = "">
		<cfset var s = structNew()>
				
		<cfquery name="q" datasource="#variables.dsn#">
		select	id, username, password, isadmin
		from	#variables.tableprefix#users
		where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">
		</cfquery>

		<cfset s.id = q.id>
		<cfset s.username = q.username>
		<cfset s.password = q.password>
		<cfset s.isAdmin = q.isAdmin>
		
		<cfreturn s>
	</cffunction>
		
	<cffunction name="getUsers" access="public" returnType="query" output="false">
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.dsn#">
		select	id, username, password, isadmin
		from	#variables.tableprefix#users
		order by username asc
		</cfquery>
		
		<cfreturn q>
	</cffunction>
	
	<cffunction name="updatePassword" access="public" returnType="void" output="false">
		<cfargument name="username" type="string" required="true">
		<cfargument name="oldpassword" type="string" required="true">
		<cfargument name="newpassword" type="string" required="true">

		<!--- ensure old password is right --->
		<cfif authenticate(arguments.username,arguments.oldpassword)>
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#users
			set		password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.newpassword)#" maxlength="255">
			where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">
			</cfquery>
		<cfelse>
			<cfthrow message="Old password did not match.">
		</cfif>
	
	</cffunction>
	
	<cffunction name="updateUser" access="public" returnType="void" output="false">
		<cfargument name="id" type="uuid" required="true">		
		<cfargument name="originalusername" type="string" required="true">
		<cfargument name="username" type="string" required="true">
		<cfargument name="isAdmin" type="boolean" required="true">
		<cfargument name="password" type="string" required="false" default="">
		<cfset var check = "">
		
		<!--- Logic is simple:
		If username changed, I need to check for uniqueness.
		If password has a value, I update and hash.
		So if username same as orig and no new password, might as well make like a banana and split.
		
		Removed this one I added isAdmin.
		<cfif arguments.originalusername is arguments.username and arguments.password is "">
			<cfreturn>
		</cfif>

		--->
		

		<cflock name="#variables.lockname#" type="exclusive" timeout="30">
			<!--- did we change names? --->
			<cfif arguments.originalusername neq arguments.username>

				<cfquery name="check" datasource="#variables.dsn#">
				select	username
				from	#variables.tableprefix#users
				where	username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">
				</cfquery>

				<cfif check.recordCount>
					<cfthrow message="A user by this name, #arguments.username#, already exists.">
				</cfif>

			</cfif>
			
			<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#users
			set		username = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.username#" maxlength="255">,
					isAdmin = <cfqueryparam value="#variables.utils.getQueryParamValue(variables.dbtype,"CF_SQL_BIT", arguments.isAdmin)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">
			<cfif len(arguments.password)>
			,password = <cfqueryparam cfsqltype="cf_sql_varchar" value="#hash(arguments.password)#" maxlength="255">
			</cfif>
			where 	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#" maxlength="35">
			</cfquery>
			
		</cflock>		
	</cffunction>

</cfcomponent>