<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textboxmulti/display.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : September 21, 2004
	History      : 
	Purpose		 : Supports Textbox, single and multi
--->

<cfparam name="attributes.r_result" default="result">

<!--- Multichoice other is just a modified version --->
<cfmodule template="../textbox/display.cfm" attributeCollection="#attributes#" 
	single=false />
	
<!--- pass up the answer --->	
<cfif structKeyExists(variables,attributes.r_result)>
	<cfset caller[attributes.r_result] = variables[attributes.r_result]>
</cfif>

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">