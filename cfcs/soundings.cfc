<cfcomponent displayName="Soundings" hint="Core CFC for the application. Main purpose is to handle settings." output="false">

	<cffunction name="getSettings" access="public" returnType="struct" output="false"
				hint="Returns application settings as a structure.">
		
		<!--- load the settings from the ini file --->
		<cfset var settingsFile = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all") & "/settings.xml.cfm">
		<cfset var r = structNew()>
		<cfset var buffer = "">
		<cfset var data = "">
		<cfset var key = "">
		<cffile action="read" file="#settingsFile#" variable="buffer">
		<!--- remove comments from xml string --->
		<cfset buffer = replace(buffer, "<!---", "")>
		<cfset buffer = replace(buffer, "--->", "")>
		<!--- convert to xml --->
		<cfset data = xmlParse(buffer)>

		<cfloop item="key" collection="#data.settings#">
			<cfset r[key] = data.settings[key].xmlText>
		</cfloop>
		
		<cfreturn r>
		
	</cffunction>
	
	<cffunction name="setPassword" access="public" returnType="void" output="false" roles="surveyadmin"
				hint="Updates the password">
		<cfargument name="password" type="string" required="true" hint="Hashed version of password.">
		<cfset var settingsFile = replace(getDirectoryFromPath(getCurrentTemplatePath()),"\","/","all") & "/settings.ini">

		<cfset setProfileString(settingsFile,"settings","password",arguments.password)>
	</cffunction>
	
</cfcomponent>