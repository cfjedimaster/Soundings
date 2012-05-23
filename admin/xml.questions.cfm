<cfsetting enablecfoutputonly=true showdebugoutput=false>
<!---
	Name         : xml.questions.cfm
	Author       : Raymond Camden 
	Created      : July 10, 2007
	Last Updated : 
	History      : 
	Purpose		 : XML view for questions
--->

<cfparam name="url.survey" default="">

<cfset questions = application.question.getQuestions(url.survey)>		
<cfset xml = application.toxml.queryToXML(questions, "questions", "question")>

<cfcontent type="text/xml"><cfoutput>#xml#</cfoutput>