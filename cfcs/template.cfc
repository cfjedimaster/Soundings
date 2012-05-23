<!---
	Name         : cfcs/template.cfc
	Author       : Raymond Camden 
	Created      : 
	Last Updated : December 9, 2008
	History      : 
	Purpose		 : 
--->

<cfcomponent displayName="Template" hint="Template handler." output="false">

	<cfset variables.utils = createObject("component","utils")>

	<cffunction name="init" access="public" returnType="template" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" >
		
		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.dbtype = arguments.settings.dbtype>
		<cfset variables.tableprefix = arguments.settings.tableprefix>
		
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addTemplate" access="public" returnType="uuid" output="false"
				hint="Adds a new template to the the db.">
		<cfargument name="name" type="string" required="true">
		<cfargument name="header" type="string" required="true">
		<cfargument name="footer" type="string" required="true">
		<cfargument name="useridfk" type="string" required="true">

		<cfset var newID = createUUID()>
		
		<cfif not validData(arguments)>
			<cfset variables.utils.throw("TemplateCFC","Template data is not valid.")>
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			insert into #variables.tableprefix#templates(id,name,header,footer,useridfk)
			values(
				<cfqueryparam value="#newID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				<cfqueryparam value="#arguments.header#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#arguments.footer#" cfsqltype="cf_sql_longvarchar">,
				<cfqueryparam value="#arguments.useridfk#" cfsqltype="cf_sql_varchar" maxlength="35">
				)
		</cfquery>
	
		<cfreturn newID>		
	</cffunction>

	<cffunction name="deleteTemplate" access="public" returnType="void" output="false"
				hint="Deletes a template.">
		<cfargument name="id" type="uuid" required="true">

		<cfquery datasource="#variables.dsn#">
			update	#variables.tableprefix#surveys
			set		templateidfk = null
			where	templateidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#templates
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
									
	</cffunction>

	<cffunction name="getTemplate" access="public" returnType="query" output="false"
				hint="Returns a template.">
		<cfargument name="id" type="uuid" required="true">
		<cfargument name="useridfk" type="uuid" required="false">
		<cfset var qGet = "">
		
		<cfquery name="qGet" datasource="#variables.dsn#">
			select 	id, name, header, footer, useridfk
			from	#variables.tableprefix#templates
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			<cfif structKeyExists(arguments, "useridfk")>
			and		useridfk = <cfqueryparam value="#arguments.useridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfif>
		</cfquery>
			
		<cfif qGet.recordCount>
			<cfreturn qGet>
		<cfelse>		
			<cfset variables.utils.throw("TemplateCFC","Invalid Template requested.")>
		</cfif>
								
	</cffunction>
	
	<cffunction name="getTemplates" access="public" returnType="query" output="false"
				hint="Returns all the templates.">
		<cfargument name="useridfk" type="uuid" required="false">					
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.dsn#">
			select		t.id, t.name, t.header, t.footer, t.useridfk, u.username
			from		#variables.tableprefix#templates t, #variables.tableprefix#users u
            where		t.useridfk = u.id	
    		<cfif structKeyExists(arguments, "useridfk")>
			and			t.useridfk = <cfqueryparam value="#arguments.useridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfif>
			order by 	name asc
		</cfquery>
		
		<cfreturn q>
			
	</cffunction>

	<cffunction name="updateTemplate" access="public" returnType="void" output="false"
				hint="Updates a template.">
		<cfargument name="id" type="uuid" required="true" hint="QuestionType ID.">
		<cfargument name="name" type="string" required="true">
		<cfargument name="header" type="string" required="true">
		<cfargument name="footer" type="string" required="true">
		<cfargument name="useridfk" type="string" required="true">

		<cfif not validData(arguments)>
			<cfset variables.utils.throw("TemplateCFC","Template data is not valid.")>
		</cfif>
								
		<cfquery datasource="#variables.dsn#">
			update #variables.tableprefix#templates
				set
					name = <cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
					header = <cfqueryparam value="#arguments.header#" cfsqltype="cf_sql_longvarchar">,
					footer = <cfqueryparam value="#arguments.footer#" cfsqltype="cf_sql_longvarchar">
				where id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				and   useridfk = <cfqueryparam value="#arguments.useridfk#" cfsqltype="cf_sql_varchar" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="validData" access="public" returnType="boolean" output="false"
				hint="Checks to see if the template is valid.">
		<cfargument name="data" type="struct" required="true" hint="Data to validate.">
		
		<cfif not structKeyExists(data,"name") or not len(trim(data.name)) or
			  not structKeyExists(data,"header") or
			  not structKeyExists(data,"footer") or
			  not structKeyExists(data,"useridfk") or not len(trim(data.useridfk))
	  		>
			<cfreturn false>
		</cfif>
				
		<cfreturn true>
		
	</cffunction>

</cfcomponent>