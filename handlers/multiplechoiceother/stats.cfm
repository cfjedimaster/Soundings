<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/mcmultiother/stats.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : September 21, 2004
	History      : 
	Purpose		 : Supports True/False, Yes/No
--->

<cfparam name="attributes.questionidfk">
<cfparam name="attributes.getother" default="false">
<cfparam name="attributes.r_data" type="variablename">

<cfmodule template="../multiplechoice/stats.cfm" attributeCollection="#attributes#" 
	other=true r_data="data"/>
	
<cfset caller[attributes.r_data] = data>				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">