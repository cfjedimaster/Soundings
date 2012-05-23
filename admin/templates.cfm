<cfsetting enablecfoutputonly=true>
<!---
	Name         : templates.cfm
	Author       : Raymond Camden 
	Created      : December 9, 2008
	Last Updated : December 9, 2008
	History      : 
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<tags:layout templatename="admin" title="Template Editor">

	<!--- handle deletions --->
	<cfif isDefined("form.mark") and len(form.mark)>
		<cfloop index="id" list="#form.mark#">
        	<cfif not session.user.isAdmin>
				<cfset application.template.deleteTemplate(id,session.user.id)>
            <cfelse>
            	<cfset application.template.deleteTemplate(id)>
            </cfif>
		</cfloop>
		<cfoutput>
		<p>
		<b>Template(s) deleted.</b>
		</p>
		</cfoutput>
	</cfif>
	
	
	<!--- get qts --->
	<cfif not session.user.isAdmin>
		<cfset ts = application.template.getTemplates(session.user.id)>
	<cfelse>
		<cfset ts = application.template.getTemplates()>
	</cfif>	

	<tags:datatable data="#ts#" list="name" editlink="template_edit.cfm" linkcol="name" label="Template">
		<tags:datacol colname="name" label="Name" width="400" />
        <cfif session.user.isAdmin>
			<tags:datacol colname="username" label="User" width="200" />	
		</cfif>
	</tags:datatable>

</tags:layout>

<cfsetting enablecfoutputonly=false>