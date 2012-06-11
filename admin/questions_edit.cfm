<cfsetting enablecfoutputonly=true>
<!---
	Name         : questions_edit.cfm
	Author       : Raymond Camden 
	Created      : September 17, 2004
	Last Updated : September 17, 2004
	History      : 
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<cfif not isDefined("url.surveyidfk")>
	<cflocation url="questions.cfm" addToken="false">
</cfif>
<cfif isDefined("form.cancel")>
	<cflocation url="questions.cfm?surveyidfk=#url.surveyidfk#" addToken="false">
</cfif>

<!--- get question if not new --->
<cfif url.id neq 0>
	<cfset question = application.question.getQuestion(url.id)>
	<cfset form.questionType = question.questionTypeIDFK>
</cfif>


<!--- get question types --->
<cfset qts = application.questiontype.getQuestionTypes()>
<!--- get all questions for survey --->
<cfset questions = application.question.getQuestions(url.surveyidfk)>

<tags:layout templatename="admin" title="Question Editor">

<cfif isDefined("url.questionType")>
	<cfset form.questionType = url.questionType>
</cfif>
<cfif not isDefined("form.questionType")>

	<cfoutput>
	<p>
	<form action="questions_edit.cfm?#cgi.query_string#" method="post">
	Please select a question type: 
	<select name="questionType">
	<cfloop query="qts">
	<option value="#id#">#name#</option>
	</cfloop>
	</select>
	<br>
	<input type="submit" value="Submit"> <input type="submit" name="cancel" value="Cancel">
	</form>
	</p>
	</cfoutput>
	
<cfelse>

	<cfset qt = application.questionType.getQuestionType(form.questionType)>
	
	<cfset qs = cgi.query_string>
	<cfif not findNoCase("questionType",qs)>
		<cfset qs = qs & "&questionType=#form.questionType#">
	</cfif>
	
	<cfset extra = structNew()>
	<cfif url.id is not 0>
		<!--- pass the question in --->
		<cfset extra.question = question>
	</cfif>
	
	<cfset top = application.survey.getTopRank(surveyidfk)>
	
	<!--- fire edit handler for qt --->
	<cfoutput><div id="formwatcher"></cfoutput>
	
	<cfmodule template="../handlers/#qt.handlerRoot#/edit.cfm" 
		queryString="#qs#" 
		surveyidfk="#surveyidfk#" 
		topRank="#top#"
		questionType="#qt#"
		attributeCollection="#extra#"
		questions="#questions#"
			  
		 />
	<cfoutput></div></cfoutput>
	
	<!--- live preview box --->
	<cfoutput>
	<script>
	$(document).ready(function() {
		function doPreview(){
			//gather all the form fields
			var fields = $("##formwatcher input").serializeArray();
			var data = $.toJSON(fields);
			$.post("preview.cfm", {data:data,questiontype:'#qt.id#'}, function(res) {
				$("##livepreviewbox").html(res);
			});		
		}
		$("##formwatcher input").change(doPreview);
		doPreview();
	});
	</script>
	<style>
	##livepreview {
		width: 90%;
		//height: 200px;
		margin:10px;
		padding: 5px;
		border-style:solid;
		border-width: thin;
    }
	
	##livepreview h2 {
		margin-top:0px;
	}
	</style>
	<div id="livepreview">
		<h2>Live Preview</h2>
		<div id="livepreviewbox"></div>
	</div>
	</cfoutput>
	
</cfif>


</tags:layout>

<cfsetting enablecfoutputonly=false>