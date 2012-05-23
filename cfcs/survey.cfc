<!---
	Name:			survey.cfc
	Created:	
	Last Updated:	April 10, 2006
	History:		duplicateSurvey, fix question creation (rkc 3/29/05)
					support itemidfk (rkc 10/8/05)
					caching updates (rkc 2/11/06)
					tableprefix support (rkc 3/11/06)
					tableprefix fix (rkc 3/22/06)
					yet ANOTHER fix (rkc 3/24/06)
					support for clearing results (rkc 3/30/06)
					fix issue that occurs when you delete questions w/o fixing ranks (4/10/06)
--->

<cfcomponent displayName="Survey" hint="Handles all survey interactions." output="false">

	<cfset variables.utils = createObject("component","utils")>

	<cffunction name="init" access="public" returnType="survey" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" >
		
		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.dbtype = arguments.settings.dbtype>
		<cfset variables.tableprefix = arguments.settings.tableprefix>

		<!--- This Line makes the settings available throughout the component life --->
		<cfset variables.settings = arguments.settings />
				
		<cfset variables.answerCache = structNew()>
		<cfset variables.itemCache = structNew()>
		<cfset variables.questionCache = structNew()>
		
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addEmailList" access="public" returnType="void" output="false"
				hint="Adds to a survey's email restriction list.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey.">
		<cfargument name="emails" type="array" required="true" hint="The emails to add.">
		<cfset var x = "">
	
		<cfloop index="x" from="1" to="#arrayLen(emails)#">
			<cfquery datasource="#variables.dsn#">
				insert into #variables.tableprefix#survey_emailaddresses(surveyidfk,emailaddress)
				values(<cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#emails[x]#" cfsqltype="CF_SQL_VARCHAR" maxlength="320">)
			</cfquery>
		</cfloop>

	</cffunction>
	
	<cffunction name="addSurvey" access="public" returnType="uuid" output="false"
				hint="Adds a new survey.">
		<cfargument name="name" type="string" required="true" hint="Survey name.">
		<cfargument name="description" type="string" required="true" hint="Survey description.">
		<cfargument name="active" type="boolean" required="true" hint="Determines if the survey is active or not.">
		<cfargument name="dateBegin" type="date" required="false" hint="Time when survey begins.">
		<cfargument name="dateEnd" type="date" required="false" hint="Time when survey ends.">
		<cfargument name="resultMailto" type="string" required="false" hint="Email address to send results to.">
		<cfargument name="surveyPassword" type="string" required="false" hint="Survey password necessary for access.">
		<cfargument name="thankYouMsg" type="string" required="false" hint="Survey thank you message.">
		<cfargument name="allowembed" type="boolean" required="false" hint="Allow the survey to be embedded.">
		<cfargument name="showinpubliclist" type="string" required="false" hint="Survey shows up on home page.">
		<cfargument name="templateidfk" type="any" required="false" hint="Template.">
		<cfargument name="useridfk" type="any" required="false" hint="Template.">
		<cfargument name="questionsperpage" type="numeric" required="false" hint="How many questions to show per page.">

		<cfset var newID = createUUID()>
		
		<cfif not validData(arguments)>
			<cfset variables.utils.throw("SurveyCFC","Survey data is not valid.")>
		</cfif>

		<cfquery datasource="#variables.dsn#">
			insert into #variables.tableprefix#surveys(id,name,description,active,datebegin,dateend,resultmailto,surveypassword,
					thankyoumsg,allowembed,showinpubliclist,templateidfk,useridfk,questionsperpage)
			values(
				<cfqueryparam value="#newID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
				<cfqueryparam value="#arguments.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				<cfqueryparam value="#variables.utils.getQueryParamValue(variables.settings.dbtype,"CF_SQL_BIT", arguments.active)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">,				
				<cfif isDefined("attributes.dateBegin")>
					<cfqueryparam value="#arguments.dateBegin#" cfsqltype="CF_SQL_TIMESTAMP">,
				<cfelse>
					null,
				</cfif>
				<cfif isDefined("attributes.dateBegin")>
					<cfqueryparam value="#arguments.dateEnd#" cfsqltype="CF_SQL_TIMESTAMP">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam value="#arguments.resultMailTo#" cfsqltype="CF_SQL_VARCHAR" maxlength="320">,
				<cfqueryparam value="#arguments.surveyPassword#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
				<cfqueryparam value="#arguments.thankYouMsg#" cfsqltype="CF_SQL_LONGVARCHAR">,
				<cfqueryparam value="#variables.utils.getQueryParamValue(variables.settings.dbtype,"CF_SQL_BIT", arguments.allowembed)#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#variables.utils.getQueryParamValue(variables.settings.dbtype,"CF_SQL_BIT", arguments.showinpubliclist)#" cfsqltype="cf_sql_bit">,
				<cfif len(arguments.templateidfk)>
					<cfqueryparam value="#arguments.templateidfk#" cfsqltype="cf_sql_varchar" maxlength="35">,
				<cfelse>
					<cfqueryparam value="#arguments.templateidfk#" cfsqltype="cf_sql_varchar" null="true">,
				</cfif>				
				<cfqueryparam value="#arguments.useridfk#" cfsqltype="cf_sql_varchar" maxlength="35">,
				<cfif structKeyExists(arguments,"questionsperpage")>	
					<cfqueryparam value="#arguments.questionsperpage#" cfsqltype="cf_sql_integer">
				<cfelse>
					<cfqueryparam null="true">
				</cfif>
				)
		</cfquery>
	
		<cfreturn newID>		
	</cffunction>

	<cffunction name="clearResults" access="public" returnType="void" output="false"
				hint="Removes all results from a survey.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey.">
		<cfset var questions = "">
		<cfset var questionlist = "">
		
		<!--- first get questionidfk, this lets us empty results --->
		<cfquery name="questions" datasource="#variables.dsn#">
		select	id
		from	#variables.tableprefix#questions
		where	surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		<cfset questionlist = valueList(questions.id)>
		
		<cfif len(questionlist)>
		
			<cfquery datasource="#variables.dsn#">
			delete from #variables.tableprefix#results
			where		questionidfk in (<cfqueryparam cfsqltype="cf_sql_varchar" maxlength="35" value="#questionlist#" list="true">)	
			</cfquery>
	
			<cfquery datasource="#variables.dsn#">
			delete from #variables.tableprefix#survey_results
			where		surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfquery>

		</cfif>
				
	</cffunction>			

	<cffunction name="completeSurvey" access="public" returnType="void" output="false"
				hint="Simply marks the survey complete.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey.">
		<cfargument name="ownerid" type="string" required="true" hint="The owner id. Either an email address or a simple UUID.">
		<cfset var survey = getSurvey(arguments.id)>
		<cfset var question = "">
		<cfset var questions = "">
		
		<cfif not surveyCompletedBy(arguments.id, arguments.ownerid)>
		
			<!--- Nuke the question cache --->
			<!--- A bit overkill, but it works. questionCache is a cache of results, so this is necessary. --->
			<cfset variables.questionCache = structNew()>
			
			<cfquery datasource="#variables.dsn#">
				insert into #variables.tableprefix#survey_results(surveyidfk,ownerid,completed)
				values(
				<cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#arguments.ownerid#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				<cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP" >
				)
			</cfquery>
			
			<!--- Do we need to mail? --->
			<cfif len(survey.resultMailTo)>
				<cfset question = createObject("component","question").init(variables.settings)>
				<cfset questions = 	question.getQuestions(arguments.id)>

		<cfmail to="#survey.resultMailTo#" from="#variables.settings.fromAddress#" subject="Survey Completion: #survey.name#">
The survey, #survey.name#, was just completed. 
The survey was completed at #dateFormat(now(),"m/dd/yy")# at #timeFormat(now(),"h:mm tt")#
Owner Key: #arguments.ownerid#
-------------------------------------------------
<cfloop query="questions">
Q#currentRow#) #questions.question#
A) #getAnswerResult(questions.id,arguments.ownerid)#
</cfloop>				
				</cfmail>
			</cfif>
		</cfif>
				
	</cffunction>

	<cffunction name="deleteSurvey" access="public" returnType="void" output="false"
				hint="Deletes a survey. Also does cleanup on results/questions/answers.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey to delete.">
		<cfargument name="useridfk" type="uuid" required="false">
		<cfset var question = createObject("component","question").init(variables.settings)>
		<cfset var questions = 	question.getQuestions(arguments.id)>
		<cfset var s = "">
		
		<!--- Will securely get the survey first --->
		<cfif not structKeyExists(arguments, "useridfk")>
			<cfset s = getSurvey(arguments.id)>
		<cfelse>
			<cfset s = getSurvey(arguments.id, arguments.useridfk)>
		</cfif>
		
		<cfloop query="questions">
			<cfset question.deleteQuestion(questions.id)>
		</cfloop>
		
		<!--- remove EL --->
		<cfset resetEmailList(arguments.id)>
		
		<!--- remove core results --->
		<cfquery datasource="#variables.dsn#">
		delete	from #variables.tableprefix#survey_results
		where	surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#surveys
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
									
	</cffunction>

	<cffunction name="duplicateSurvey" access="public" returnType="void" output="false"
				hint="Duplicates a survey.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey to duplicate.">
		<cfargument name="useridfk" type="uuid" required="false">

		<cfset var s = "">
		<cfset var question = createObject("component","question").init(variables.dsn, variables.dbtype, variables.tableprefix)>
		<cfset var questions = 	question.getQuestions(arguments.id)>
		<cfset var el = getEmailList(arguments.id)>
		<cfset var elA = listToArray(valueList(el.emailAddress))>
		<cfset var newID = "">
		<cfset var args = structNew()>
	
		<!--- Will securely get the survey first --->
		<cfif not structKeyExists(arguments, "useridfk")>
			<cfset s = getSurvey(arguments.id)>
		<cfelse>
			<cfset s = getSurvey(arguments.id, arguments.useridfk)>
		</cfif>
	
		<cfset args.name = "Copy of " & s.name>
		<cfset args.description = s.description>
		<cfset args.active = s.active>
		<cfif isDate(s.dateBegin)>
			<cfset args.dateBegin = s.dateBegin>
		</cfif>
		<cfif isDate(s.dateEnd)>
			<cfset args.dateEnd = s.dateEnd>
		</cfif>
		<cfset args.resultMailTo = s.resultMailTo>
		<cfset args.surveyPassword = s.surveyPassword>
		<cfset args.thankYouMsg = s.thankYouMsg>
		<cfset args.allowembed = s.allowembed>
		<cfset args.showinpubliclist = s.showinpubliclist>
		<cfset args.templateidfk = s.templateidfk>
		<cfset args.useridfk = s.useridfk>
						
		<cfset newid = addSurvey(argumentCollection=args)>

		<cfloop query="questions">
			<cfset question.duplicateQuestion(questions.id,newid)>
		</cfloop>
		
		<cfset addEmailList(newid, elA)>

	</cffunction>

	<cffunction name="getAnswerResult" returnType="string" output="false" hint="Gets the answer as a string.">
		<cfargument name="questionidfk" type="UUID" required="true">
		<cfargument name="owneridfk" type="string" required="true">
		<cfset var getAnswers = "">
		<cfset var getAnswer = "">
		<cfset var result = "">
		<cfset var getItem = "">
		<cfset var ptr = "">
		
		<!--- Do we have the question cache? --->
		<cfif not structKeyExists(variables.questionCache, arguments.questionidfk)>
			<cfquery name="getAnswers" datasource="#variables.dsn#">
				select	answeridfk, truefalse, textbox, textboxmulti, other, itemidfk, owneridfk
				from	#variables.tableprefix#results
				where	questionidfk = <cfqueryparam value="#arguments.questionidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			</cfquery>
			<cfset variables.questionCache[arguments.questionidfk] = getAnswers>
		</cfif>
		<cfset ptr = variables.questionCache[arguments.questionidfk]>
		
		<cfquery name="getAnswers" dbtype="query">
			select	answeridfk, truefalse, textbox, textboxmulti, other, itemidfk
			from	ptr
			where	owneridfk = <cfqueryparam value="#arguments.owneridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
		</cfquery>
					
<!---			
		<!--- first get all the owner's answers to a question --->
		<cfquery name="getAnswers" datasource="#variables.dsn#" blockfactor=4>
			select	answeridfk, truefalse, textbox, textboxmulti, other, itemidfk
			from	results
			where	questionidfk = <cfqueryparam value="#arguments.questionidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and		owneridfk = <cfqueryparam value="#arguments.owneridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
		</cfquery>
--->		
		<cfloop query="getAnswers">
			<cfif answeridfk is not "">
				<cfif not structKeyExists(variables.answerCache, answeridfk)>
					<cfquery name="getAnswer" datasource="#variables.dsn#">
						select	answer
						from	#variables.tableprefix#answers
						where	questionidfk = <cfqueryparam value="#arguments.questionidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
						and		id = <cfqueryparam value="#answeridfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
					</cfquery>
					<cfset variables.answerCache[answeridfk] = getAnswer.answer>
				</cfif>
				<cfif itemidfk is not "">
					<cfif not structKeyExists(variables.itemCache, itemidfk)>
						<cfquery name="getItem" datasource="#variables.dsn#">
							select	answer
							from	#variables.tableprefix#answers
							where	questionidfk = <cfqueryparam value="#arguments.questionidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
							and		id = <cfqueryparam value="#itemidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
						</cfquery>
						<cfset variables.itemCache[itemidfk] = getItem.answer>
					</cfif>
					<cfset result = listAppend(result, variables.itemCache[itemidfk] & ": " & variables.answerCache[answeridfk])>
				<cfelse>
					<cfset result = listAppend(result, variables.answerCache[answeridfk])>
				</cfif>
			
			<cfelseif other is not "">
				<cfset result = listAppend(result, other)>
			<cfelseif textbox is not "">
				<cfset result = listAppend(result, textbox)>
			<cfelseif textboxmulti is not "">
				<cfset result = listAppend(result, textboxmulti)>
			<cfelse>
				<cfset result = listAppend(result, yesNoFormat(truefalse))>
			</cfif>
		</cfloop>

		<cfreturn result>
	</cffunction>
	
	<cffunction name="getEmailList" access="public" returnType="query" output="false"
				hint="Returns a survey's email restriction list (if one exists).">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey to retrieve.">
		<cfset var qGetSurveyEmails = "">
	
		<cfquery name="qGetSurveyEmails" datasource="#variables.dsn#">
			select 	emailaddress
			from	#variables.tableprefix#survey_emailaddresses
			where	surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfreturn qGetSurveyEmails>
	</cffunction>

	<cffunction name="getStats" access="public" returnType="struct" output="false"
				hint="Returns general stats for a survey.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey to retrieve.">
		<cfargument name="earliestdate" type="string" required="false">
		<cfargument name="latestdate" type="string" required="false">
		
		<cfset var stats = "">
		<cfset var s = "">
		
		<cfquery name="s" datasource="#variables.dsn#">
			select 	count(surveyidfk) as totalresults, min(completed) as firstResult,
					max(completed) as lastResult
			from	#variables.tableprefix#survey_results
			where	surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			<cfif structKeyExists(arguments, "earliestdate") and isDate(arguments.earliestdate)>
			and		completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.earliestdate#">
			</cfif>
			<cfif structKeyExists(arguments, "latestdate") and isDate(arguments.latestdate)>
			and		completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.latestdate#">
			</cfif>
		</cfquery>
		
		<cfif s.recordCount>
			<cfset stats = variables.utils.queryToStruct(s)>
		<cfelse>
			<cfset stats.totalresults = 0>
			<cfset stats.firstresult = "">
			<cfset stats.lastresult = "">
		</cfif>
		
		<cfreturn stats>
	</cffunction>
	
	
	<cffunction name="getSurvey" access="public" returnType="query" output="false"
				hint="Returns a survey.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey to retrieve.">
		<cfargument name="useridfk" type="uuid" required="false">	
		<cfset var qGetSurvey = "">
		<cfset var el = "">
		
		<cfquery name="qGetSurvey" datasource="#variables.dsn#">
			select 	s.id, s.name, s.description, s.active, s.datebegin, s.dateend, s.resultmailto, s.surveypassword, s.thankyoumsg,
					s.useridfk, s.templateidfk, s.allowembed, s.showinpubliclist, u.username, s.questionsperpage
			from	#variables.tableprefix#surveys s, #variables.tableprefix#users u
			where	s.id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and		s.useridfk = u.id
			<cfif structKeyExists(arguments, "useridfk")>
			and		s.useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.useridfk#" maxlength="35">
			</cfif>
		</cfquery>
			
		<cfif qGetSurvey.recordCount>
			<cfset queryAddColumn(qGetSurvey,"emailList",arrayNew(1))>
			<cfset el = getEmailList(arguments.id)>
			<cfset qGetSurvey.emailList[1] = valueList(el.emailaddress)>
			<cfreturn qGetSurvey>
		<cfelse>		
			<cfset variables.utils.throw("SurveyCFC","Invalid Survey requested.")>
		</cfif>
										
	</cffunction>

	<cffunction name="getSurveys" access="public" returnType="query" output="false"
				hint="Returns all the surveys.">
		<cfargument name="bActiveOnly" type="boolean" required="false" default="false" hint="Restrict to active surveys only. Also does the date restriction.">
		<cfargument name="publiclist" type="boolean" required="false" hint="Restrict to surveys that have 'showinpubliclist=true' or null.">
		
		<cfargument name="useridfk" type="uuid" required="false">
		<cfset var qGetSurveys = "">
		<cfset var stats = "">
				
		<cfquery name="qGetSurveys" datasource="#variables.dsn#">
			select	s.id, s.name, s.description, s.active, s.datebegin, s.dateend, 
					s.resultmailto, s.surveypassword, s.thankyoumsg, s.allowembed,
					s.showinpubliclist, s.templateidfk, s.useridfk, u.username, s.questionsperpage
			from	#variables.tableprefix#surveys s, #variables.tableprefix#users u
			where	s.useridfk = u.id
			<cfif arguments.bActiveOnly>
			and	s.active = <cfqueryparam value="#variables.utils.getQueryParamValue(variables.settings.dbtype,"CF_SQL_BIT", 1)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">				
			and		(s.datebegin is null or s.datebegin < <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">)
			and		(s.dateend is null or s.dateend > <cfqueryparam value="#now()#" cfsqltype="CF_SQL_TIMESTAMP">)
			</cfif>
			<cfif structKeyExists(arguments,"useridfk")>
			and		s.useridfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.useridfk#" maxlength="35">
			</cfif>
			<cfif structKeyExists(arguments,"publiclist")>
			and	(s.showinpubliclist is null or s.showinpubliclist = <cfqueryparam value="#variables.utils.getQueryParamValue(variables.settings.dbtype,"CF_SQL_BIT", 1)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">)
			</cfif>
		</cfquery>

		<!--- embed stats --->
		<cfset queryAddColumn(qGetSurveys, "totalresults", "cf_sql_integer", arrayNew(1))>
		<cfset queryAddColumn(qGetSurveys, "firstresult", "cf_sql_timestamp", arrayNew(1))>
		<cfset queryAddColumn(qGetSurveys, "lastresult", "cf_sql_timestamp", arrayNew(1))>
		
		<cfloop query="qGetSurveys">
			<cfset stats = getStats(id)>
			<cfset querySetCell(qGetSurveys, "totalresults", stats.totalresults, currentRow)>
			<cfset querySetCell(qGetSurveys, "firstresult", stats.firstresult, currentRow)>
			<cfset querySetCell(qGetSurveys, "lastresult", stats.lastresult, currentRow)>
		</cfloop>	
	
		<cfreturn qGetSurveys>
			
	</cffunction>

	<cffunction name="getTopRank" access="public" returnType="numeric" output="false"
				hint="Gets the highest rank of the questions.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey.">
		<cfset var qGetTop = "">
		<cfset var top = 0>
		
		<cfquery name="qGetTop" datasource="#variables.dsn#">
			select	max(rank) as highest
			from 	#variables.tableprefix#questions
			where	surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<cfif qGetTop.recordCount>
			<cfset top = val(qGetTop.highest)>
		</cfif>

		<cfreturn top>
		<!---
		So for some reason, I had switched from doing max+1 to this. I don't know why. Reverting back. 
		<cfset var qGetTop = "">
		<cfset var top = 0>
		
		<cfquery name="qGetTop" datasource="#variables.dsn#">
			select	count(rank) as highest
			from 	#variables.tableprefix#questions
			where	surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<cfif qGetTop.recordCount>
			<cfset top = val(qGetTop.highest)>
		</cfif>

		<cfreturn top>
		--->
	</cffunction>
				
	<cffunction name="resetEmailList" access="public" returnType="void" output="false"
				hint="Resets a survey's email restriction list.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey.">
	
		<cfquery datasource="#variables.dsn#">
			delete from #variables.tableprefix#survey_emailaddresses
			where surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

	</cffunction>

	<cffunction name="surveyCompletedBy" access="public" returnType="boolean" output="false"
				hint="Returns true if a owner has taken a survey.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the survey.">
		<cfargument name="ownerid" type="string" required="true" hint="The owner.">
		<cfset var qResults = "">
		
		<cfquery name="qResults" datasource="#variables.dsn#">
			select	surveyidfk
			from	#variables.tableprefix#survey_results
			where	surveyidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and		ownerid = <cfqueryparam value="#arguments.ownerid#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">
		</cfquery>
		
		<cfreturn qResults.recordCount gt 0>
			
	</cffunction>
	
	<cffunction name="updateSurvey" access="public" returnType="void" output="false"
				hint="Updates a survey in the db.">
		<cfargument name="id" type="uuid" required="true" hint="Survey ID.">
		<cfargument name="name" type="string" required="true" hint="Survey name.">
		<cfargument name="description" type="string" required="true" hint="Survey description.">
		<cfargument name="active" type="boolean" required="true" hint="Determines if the survey is active or not.">
		<cfargument name="dateBegin" type="date" required="false" hint="Time when survey begins.">
		<cfargument name="dateEnd" type="date" required="false" hint="Time when survey ends.">
		<cfargument name="resultMailto" type="string" required="false" hint="Email address to send results to.">
		<cfargument name="surveyPassword" type="string" required="false" hint="Survey password necessary for access.">
		<cfargument name="thankYouMsg" type="string" required="false" hint="Survey thank you message.">
		<cfargument name="allowembed" type="boolean" required="false" hint="Allow the survey to be embedded.">
		<cfargument name="showinpubliclist" type="string" required="false" hint="Survey shows up on home page.">
		<cfargument name="templateidfk" type="any" required="false" hint="Template.">
		<cfargument name="questionsperpage" type="numeric" required="false" hint="How many questions to show per page.">

		<cfif not validData(arguments)>
			<cfset variables.utils.throw("SurveyCFC","This survey data is not valid.")>
		</cfif>
						
		<cfquery datasource="#variables.dsn#">
			update #variables.tableprefix#surveys
				set
					name = <cfqueryparam value="#arguments.name#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
					description = <cfqueryparam value="#arguments.description#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					active = <cfqueryparam value="#variables.utils.getQueryParamValue(variables.dbtype,"CF_SQL_BIT", arguments.active)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">,
					<cfif isDefined("arguments.dateBegin")>
						datebegin = <cfqueryparam value="#arguments.dateBegin#" cfsqltype="CF_SQL_TIMESTAMP">,
					<cfelse>
						datebegin = null,
					</cfif>
					<cfif isDefined("arguments.dateEnd")>
						dateend = <cfqueryparam value="#arguments.dateEnd#" cfsqltype="CF_SQL_TIMESTAMP">,
					<cfelse>
						dateend = null,
					</cfif>
					resultmailto = <cfqueryparam value="#arguments.resultMailTo#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					surveypassword = <cfqueryparam value="#arguments.surveyPassword#" cfsqltype="CF_SQL_VARCHAR" maxlength="50">,
					thankyoumsg = <cfqueryparam value="#arguments.thankyoumsg#" cfsqltype="CF_SQL_LONGVARCHAR">,
					allowembed = <cfqueryparam value="#variables.utils.getQueryParamValue(variables.dbtype,"CF_SQL_BIT", arguments.allowembed)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">,
					showinpubliclist = <cfqueryparam value="#variables.utils.getQueryParamValue(variables.dbtype,"CF_SQL_BIT", arguments.showinpubliclist)#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">,
					<cfif len(arguments.templateidfk)>
					templateidfk = <cfqueryparam value="#arguments.templateidfk#" cfsqltype="cf_sql_varchar" maxlength="35">,
					<cfelse>
					templateidfk = <cfqueryparam value="#arguments.templateidfk#" cfsqltype="cf_sql_varchar" null="true">,
					</cfif>
					<cfif structKeyExists(arguments, "questionsperpage")>
					questionsperpage = <cfqueryparam value="#arguments.questionsperpage#" cfsqltype="cf_sql_integer">
					<cfelse>
					questionsperpage = <cfqueryparam null=true>
					</cfif>				
				where id = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="validData" access="private" returnType="boolean" output="false"
				hint="Checks a structure to see if it contains valid data for adding/updating a survey.">
		<cfargument name="data" type="struct" required="true" hint="The data to validate.">
		
		<cfif not structKeyExists(arguments.data,"name") or not len(trim(arguments.data.name)) or
			  not structKeyExists(arguments.data,"description") or not len(trim(arguments.data.description))>
			<cfreturn false>
		</cfif>
		
		<!--- if a begin and end date has been specified, end date must be after begin date --->
		<cfif structKeyExists(arguments.data,"beginDate") and structKeyExists(arguments.data,"endDate") and 
			  arguments.data.beginDate is not "" and arguments.data.endDate is not "" and
			  dateCompare(arguments.data.dateBegin,arguments.data.dateEnd,"s") gte 0>
			<cfreturn false>
		</cfif>
		
		<cfreturn true>
				
	</cffunction>
	
</cfcomponent>