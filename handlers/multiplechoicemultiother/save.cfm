<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoicemultiother/display.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : Supports Multiple Choice Multi w/ Other
--->


<!--- Multichoice other is just a modified version --->
<cfmodule template="../multiplechoice/save.cfm" attributeCollection="#attributes#" 
	single=false other=true/>
	
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">