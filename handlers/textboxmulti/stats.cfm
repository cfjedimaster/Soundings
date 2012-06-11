<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textboxmulti/stats.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : September 21, 2004
	History      : 
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.questionidfk">
<cfparam name="attributes.r_data" type="variablename">

<cfmodule template="../textbox/stats.cfm" attributeCollection="#attributes#" 
	single=false r_data="data"/>
	
<cfset caller[attributes.r_data] = data>				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">