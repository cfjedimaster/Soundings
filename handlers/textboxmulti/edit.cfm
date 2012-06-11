<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textboxmulti/edit.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : SSupports Textbox
--->

<!--- Multichoice other is just a modified version --->
<cfmodule template="../textbox/edit.cfm" attributeCollection="#attributes#" />

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">