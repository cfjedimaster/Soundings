<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoiceother/edit.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : Supports Multiple Choice
--->

<!--- Multichoice other is just a modified version  --->
<cfmodule template="../multiplechoice/edit.cfm" attributeCollection="#attributes#" other="true" />

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">