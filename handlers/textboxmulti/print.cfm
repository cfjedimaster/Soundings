<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textboxmulti/print.cfm
	Author       : Raymond Camden 
	Created      : January 4, 2009
	Last Updated : January 4, 2004
	History      : 
	Purpose		 : Supports Textbox, single and multi
--->


<!--- Multichoice other is just a modified version --->
<cfmodule template="../textbox/print.cfm" attributeCollection="#attributes#" 
	single=false />
	
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">