<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/yesno/save.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : 
--->

<cfparam name="attributes.r_result" default="result">

<!--- Multichoice other is just a modified version --->
<cfmodule template="../truefalse/save.cfm" attributeCollection="#attributes#" />

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">