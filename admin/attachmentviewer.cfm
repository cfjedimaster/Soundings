<cfsetting enablecfoutputonly=true>

<!--- 
Handles viewing an attachment. Only run for admin users, but let's be a bit more anal and ensure it 
exists in the attachment dir and no .. exists.
--->
<cfparam name="url.attachment">
<cfif find("../", url.attachment) or find("..\", url.attachment)>
	<cfabort>
</cfif>

<cfif not fileExists(application.settings.attachmentdir & "/" & url.attachment)>
	<cfabort>
</cfif>

<cfcontent file="#application.settings.attachmentdir#/#url.attachment#" reset="true">