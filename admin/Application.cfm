<cfsetting enablecfoutputonly=true>
<!---
	Name         : Application.cfm
	Author       : Raymond Camden 
	Created      : September 2, 2004
	Last Updated : September 2, 2004
	History      : 
	Purpose		 : 
--->

<!--- include root app --->
<cfinclude template="../Application.cfm">

<cfif not request.udf.isLoggedOn()>
	<cfinclude template="login.cfm">
	<cfabort>
</cfif>

<cfsetting enablecfoutputonly=false>