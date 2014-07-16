<cfsetting enablecfoutputonly=true>
<!---
	Name         : surveydisplay.cfm
	Author       : Raymond Camden 
	Created      : September 21, 2004
	Last Updated : November 14, 2007
	History      : work w/o mapping (rkc 3/10/06)
				 : Include title of survey (rkc 4/10/06)
				 : Fix for broken arrays (rkc 8/22/07)
				 : problem with maxquestions (rkc 11/14/07)
	Purpose		 : Handles the survey display. 
--->

<cfparam name="attributes.survey">
<cfset surveyComplete = false>

<!--- Initialize in session scope if it doesn't exist --->
<cfif not structKeyExists(session,"surveys")>
	<cfset session.surveys = structNew()>
</cfif>

<!--- Initialize certain values in the session struct --->
<cfif not structKeyExists(session.surveys,attributes.survey.id)>
	<cfset session.surveys[attributes.survey.id] = structNew()>
	<cfset session.surveys[attributes.survey.id].currentStep = 1>
	<cfset session.surveys[attributes.survey.id].answers = structNew()>
	<cfset session.surveys[attributes.survey.id].maxQuestions = application.question.getQuestions(attributes.survey.id).recordCount>
	<cfset session.surveys[attributes.survey.id].toskip = structNew()>
</cfif>

<!--- First see if survey is protected --->
<!--- Is it protected by date begin? --->
<cfif isDate(attributes.survey.dateBegin) and dateCompare(attributes.survey.dateBegin,now()) gte 0>
	<cfoutput>
	<p>
	<div class="surveyMessages">Sorry, but this survey has not yet begun.</div>
	</p>
	</cfoutput>
	<cfabort>
</cfif>
<!--- Is it protected by date end? --->
<cfif isDate(attributes.survey.dateEnd) and dateCompare(attributes.survey.dateEnd,now()) is -1>
	<cfoutput>
	<p>
	<div class="surveyMessages">Sorry, but this survey is over.</div>
	</p>
	</cfoutput>
	<cfabort>
</cfif>
<!--- Is it protected by password? --->
<cfif len(attributes.survey.surveypassword) and not structKeyExists(session.surveys[attributes.survey.id],"auth")>
	<cfset showForm = true>
	<cfset showError = false>
	<cfif isDefined("form.password")>
		<cfif form.password eq attributes.survey.surveypassword>
			<cfset session.surveys[attributes.survey.id].auth = true>
			<cfset showForm = false>
		<cfelse>
			<cfset showError = true>
		</cfif>
	</cfif>
	
	<cfif showForm>
		<cfoutput>
		<p>
		<div class="surveyMessages">In order to use this survey, you must enter a password. This password should have been
		sent to you with your survey invitation.</div>
		<cfif showError></p><p><b>Sorry, but the password you entered is not correct.</b></cfif>
		<form action="#cgi.script_name#?#cgi.query_string#" method="post"> 
		<input type="password" name="password"> <input type="submit" value="Enter Password">
		</form>
		</p>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>
<!--- Is it protected by an email list? --->
<cfif len(attributes.survey.emaillist) and not structKeyExists(session.surveys[attributes.survey.id],"auth")>
	<cfset showForm = true>
	<cfset showError = false>
	<cfset showDone = false>
	<cfif isDefined("form.email")>
		<cfif listFindNoCase(attributes.survey.emailList, form.email)>
			<cfif application.survey.surveyCompletedBy(attributes.survey.id,form.email)>
				<cfset showDone = true>
			<cfelse>
				<cfset session.surveys[attributes.survey.id].auth = true>
				<cfset session.surveys[attributes.survey.id].owner = form.email>
				<cfset showForm = false>
			</cfif>
		<cfelse>
			<cfset showError = true>
		</cfif>
	</cfif>
	
	<cfif showForm>
		<cfoutput>
		<p>
		<div class="surveyMessages">This survey is only open to a certain list of email addresses. In order to continue, you must
		enter your email address.</div>
		</p>
		<cfif showDone></p><p><div class="error">The email address, #form.email#, has already taken the survey.</div></cfif>
		<cfif showError></p><p><div class="error">Sorry, but the email address you entered is not on the list of allowed addresses.</div></cfif>
		<form action="#cgi.script_name#?#cgi.query_string#" method="post">
		<input type="text" name="email"> <input type="submit" value="Enter Email Address">
		</form>
		</p>
		</cfoutput>
		<cfabort>
	</cfif>
</cfif>

<!--- Get a pointer to current session info on the survey --->
<cfset currentInfo = session.surveys[attributes.survey.id]>

<!--- how many per page? --->
<cfif isNumeric(attributes.survey.questionsperpage)>
	<cfset perpage = attributes.survey.questionsperpage>
<cfelse>
	<cfset perpage = application.settings.perpage>
</cfif>
<!--- how many pages? --->
<cfset numPages = currentInfo.maxQuestions \ perpage>
<cfif currentInfo.maxQuestions/perpage neq currentInfo.maxQuestions\perpage>
	<cfset numPages = numPages + 1>
</cfif>
<cfif currentInfo.currentStep gt 1>
	<cfset firstOnPage = (currentInfo.currentStep-1) * perpage + 1>
<cfelse>
	<cfset firstOnPage = 1>
</cfif>
<cfset lastOnPage = min(firstOnPage + perpage - 1, currentInfo.maxQuestions)>

<!--- They finished the survey --->
<cfif firstOnPage gt currentInfo.maxQuestions>
	<cfset extra = structNew()>
	<cfif structKeyExists(session.surveys[attributes.survey.id],"owner")>
		<cfset extra.owner = session.surveys[attributes.survey.id].owner>
	</cfif>		
	<cf_surveycomplete survey="#attributes.survey#" data="#session.surveys[attributes.survey.id]#" attributeCollection="#extra#"/>
	<cfset structDelete(session.surveys,attributes.survey.id)>
	<cfset surveyComplete = true>
</cfif>

<cfif isDefined("form.goback")>
	<!--- go back a step --->
	<cfif currentInfo.currentStep gte 2>
		<cfset currentInfo.currentStep = currentInfo.currentStep - 1>
		
		<!--- 
		We need to check for skipped questions. It's possible when we answer
		question X, we were told to skip ahead N questions. If we were, then
		currentStep is marked as skipped. So I will subtract one and check again.
		I eventually end up where I'm allowed to be. 

		Note that we also auto remove them.
		--->
		<cfloop condition="structKeyExists(currentInfo.toskip, currentinfo.currentstep)">
			<cfset structDelete(currentInfo.toSkip, currentInfo.currentStep)>
			<cfset currentInfo.currentStep = currentInfo.currentStep - 1>
		</cfloop>

		<!---
		This is a direct cut and paste of the logic below, minus all done check. Idea is when
		you hit previous we still want to store your answers, but we ignore errors. 
		--->
		<cfset form.submit = true>
		<cfloop index="step" from="#firstOnPage#" to="#lastOnPage#">
	
			<!--- Get current step --->
			<cfset question = application.question.getQuestions(attributes.survey.id,step)>
	
			<!--- fire display handler for q --->
			<cfset answer = "">
			<cfif structKeyExists(currentInfo.answers, question.id)>
				<cfset answer = currentInfo.answers[question.id]>
			</cfif>
			<cfmodule template="../handlers/#question.handlerRoot#/display.cfm" 
				step="#step#" question="#question#" answer="#answer#" r_result="result#step#" />
			
			<cfif isDefined("result#step#")>
				<!--- save answer --->
				<cfset currentInfo.answers[question.id] = variables["result#step#"]>
				<!----
				<cfset currentInfo.answers[step] = variables["result#step#"]>
				--->
			</cfif>

		</cfloop>
		
		<cflocation url="#cgi.script_name#?#cgi.query_string#" addToken="false">
	</cfif>
</cfif>


<cfif not surveyComplete>
	<cfoutput>
	<div class="surveyName">#attributes.survey.name#</div>
	<!---
		TODO: Rework to a % for 1 per page question surveys
	--->
	<cfif numPages neq 1><div class="pages">Page #currentInfo.currentStep# out of #numPages#</div></cfif>
	<div class="intro">Questions marked with '<strong class="required">*</strong>' are required to complete the survey.</div>
	</cfoutput>
<cfelse>
	<cfoutput>
	<div class="surveyDone">Survey Complete!</div>
	</cfoutput>
</cfif>


<cfif not surveyComplete>

	<cfset allDone = true>

	<cfoutput>
	<form action="#cgi.script_name#?#cgi.query_string#" method="post" enctype="multipart/form-data">
	</cfoutput>
	
	<!--- loop from the first on page till end --->
	<cfloop index="step" from="#firstOnPage#" to="#lastOnPage#">
	
		<!--- Get current step --->
		<cfset question = application.question.getQuestions(attributes.survey.id,step)>

		<!--- fire display handler for q --->
		<cfset answer = "">
		<cfif structKeyExists(currentInfo.answers, question.id)>
			<cfset answer = currentInfo.answers[question.id]>
		</cfif>

		<cfmodule template="../handlers/#question.handlerRoot#/display.cfm" 
			step="#step#" question="#question#" answer="#answer#" r_result="result#step#" />
		
		<cfif isDefined("result#step#")>
			<!--- save answer --->
			<cfset currentInfo.answers[question.id] = variables["result#step#"]>
		<cfelse>
			<cfset allDone = false>
		</cfif>

		<cfset lastQuestion = question>
	</cfloop>

	<cfoutput>	
	<p>
	<cfif currentInfo.currentStep gt 1>
	<input type="submit" name="goback" value="Previous Page">
	</cfif>
	<input type="submit" name="submit" value="Submit Answer(s)">
	</p>
	</form>
	</cfoutput>
	
	<!--- 
	So this is the logic we need to modify for conditionals:
	
	Currently "currentStep" represents the page you are on. This works
	ok but for conditionals we need to go to a question, not a page. 
	However, we are going to document that a survey with conditionals
	should be using 1 question per page logic (and we may need to enforce it).
	
	So our logic here will be - look at the last question answered and determine if it
	has post conditional logic.

	Note - our code to load stuff in question.cfc works even if you have messed up ranks,
	ie: 1,2,4

	We can't rely on that. So I'll be updating deleteQuestion to correctly reset ranks.
	--->
	<cfif allDone>
		<cfif lastQuestion.branches[1].recordCount>
			<cfset branches = lastQuestion.branches[1]>
			<cfset setTarget = false>
			<cfloop query="branches">

				<cfif nextQuestionValue eq "">
					<!--- In this branch, we ALWAYS go to another q --->
					<cfset questionToLoad = application.question.getQuestion(nextQuestion)>
					<!--- remember we are skipping some --->
					<cfset fromSkip = currentInfo.currentStep + 1>
					<cfset toSkip = questionToLoad.rank-1>
					<cfloop index="x" from="#fromSkip#" to="#toSkip#">
						<cfset currentInfo.toSkip[fromSkip] = 1>
					</cfloop>
					<cfset currentInfo.currentStep = questionToLoad.rank>
					<cfset setTarget = true>
				<cfelse>
					<cfset answer = currentInfo.answers[lastQuestion.id]>
					<cfset theanswermatches = false>
					<!--- first do a simple check - assumes answer is simple --->
					<cfif isSimpleValue(answer) and answer is nextQuestionValue>
						<cfset theAnswerMatches = true>
					</cfif>
					<!--- next support our MC with a .list key --->
					<cfif isStruct(answer) and structKeyExists(answer,"list") and listFind(answer.list, nextQuestionValue)>
						<cfset theAnswerMatches = true>
					</cfif>	
					<cfif theanswermatches>
						<cfset questionToLoad = application.question.getQuestion(nextQuestion)>
						<cfset fromSkip = currentInfo.currentStep + 1>
						<cfset toSkip = questionToLoad.rank-1>
						<cfloop index="x" from="#fromSkip#" to="#toSkip#">
							<cfset currentInfo.toSkip[fromSkip] = 1>
						</cfloop>
						<cfset currentInfo.currentStep = questionToLoad.rank>
						<cfset setTarget = true>
					</cfif>
				</cfif>
				<cfif setTarget>
					<cfbreak>
				</cfif>
			</cfloop>

			<cfif not setTarget>
				<cfset currentInfo.currentStep = currentInfo.currentStep + 1>
			</cfif>

			<!---
			<!--- Ok, we definitely need to go someplace else. But do we have to have an answer? --->		
			<cfif lastQuestion.nextQuestionValue eq "">
				<!--- In this branch, we ALWAYS go to another q --->
				<cfset questionToLoad = application.question.getQuestion(lastQuestion.nextQuestion)>
				<!--- remember we are skipping some --->
				<cfset fromSkip = currentInfo.currentStep + 1>
				<cfset toSkip = questionToLoad.rank-1>
				<cfloop index="x" from="#fromSkip#" to="#toSkip#">
					<cfset currentInfo.toSkip[fromSkip] = 1>
				</cfloop>
				<cfset currentInfo.currentStep = questionToLoad.rank>
			<cfelse>
				<cfset answer = currentInfo.answers[lastQuestion.id]>
				<cfset theanswermatches = false>
				<!--- first do a simple check - assumes answer is simple --->
				<cfif isSimpleValue(answer) and answer is lastQuestion.nextQuestionValue>
					<cfset theAnswerMatches = true>
				</cfif>
				<!--- next support our MC with a .list key --->
				<cfif isStruct(answer) and structKeyExists(answer,"list") and listFind(answer.list, lastQuestion.nextQuestionValue)>
					<cfset theAnswerMatches = true>
				</cfif>	
				<cfif theanswermatches>
					<cfset questionToLoad = application.question.getQuestion(lastQuestion.nextQuestion)>
					<cfset fromSkip = currentInfo.currentStep + 1>
					<cfset toSkip = questionToLoad.rank-1>
					<cfloop index="x" from="#fromSkip#" to="#toSkip#">
						<cfset currentInfo.toSkip[fromSkip] = 1>
					</cfloop>
					<cfset currentInfo.currentStep = questionToLoad.rank>
				<cfelse>
					<cfset currentInfo.currentStep = currentInfo.currentStep + 1>
				</cfif>
			</cfif>
			--->
		<cfelse>
			<cfset currentInfo.currentStep = currentInfo.currentStep + 1>
		</cfif>
		<cflocation url="#cgi.script_name#?#cgi.query_string#" addToken="false">
	</cfif>
	
<cfelse>

	<cfif len(attributes.survey.thankYouMsg)>
		<cfoutput>
		<div class="surveyDone"><p>#attributes.survey.thankYouMsg#</p></div>
		</cfoutput>
	<cfelse>
		<cfoutput>
		<div class="surveyDone"><p>Thank you for finishing the survey.</p></div>
		</cfoutput>
	</cfif>
	
</cfif>

<cfsetting enablecfoutputonly=false>
<cfexit method="exittag">
