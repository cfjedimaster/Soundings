<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoicemulti/print.cfm
	Author       : Raymond Camden 
	Created      : January 4, 2009
	Last Updated : January 4, 2009
	History      : 
	Purpose		 : Supports Multiple Choice Multi 
--->

<!--- Multichoice other is just a modified version --->
<cfmodule template="../multiplechoice/print.cfm" attributeCollection="#attributes#" 
	single=false other=false/>
	
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">