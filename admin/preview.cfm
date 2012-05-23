<cfparam name="form.data" default="">
<cfparam name="form.questiontype" default="">

<cfif not isJSON(form.data)>
	<cfoutput>
	Sorry, we cannot render this preview.
	</cfoutput>
	<cfabort/>
</cfif>
<cfset data = deserializeJSON(form.data)>
<cfset qt = application.questionType.getQuestionType(form.questionType)>

<cfmodule template="../handlers/#qt.handlerRoot#/preview.cfm" 
	data="#data#" />
