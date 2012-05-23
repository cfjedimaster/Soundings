<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/multiplechoice/print.cfm
	Author       : Raymond Camden 
	Created      : January 4, 2009
	Last Updated : January 4, 2009
	History      : 
	Purpose		 : 
--->

<cfparam name="attributes.single" default="true">
<cfparam name="attributes.other" default="false">
<cfparam name="attributes.question">
<cfparam name="attributes.step">

<cfset showForm = true>
<cfset forceOther = false>

<cfset c = 65>	

<cfset answers = application.question.getAnswers(attributes.question.id)>	

<cfoutput>
<p> 
#attributes.step#) #attributes.question.question# <cfif attributes.single>(Select One)<cfelse>(Select Any)</cfif> <cfif attributes.question.required EQ 1><strong class="required">(*)</strong></cfif><br/>
<cfif attributes.single>
	<cfset type="radio">
<cfelse>
	<cfset type="checkbox">
</cfif>
<cfloop query="answers">
#chr(c)#) #answer#<br>
<cfset c = c + 1>
<!--- if for some reason we had answers a through z, repeat z, which is insane, but so is so many options --->
<cfif c gt 90>
	<cfset c = 90>
</cfif>
</cfloop>

<cfif attributes.other>
Other: #repeatChars("_",50)#<br/>
</cfif>
</p>
</cfoutput>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">