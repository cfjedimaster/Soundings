<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoicemulti/save.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : September 21, 2004
	History      : 
	Purpose		 : Supports True/False, Yes/No
--->


<!--- Multichoice other is just a modified version --->
<cfmodule template="../multiplechoice/save.cfm" attributeCollection="#attributes#" 
	single=false/>
	
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">