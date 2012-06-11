<!---
	Name         : cfcs/questiontype.cfc
	Author       : Raymond Camden 
	Created      : 
	Last Updated : March 10, 2006
	History      : support for tableprefix (3/10/06)
	Purpose		 : 
--->

<cfcomponent displayName="QuestionType" hint="A Question Type." output="false">

	<cfset variables.utils = createObject("component","utils")>

	<cffunction name="init" access="public" returnType="questionType" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" >
		
		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.dbtype = arguments.settings.dbtype>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addQuestionType" access="public" returnType="uuid" output="false"
				hint="Adds a new questionType to the the db.">
		<cfargument name="name" type="string" required="true">
		<cfargument name="handlerRoot" type="string" required="true">
		<cfset var newID = createUUID()>
		
		<cfif not validData(arguments)>
			<cfset variables.utils.throw("QuestionTypeCFC","QuestionType data is not valid.")>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			insert into #variables.tableprefix#questiontypes(id,name,handlerroot)
			values(
				<cfqueryparam value="#newID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
				<cfqueryparam value="#arguments.handlerRoot#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">
				)
		</cfquery>
	
		<cfreturn newID>		
	</cffunction>

	<cffunction name="deleteQuestionType" access="public" returnType="void" output="false"
				hint="Deletes a questionType.">
		<cfargument name="id" type="uuid" required="true">
		
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#questionTypes
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
									
	</cffunction>

	<cffunction name="getQuestionType" access="public" returnType="query" output="false"
				hint="Returns a questionType.">
		<cfargument name="id" type="uuid" required="false">
		<cfset var qGetQT = "">
		
		<cfquery name="qGetQT" datasource="#variables.dsn#">
			select 	id, name, handlerRoot
			from	#variables.tableprefix#questiontypes
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
			
		<cfif qGetQT.recordCount>
			<cfreturn qGetQT>
		<cfelse>		
			<cfset variables.utils.throw("QuestionTypeCFC","Invalid QuestionType requested.")>
		</cfif>
								
	</cffunction>
	
	<cffunction name="getQuestionTypes" access="public" returnType="query" output="false"
				hint="Returns all the questionTypes.">
		<cfset var qGetQuestionTypes = "">
		
		<cfquery name="qGetQuestionTypes" datasource="#variables.dsn#">
			select		id, name, handlerroot
			from		#variables.tableprefix#questiontypes
			order by 	name asc
		</cfquery>
		
		<cfreturn qGetQuestionTypes>
			
	</cffunction>

	<cffunction name="updateQuestionType" access="public" returnType="void" output="false"
				hint="Adds a new questionType to the db.">
		<cfargument name="id" type="uuid" required="true" hint="QuestionType ID.">
		<cfargument name="name" type="string" required="true">
		<cfargument name="handlerRoot" type="string" required="true">

		<cfif not validData(arguments)>
			<cfset variables.utils.throw("QuestionTypeCFC","QuestionType data is not valid.")>
		</cfif>
								
		<cfquery datasource="#variables.dsn#">
			update #variables.tableprefix#questiontypes
				set
					name = <cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
					handlerroot = <cfqueryparam value="#arguments.handlerRoot#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
				where id = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="validData" access="public" returnType="boolean" output="false"
				hint="Checks to see if the questionType is valid.">
		<cfargument name="data" type="struct" required="true" hint="Data to validate.">
		
		<cfif not structKeyExists(data,"name") or not len(trim(data.name)) or
			  not structKeyExists(data,"handlerRoot") or not len(trim(data.handlerRoot))>
			<cfreturn false>
		</cfif>
				
		<cfreturn true>
		
	</cffunction>

</cfcomponent>