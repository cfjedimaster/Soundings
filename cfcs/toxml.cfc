<!---
	Name         : toxml
	Author       : Raymond Camden (ray@camdenfamily.com) 
	Created      : 2006
	Last Updated : 5/12/07
	History      : Switched to stringbuffer (rkc 7/13/06)
				 : xmlFormat doesn't strip out extended MS chars (rkc 11/2/06)
				 : strip another char (rkc 5/12/07)
--->
<cfcomponent displayName="To XML" hint="Set of utility functions to generate XML" output="false">

<cffunction name="arrayToXML" returnType="string" access="public" output="false" hint="Converts an array into XML">
	<cfargument name="data" type="array" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">

	<cfset var s = createObject('java','java.lang.StringBuffer').init("<?xml version=""1.0"" encoding=""UTF-8""?>")>
	<cfset var x = "">
	
	<cfset s.append("<#arguments.rootelement#>")>

	<cfloop index="x" from="1" to="#arrayLen(arguments.data)#">
		<cfset s.append("<#arguments.itemelement#>#xmlFormatBetter(arguments.data[x])#</#arguments.itemelement#>")>
	</cfloop>

	<cfset s.append("</#arguments.rootelement#>")>
	
	<cfreturn s.toString()>
</cffunction>

<cffunction name="listToXML" returnType="string" access="public" output="false" hint="Converts a list into XML.">
	<cfargument name="data" type="string" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfargument name="delimiter" type="string" required="false" default=",">
	
	<cfreturn arrayToXML( listToArray(arguments.data, arguments.delimiter), arguments.rootelement, arguments.itemelement)>
</cffunction>

<cffunction name="queryToXML" returnType="string" access="public" output="false" hint="Converts a query to XML">
	<cfargument name="data" type="query" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfargument name="cDataCols" type="string" required="false" default="">
	
	<cfset var s = createObject('java','java.lang.StringBuffer').init("<?xml version=""1.0"" encoding=""UTF-8""?>")>
	<cfset var col = "">
	<cfset var columns = arguments.data.columnlist>
	<cfset var txt = "">

	<cfset s.append("<#arguments.rootelement#>")>
	
	<cfloop query="arguments.data">
		<cfset s.append("<#arguments.itemelement#>")>

		<cfloop index="col" list="#columns#">
			<cfset txt = arguments.data[col][currentRow]>
			<cfif isSimpleValue(txt)>
				<cfif listFindNoCase(arguments.cDataCols, col)>
					<cfset txt = "<![CDATA[" & txt & "]]" & ">">
				<cfelse>
					<cfset txt = xmlFormatBetter(txt)>
				</cfif>
			<cfelse>
				<cfset txt = "">
			</cfif>

			<cfset s.append("<#col#>#txt#</#col#>")>

		</cfloop>
		
		<cfset s.append("</#arguments.itemelement#>")>	
	</cfloop>
	
	<cfset s.append("</#arguments.rootelement#>")>
	
	<cfreturn s.toString()>
</cffunction>

<cffunction name="structToXML" returnType="string" access="public" output="false" hint="Converts a struct into XML.">
	<cfargument name="data" type="struct" required="true">
	<cfargument name="rootelement" type="string" required="true">
	<cfargument name="itemelement" type="string" required="true">
	<cfset var s = createObject('java','java.lang.StringBuffer').init("<?xml version=""1.0"" encoding=""UTF-8""?>")>

	<cfset var keys = structKeyList(arguments.data)>
	<cfset var key = "">

	<cfset s.append("<#arguments.rootelement#>")>	
	<cfset s.append("<#arguments.itemelement#>")>

	<cfloop index="key" list="#keys#">
		<cfset s.append("<#key#>#xmlFormatBetter(arguments.data[key])#</#key#>")>
	</cfloop>
	
	<cfset s.append("</#arguments.itemelement#>")>
	<cfset s.append("</#arguments.rootelement#>")>
	
	<cfreturn s.toString()>		
</cffunction>

<!--- Based on safetext from Nathan Dintenfas --->
<cffunction name="xmlFormatBetter" returnType="string" access="public" output="false" hint="A real working XMLFormat.">
	<cfargument name="txt" type="string" required="true">

	<!--- Fix damn smart quotes. Thank you Microsoft! --->
	<!--- This line taken from Nathan Dintenfas' SafeText UDF --->
	<!--- www.cflib.org/udf.cfm/safetext --->
	<cfset arguments.txt = replaceList(arguments.txt,chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230) & "," & chr(25),"',',"","",--,--,..., ")>
	<!--- stuff to remove --->
	<cfset arguments.txt = replace(arguments.txt, chr(8211), "", "all")>
										
	<cfreturn xmlFormat(arguments.txt)>
</cffunction>

</cfcomponent>