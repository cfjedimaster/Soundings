<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoicemulti/display.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : Supports Multiple Choice Multi w/ Other
--->

<cfparam name="attributes.r_result" default="result">

<!--- Multichoice other is just a modified version --->
<cfmodule template="../multiplechoice/display.cfm" attributeCollection="#attributes#" 
	single=false other=false/>
	
<!--- pass up the answer --->	
<cfif structKeyExists(variables,attributes.r_result)>
	<cfset caller[attributes.r_result] = variables[attributes.r_result]>
</cfif>

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">