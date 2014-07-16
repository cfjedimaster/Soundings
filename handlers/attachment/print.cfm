<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/textbox/print.cfm
	Author       : Raymond Camden 
	Created      : January 4, 2009
	Last Updated : January 4, 2009
	History      : 
	Purpose		 : Supports Textbox, single and multi
--->

<cfparam name="attributes.single" default="true">
<cfparam name="attributes.step">

<cfoutput>
#attributes.step#) #attributes.question.question# <cfif attributes.question.required EQ 1><strong class="required">(*)</strong></cfif><br/>

<cfif attributes.single>
#repeatChars("_",50)#
<cfelse>
<div class="box"></div>
</cfif>
</cfoutput>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">