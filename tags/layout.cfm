<cfsetting enablecfoutputonly=true>
<!---
	Name         : layout.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : March 10, 2006
	History      : Work w/o mappings (rkc 3/10/06)
	Purpose		 : Loads up templates. Will look in a subdirectory for templates, 
				   and will load #attributes.template#_header.cfm and 
				   #attributes.template#_footer.cfm
--->

<!--- Because "template" is a reserved attribute for cfmodule, we allow templatename as well. --->
<cfif isDefined("attributes.templatename")>
	<cfset attributes.template = attributes.templatename>
</cfif>
<cfparam name="attributes.template">
<cfparam name="attributes.title" default="">
<cfparam name="attributes.loadspry" default="false">

<cfset base = "../pagetemplates/" & attributes.template>

<cfif thisTag.executionMode is "start">
	<cfset myFile = base & "_header.cfm">
<cfelse>
	<cfset myFile = base & "_footer.cfm">
</cfif>

<cfinclude template="#myFile#">

<cfsetting enablecfoutputonly=false>