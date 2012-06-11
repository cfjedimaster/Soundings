<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/yesno/stats.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : 
--->

<cfparam name="attributes.surveyidfk">
<cfparam name="attributes.questionidfk">
<cfparam name="attributes.r_data" type="variablename">

<cfmodule template="../truefalse/stats.cfm" attributeCollection="#attributes#" 
	r_data="data"/>

<cfset caller[attributes.r_data] = data>				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">