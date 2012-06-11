<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/yesno/edit.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : 
--->

<!--- Yes/No is just a modified version of T/F --->
<cfmodule template="../truefalse/edit.cfm" attributeCollection="#attributes#" yesno=true />

<cfsetting enablecfoutputonly=false>

<cfexit method="exitTag">