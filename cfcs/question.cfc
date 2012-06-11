<!---
	Name         : cfcs/question.cfc
	Author       : Raymond Camden 
	Created      : 
	Last Updated : April 10, 2006
	History      : throw error on add/update if rank already exists
				 : support for tableprefix (3/10/06)
 				 : tableprefix fix (rkc 3/30/06)
				 : Fix for bug that occurs when you delete a question and don't fix rank (rkc 4/10/06)
	Purpose		 : 
--->
<cfcomponent displayName="Question" hint="Handles all question interactions." output="false">

	<cfset variables.utils = createObject("component","utils")>

	<cffunction name="init" access="public" returnType="question" output="false"
				hint="Returns an instance of the CFC initialized with the correct DSN.">
		<cfargument name="settings" type="struct" required="true" >

		<cfset variables.dsn = arguments.settings.dsn>
		<cfset variables.dbtype = arguments.settings.dbtype>
		<cfset variables.tableprefix = arguments.settings.tableprefix>

		<cfset variables.survey = createObject("component","survey").init(arguments.settings)>
		<cfset variables.questiontype = createObject("component","questiontype").init(arguments.settings)>
		
		<cfreturn this>
		
	</cffunction>

	<cffunction name="addAnswers" access="public" returnType="void" output="false"
				hint="Adds a set of answers.">
		<cfargument name="questionidfk" type="uuid" required="true" hint="Related question.">
		<cfargument name="answers" type="array" required="true" hint="Array of answer structs">
		<cfset var x = "">
		
		<cfloop index="x" from="1" to="#arrayLen(arguments.answers)#">
			<cfif structKeyExists(arguments.answers[x],"answer") and
				  structKeyExists(arguments.answers[x],"rank")>
				<cfquery datasource="#variables.dsn#">
					insert into #variables.tableprefix#answers(id, questionidfk, answer, rank)
					values(<cfqueryparam value="#createUUID()#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					<cfqueryparam value="#arguments.questionidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					<cfqueryparam value="#arguments.answers[x].answer#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					<cfqueryparam value="#arguments.answers[x].rank#" cfsqltype="CF_SQL_INTEGER">)
				</cfquery>
			</cfif>
		</cfloop>
		
	</cffunction>
		
	<cffunction name="addQuestion" access="public" returnType="string" output="false"
				hint="Adds a question.">
		<cfargument name="question" type="string" required="true" hint="The Question itself.">
		<cfargument name="rank" type="numeric" required="true" hint="Rank of the question in the survey.">
		<cfargument name="required" type="boolean" required="true" hint="Is the question required?">
		<cfargument name="surveyidfk" type="uuid" required="true" hint="Survey we are adding to.">
		<cfargument name="questionTypeidfk" type="uuid" required="true" hint="Type of question.">
		<cfargument name="answers" type="array" required="false" hint="Array of answer structs">

		<cfset var newID = createUUID()>
		<cfset var check = "">
		
		<!--- first see if this rank exists already --->
		<cfquery name="check" datasource="#variables.dsn#">
		select	id
		from	#variables.tableprefix#questions
		where	rank = <cfqueryparam value="#arguments.rank#" cfsqltype="CF_SQL_INTEGER">
		and		surveyidfk = <cfqueryparam value="#arguments.surveyidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<cfif check.recordCount>
			<cfthrow type="Question" message="A question with this rank exists already.">
		</cfif>
		
		<cfquery datasource="#variables.dsn#">
			insert into #variables.tableprefix#questions(id, question, rank, required, surveyidfk, questiontypeidfk)
			values(
				<cfqueryparam value="#newid#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#arguments.question#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
				<cfqueryparam value="#arguments.rank#" cfsqltype="CF_SQL_INTEGER">,
				<cfqueryparam value="#arguments.required#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">,
				<cfqueryparam value="#arguments.surveyidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
				<cfqueryparam value="#arguments.questionTypeidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				)
		</cfquery>		
		
		<cfif isDefined("arguments.answers") and arrayLen(arguments.answers)>
			<cfset addAnswers(newID,answers)>
		</cfif>
		
		<cfreturn newID>

	</cffunction>

	<cffunction name="setQuestionBranches" access="public" returnType="void" output="false"
				hint="I store question branch logic all at once.">
		<cfargument name="questionid" type="uuid" required="true">
		<cfargument name="data" type="array" required="true">
		<cfset var x = "">
		<cfset var b = "">
		<cfset var rank = 0>

		<cflock name="soundings_survey_question_#arguments.questionid#" type="exclusive" timeout="30">
			<cfquery datasource="#variables.dsn#">
			delete from #variables.tableprefix#questionbranches
			where questionidfk = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.questionid#" maxlength="35">
			</cfquery>

			<cfloop index="x" from="1" to="#arrayLen(data)#">
				<cfset b = data[x]>
				<cfset rank++>
				<cfquery datasource="#variables.dsn#">
				insert into #variables.tableprefix#questionbranches(id, questionidfk, nextquestion, nextquestionvalue, rank)
				values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#createUUID()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.questionid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#b.nextquestion#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#b.nextquestionvalue#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rank#">
				)	
				</cfquery>			
			</cfloop>

		</cflock>

	</cffunction>

	<cffunction name="deleteAnswer" access="public" returnType="void" output="false"
				hint="Deletes an answer.">
		<cfargument name="id" type="uuid" required="true" hint="Answer ID">

		<cfquery datasource="#variables.dsn#">
			delete from #variables.tableprefix#answers
			where id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		<cfquery datasource="#variables.dsn#">
			delete from #variables.tableprefix#results
			where answeridfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>

	<cffunction name="deleteAnswers" access="public" returnType="void" output="false"
				hint="Deletes a set of answers.">
		<cfargument name="questionidfk" type="uuid" required="true" hint="Related question.">

		<cfquery datasource="#variables.dsn#">
			delete from #variables.tableprefix#answers
			where questionidfk = <cfqueryparam value="#arguments.questionidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
	</cffunction>
	
	<cffunction name="deleteQuestion" access="public" returnType="void" output="false"
				hint="Deletes a questions. Also does cleanup on results/answers.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the question to delete.">
		
		<cfset deleteAnswers(arguments.id)>
		
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#questions
			where	id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		<!--- remove from results --->
		<cfquery datasource="#variables.dsn#">
			delete	from #variables.tableprefix#results
			where	questionidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
					
	</cffunction>

	<cffunction name="duplicateQuestion" access="public" returnType="void" output="false"
				hint="Duplicates a question.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the question to duplicate.">
		<cfargument name="surveyidfk" type="uuid" required="true" hint="The UUID of the survey for the question.">
		
		<cfset var q = getQuestion(arguments.id)>
		<cfset var answers = getAnswers(arguments.id)>
		<cfset var aData = arrayNew(1)>
		<cfset var newq = "">
		<cfset var branches = arrayNew(1)>
		
		<cfloop query="answers">
			<cfset aData[arrayLen(aData)+1] = structNew()>
			<cfset aData[arrayLen(aData)].answer = answers.answer>
			<cfset aData[arrayLen(aData)].rank = answers.rank>			
		</cfloop>

		<cfset newq = addQuestion(q.question,q.rank,q.required,arguments.surveyidfk,q.questionTypeIDFK,aData)>

		<cfif q.branches.recordCount>
			<!--- we must convert the query into an array --->
			<cfloop query="q.branches">
				<cfset arrayAppend(branches, {nextquestion=nextquestion, 
											nextquestionvalue=nextquestionvalue, 
											rank=rank})>
				
			</cfloop>
			<cfset setQuestionBranches(newq, branches)>
		</cfif>
		
	</cffunction>
	
	<cffunction name="getAnswers" access="public" returnType="query" output="false"
				hint="Grabs a set of answers for a question.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID for the related question.">
		
		<cfset var qAnswers = "">
		
		<cfquery name="qAnswers" datasource="#variables.dsn#">
			select	id, answer, rank
			from	#variables.tableprefix#answers
			where	questionidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			order by rank asc
		</cfquery>
		
		<cfreturn qAnswers>
		
	</cffunction>

	<cffunction name="getBranches" access="public" returnType="query" output="false"
				hint="Grabs a set of branches for a question.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID for the question.">
		
		<cfset var q = "">
		
		<cfquery name="q" datasource="#variables.dsn#">
			select	id, nextquestion, nextquestionvalue, rank
			from	#variables.tableprefix#questionbranches
			where	questionidfk = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			order by rank asc
		</cfquery>
		
		<cfreturn q>
		
	</cffunction>
	
	<cffunction name="getQuestion" access="public" returnType="struct" output="false"
				hint="Grabs a question.">
		<cfargument name="id" type="uuid" required="true" hint="The UUID of the question to get.">
		<cfset var qQuestion = "">
		<cfset var result = "">
		
		<cfquery name="qQuestion" datasource="#variables.dsn#">
			select	#variables.tableprefix#questions.id, surveyidfk, question, questiontypeidfk, rank, required, 
			#variables.tableprefix#questiontypes.name as questiontype
			from	#variables.tableprefix#questions, #variables.tableprefix#questiontypes
			where	#variables.tableprefix#questions.id = <cfqueryparam value="#arguments.id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and		#variables.tableprefix#questions.questiontypeidfk = #variables.tableprefix#questiontypes.id
		</cfquery>

		<cfset result = variables.utils.queryToStruct(qQuestion)>
		<cfset result.answers = getAnswers(arguments.id)>

		<cfset result.branches = getBranches(arguments.id)>

		<cfreturn result>
											
	</cffunction>

	
	<cffunction name="getQuestions" access="public" returnType="query" output="false"
				hint="Returns all the questions for a survey.">
		<cfargument name="surveyidfk" type="string" required="true" hint="Survey ID">
		<cfargument name="rank" type="numeric" required="false" hint="Returns just a particular rank.">
		<cfset var qGetQuestions = "">
		<cfset var ranklist = "">
		<cfset var getRanks = "">
		
		<!--- So, rank was written to assume that the first question was rank 1. But it's possible a admin
		may make a survey and delete question one. So now I want to change rank from 1 to the 1st rank. --->
		<cfif isDefined("arguments.rank")>
			<cfquery name="getRanks" datasource="#variables.dsn#">
			select	rank
			from	#variables.tableprefix#questions
			where	surveyidfk = <cfqueryparam value="#arguments.surveyidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			order by rank asc
			</cfquery>
			<!--- rewrite rank --->
			<cfset ranklist = valueList(getRanks.rank)>
			<cfif arguments.rank lte listLen(ranklist)>
				<cfset arguments.rank = listGetAt(ranklist, arguments.rank)>
			<cfelse>
				<cfset arguments.rank = listFirst(ranklist)>
			</cfif>
		</cfif>
				
		<cfquery name="qGetQuestions" datasource="#variables.dsn#">
			select	#variables.tableprefix#questions.id, surveyidfk, question, questiontypeidfk, rank, required, 
			#variables.tableprefix#questiontypes.name as questiontype, 
			#variables.tableprefix#questiontypes.handlerroot as handlerroot			
			from	#variables.tableprefix#questions, #variables.tableprefix#questiontypes
			where	surveyidfk = <cfqueryparam value="#arguments.surveyidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
			and		#variables.tableprefix#questions.questiontypeidfk = #variables.tableprefix#questiontypes.id
			<cfif isDefined("arguments.rank")>
			and		#variables.tableprefix#questions.rank = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#arguments.rank#">
			</cfif>
			order by rank asc
		</cfquery>

		<cfif isDefined("arguments.rank")>
			<cfset queryAddColumn(qGetQuestions,"branches",arrayNew(1))>
			<cfset querySetCell(qGetQuestions,"branches",getBranches(qGetQuestions.id),1)>
		</cfif>

		<cfreturn qGetQuestions>
			
	</cffunction>

	<cffunction name="updateAnswers" access="public" returnType="void" output="false"
				hint="Updates a set of answers in the db.">
		<cfargument name="questionidfk" type="uuid" required="true" hint="Question ID.">				
		<cfargument name="answers" type="array" required="true" hint="Array of answer structs">
		<cfset var x = "">
		
		<cfloop index="x" from="1" to="#arrayLen(arguments.answers)#">
			<cfif structKeyExists(arguments.answers[x], "answer") and
				  structKeyExists(arguments.answers[x], "rank") and
				  structKeyExists(arguments.answers[x], "id")>
		  		<cfquery datasource="#variables.dsn#">
				update #variables.tableprefix#answers
				set
					answer = <cfqueryparam value="#arguments.answers[x].answer#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					rank = <cfqueryparam value="#arguments.answers[x].rank#" cfsqltype="CF_SQL_INTEGER">
				where id = <cfqueryparam value="#arguments.answers[x].id#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				</cfquery>
			<cfelseif structKeyExists(arguments.answers[x], "answer") and
				  structKeyExists(arguments.answers[x], "rank")>
				  <!--- this is a new answer --->
				  <cfquery datasource="#variables.dsn#">
				  	insert into #variables.tableprefix#answers(id,questionidfk,answer,rank)
					values(<cfqueryparam value="#createUUID()#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					<cfqueryparam value="#arguments.questionidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					<cfqueryparam value="#arguments.answers[x].answer#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					<cfqueryparam value="#arguments.answers[x].rank#" cfsqltype="CF_SQL_INTEGER">)
				  </cfquery>
			</cfif>		
		</cfloop>
								
	</cffunction>

	<cffunction name="updateQuestion" access="public" returnType="void" output="false"
				hint="Updates a question in the db.">
		<cfargument name="id" type="uuid" required="true" hint="Question ID.">
		<cfargument name="question" type="string" required="true" hint="The Question itself.">
		<cfargument name="rank" type="numeric" required="true" hint="Rank of the question in the survey.">
		<cfargument name="required" type="boolean" required="true" hint="Is the question required?">
		<cfargument name="surveyidfk" type="string" required="true" hint="Survey we are adding to.">
		<cfargument name="questionTypeidfk" type="string" required="true" hint="Type of question.">
		<cfargument name="answers" type="array" required="false" hint="Array of answer structs">
		<cfargument name="nextquestion" type="uuid" required="false" hint="Where to go next.">
		<cfargument name="nextquestionvalue" type="string" required="false" default="" hint="Only go to next question if answer is this.">

		<cfset var check = "">
		<cfif not validData(arguments)>
			<cfset variables.utils.throw("QuestionCFC","This question data is not valid.")>
		</cfif>

		<!--- first see if this rank exists already --->
		<cfquery name="check" datasource="#variables.dsn#">
		select	id
		from	#variables.tableprefix#questions
		where	rank = <cfqueryparam value="#arguments.rank#" cfsqltype="CF_SQL_INTEGER">
		and		id <> <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		and		surveyidfk = <cfqueryparam value="#arguments.surveyidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>
		
		<cfif check.recordCount>
			<cfthrow type="Question" message="Another question with this rank exists already.">
		</cfif>
						
		<cfquery datasource="#variables.dsn#">
			update #variables.tableprefix#questions
				set
					question = <cfqueryparam value="#arguments.question#" cfsqltype="CF_SQL_VARCHAR" maxlength="255">,
					rank = <cfqueryparam value="#arguments.rank#" cfsqltype="CF_SQL_INTEGER">,
					required = <cfqueryparam value="#arguments.required#" cfsqltype="#variables.utils.getQueryParamType(variables.dbtype,"CF_SQL_BIT")#">,
					surveyidfk = <cfqueryparam value="#arguments.surveyidfk#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">,
					questionTypeidfk = <cfqueryparam value="#arguments.questionTypeIDFK#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
				where id = <cfqueryparam value="#arguments.ID#" cfsqltype="CF_SQL_VARCHAR" maxlength="35">
		</cfquery>

		<cfif isDefined("arguments.answers") and arrayLen(arguments.answers)>
			<cfset updateAnswers(arguments.id,answers)>
		</cfif>
		
	</cffunction>
	
	<cffunction name="validData" access="public" returnType="boolean" output="false"
				hint="Checks to see if the question is valid.">
		<cfargument name="data" type="struct" required="true" hint="Data to validate.">
		<cfset var s = "">
		<cfset var qt = "">
		<cfif arguments.data.question is "" or arguments.data.surveyidfk is "" or arguments.data.questionTypeIDFK is "">
			<cfreturn false>
		</cfif>
		
		<cftry>
			<cfset s = variables.survey.getSurvey(arguments.data.surveyidfk)>
			<cfset qt = variables.questiontype.getQuestionType(arguments.data.questionTypeIDFK)>
			<cfcatch>
				<!--- invalid survey or qt, return false --->
				<cfreturn false>
			</cfcatch>
		</cftry>

		<cfreturn true>
		
	</cffunction>

		
</cfcomponent>