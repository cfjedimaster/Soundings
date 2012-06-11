<cfsetting enablecfoutputonly=true>
<!---
	Name         : questiontypes.cfm
	Author       : Raymond Camden 
	Created      : September 6, 2004
	Last Updated : September 6, 2004
	History      : 
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<!--- Security Check --->
<cfif not isBoolean(session.user.isAdmin) or not session.user.isAdmin>
	<cflocation url="index.cfm" addToken="false">
</cfif>

<tags:layout templatename="admin" title="Question Type Editor">

	<!--- handle deletions --->
	<cfif isDefined("form.mark") and len(form.mark)>
		<cfloop index="id" list="#form.mark#">
			<cfset application.questionType.deleteQuestionType(id)>
		</cfloop>
		<cfoutput>
		<p>
		<b>QuestionType(s) deleted.</b>
		</p>
		</cfoutput>
	</cfif>
	
	<!--- get qts --->
	<cfset qts = application.questionType.getQuestionTypes()>

	
	<tags:datatable data="#qts#" list="name,handlerroot" editlink="questiontypes_edit.cfm" linkcol="name" label="QuestionType"
					deleteMsg="Warning - this will delete the questionType including all related questions.">
		<tags:datacol colname="name" label="Name" width="400" />	
		<tags:datacol colname="handlerroot" label="Handler Root" width="200" />	
	</tags:datatable>

</tags:layout>

<cfsetting enablecfoutputonly=false>