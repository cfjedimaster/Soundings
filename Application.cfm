<cfsetting enablecfoutputonly=true showdebugoutput=false>
<!---
	Name         : Application.cfm
	Author       : Raymond Camden 
	Created      : September 2, 2004
	Last Updated : August 3, 2007
	History      : change application.cfc to soundings.cfc
				 : Stupid IE. If you hit ENTER instead of clicking the button, it wouldn't send the value. (rkc 3/1/06)
				 : work w/o mapping (rkc 3/10/06)
				 : user changes (rkc 8/3/07)
	Purpose		 : 
--->

<cfapplication name="soundings" sessionManagement="true">

<cfif not isDefined("application.init") or isDefined("url.reinit")>

	<!--- Get main settings --->
	<cfset application.soundings = createObject("component","cfcs.soundings")>
	<cfset application.settings = application.soundings.getSettings()>
	<cfset application.survey = createObject("component","cfcs.survey").init(application.settings)>
	<cfset application.question = createObject("component","cfcs.question").init(application.settings)>
	<cfset application.questionType = createObject("component","cfcs.questiontype").init(application.settings)>
	<cfset application.template = createObject("component","cfcs.template").init(application.settings)>
	<cfset application.user = createObject("component","cfcs.user").init(application.settings)>
	<cfset application.utils = createObject("component","cfcs.utils")>
	<cfset application.toxml = createObject("component","cfcs.toxml")>
		
	<cfset session.surveys = structNew()>

	<!---
	A required setting is attachment dir. We need to ensure it exists.
	--->
	<cfif not directoryExists(application.settings.attachmentdir)>
		<cfthrow message="Directory specified as the attachment directory does not exist.">
	</cfif>
	<cfset application.init = true>
	<cfset application.chartformat = "flash">

	<cftry>
		<cfif server.coldfusion.productname EQ "railo">
			<cfset application.chartformat = "png">
		</cfif>
		<cfcatch></cfcatch>
	</cftry>
	
</cfif>

<!--- include UDFs --->
<cfinclude template="includes/udf.cfm">

<cfif isDefined("url.logout")>
	<cfset structDelete(session, "loggedin")>
</cfif>

<!--- handle security --->
<cfif not request.udf.isLoggedOn()>

	<!--- are we trying to logon? --->
	<cfif isDefined("form.username") and isDefined("form.password")>
		<cfif application.user.authenticate(form.username,form.password)>
			<cfset session.user = application.user.getUser(form.username)>
			<cfset session.loggedin = true>
		</cfif>
	</cfif>
	
</cfif>

<cfsetting enablecfoutputonly=false>
