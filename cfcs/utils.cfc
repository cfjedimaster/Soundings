<cfcomponent displayName="Utils" hint="Set of common methods." output="false">

	<cffunction name="getQueryParamType" access="public" returnType="string" output="false"
				hint="Based on sql type and query param returns a db specific type. It's main purpose is to handle mysql differences.">
		<cfargument name="dbtype" type="string" required="true" hint="The db type.">
		<cfargument name="qptype" type="string" required="true" hint="The queryparam type.">
		<cfset var result = arguments.qptype>
		
		<cfif arguments.qptype is "CF_SQL_BIT">
			<cfswitch expression="#arguments.dbtype#">
				<cfcase value="mysql">
					<cfset result = "CF_SQL_TINYINT">
				</cfcase>
				<cfcase value="postgres">
					<cfset result = "CF_SQL_BOOLEAN">
				</cfcase>
			</cfswitch>
		</cfif>

		<cfreturn result>
	</cffunction>
	
	<cffunction name="getQueryParamValue" access="public" returnType="string" output="false"
				hint="Based on sql type and query param returns a db specific type. It's main purpose is to handle mysql differences.">
		<cfargument name="dbtype" type="string" required="true" hint="The db type.">
		<cfargument name="qptype" type="string" required="true" hint="The queryparam type.">
		<cfargument name="qpvalue" type="string" required="true" hint="The queryparam value.">
		<cfset var result = arguments.qpvalue>
		
		<cfif arguments.qptype is "CF_SQL_BIT">
			<cfswitch expression="#arguments.dbtype#">
				<cfcase value="mysql">
					<cfset result = arguments.qpvalue>
				</cfcase>
				<cfcase value="postgres">
					<cfif arguments.qpvalue eq 1>
						<cfset result = "true">
					<cfelseif arguments.qpvalue eq 0>
						<cfset result = "false">
					<cfelse>
						<cfset result = "null">
					</cfif>
				</cfcase>
			</cfswitch>
		</cfif>
		<cfreturn result>
	</cffunction>
	
	<cffunction name="isUserInAnyRole2" access="public" returnType="boolean" output="false"
				hint="isUserInRole only does AND checks. This method allows for OR checks.">
		
		<cfargument name="rolelist" type="string" required="true">
		<cfset var role = "">
		
		<cfloop index="role" list="#rolelist#">
			<cfif isUserInRole(role)>
				<cfreturn true>
			</cfif>
		</cfloop>
		
		<cfreturn false>
		
	</cffunction>
	
	<cffunction name="queryToStruct" access="public" returnType="struct" output="false"
				hint="Transforms a query to a struct.">
		<cfargument name="theQuery" type="query" required="true">
		<cfset var s = structNew()>
		<cfset var q ="">
		
		<cfloop index="q" list="#theQuery.columnList#">
			<cfset s[q] = theQuery[q][1]>
		</cfloop>
		
		<cfreturn s>
		
	</cffunction>
	
	<cffunction name="searchSafe" access="public" returnType="string" output="false"
				hint="Removes any non a-z, 0-9 characters.">
		<cfargument name="string" type="string" required="true">
		
		<cfreturn reReplace(arguments.string,"[^a-zA-Z0-9[:space:]]+","","all")>
	</cffunction>
	
	<cffunction name="throw" access="public" returnType="void" output="false"
				hint="Handles exception throwing.">
				
		<cfargument name="type" type="string" required="true">		
		<cfargument name="message" type="string" required="true">
		
		<cfthrow type="#arguments.type#" message="#arguments.message#">
		
	</cffunction>

</cfcomponent>