<cfsetting enablecfoutputonly=true showdebugoutput=false>
<!---
	Name         : stats.cfm
	Author       : Raymond Camden 
	Created      : September 6, 2004
	Last Updated : December 12, 2007
	History      : For some dumb reason, Excel output was commented out (rkc 8/26/05)
				   Support matrix (rkc 10/8/05)
				   Forgot some debug output (rkc 10/28/05)
				   Fixed ordering in matrix questions (rkc 2/11/06)
				   Fixed CFMX6 support (rkc 3/22/06)
				   tableprefix fix (rkc 3/30/06)
				   fix for excel link, and add pdf link (rkc 12/12/07)
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<!--- Is this a mx7 box? --->
<cfif structKeyExists(getFunctionList(), "GetLocaleDisplayName")>
	<cfset cfmx7 = true>
<cfelse>
	<cfset cfmx7 = false>
</cfif>

<cfif isDefined("url.surveyidfk")>
	<cfset form.surveyidfk = url.surveyidfk>
</cfif>
<cfparam name="form.surveyidfk" default="">

<cfif isDefined("url.format")>
	<cfset form.format = url.format>
</cfif>
	
<cfif form.surveyidfk is "">

	<tags:layout templatename="admin" title="Survey Stats and Reports" loadspry="true">

	<!--- get surveys --->
	<cfif not session.user.isAdmin>
		<cfset surveys = application.survey.getSurveys(useridfk=session.user.id)>
	<cfelse>
		<cfset surveys = application.survey.getSurveys()>
	</cfif>


	<cfif surveys.recordCount gte 1>

		<cfoutput>
		<script>
		var dsQuestions = new Spry.Data.XMLDataSet("", "/questions/question");
			
		function getQuestions() {
			var selq = Spry.$("selquestions");
			if(!selq.checked) {
				clearQuestions();
				return;
			}
			surveydd = Spry.$("surveyidfk");
			survey = surveydd.options[surveydd.selectedIndex].value;
			dsQuestions.setURL("xml.questions.cfm?survey="+survey);
			dsQuestions.loadData();
		}
		
		function clearQuestions() {
			var q = Spry.$("questionlist");
			q.innerHTML = '';
		}
		</script>
		<p>
		<form action="#cgi.script_name#" method="post" name="surveys">
		<table>
			<tr>
				<td>Select a Survey</td>
				<td>
				<select name="surveyidfk" id="surveyidfk">
				<cfloop query="surveys">
					<option value="#id#" <cfif id is form.surveyidfk>selected</cfif>>#name#</option>
				</cfloop>
				</select>
				</td>
			</tr>
			<tr>
				<td>Format</td>
				<td>
				<select name="format">
				<option value="html">HTML</option>
				<option value="excel">Excel</option>
				<option value="pdf">PDF</option>
				</select>
				</td>
			</tr>
			<tr>
				<td>Earliest Date:</td>
				<td><input type="text" name="earliestdate" /></td>
			</tr>
			<tr>
				<td>Latest Date:</td>
				<td><input type="text" name="latestdate" /></td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td><input type="submit" value="Generate"></td>
			</tr>
		</table>
		<input type="checkbox" id="selquestions" value="selectquestions" onclick="getQuestions()">Select Questions:
		<div id="questionlist" spry:region="dsQuestions">
			<ul>
			<div spry:repeat="dsQuestions">
				<input type="checkbox" name="questionfilter" value="{ID}"><span spry:content="{QUESTION}"></span><br />
			</div>
			</ul>
		</div>
		</form>
		</p>
		</cfoutput>

	<cfelse>
		
		<cfoutput>
		<p>
		You do not have any surveys available to report on.
		</p>
		</cfoutput>
	
	</cfif>

	</tags:layout>

<!--- begin report handling --->	
<cfelse>

	<!--- get survey security check --->
	<cfif not session.user.isAdmin>
		<cfset survey = application.survey.getSurvey(form.surveyidfk, session.user.id)>
	</cfif>
	
	<!--- handle questions and possible filter --->
	<cfset questions = application.question.getQuestions(form.surveyidfk)>
	
	<cfparam name="url.earliestdate" default="">
	<cfparam name="url.latestdate" default="">
	<cfparam name="form.earliestdate" default="#url.earliestdate#">
	<cfparam name="form.latestdate" default="#url.latestdate#">

	<cfif not isDate(form.earliestdate)>
		<cfset form.earliestdate = "">
	</cfif>
	<cfif not isDate(form.latestdate)>
		<cfset form.latestdate = "">
	</cfif>
	
	<cfif structKeyExists(form, "questionfilter") and len(form.questionfilter)>
		<cfquery name="questions" dbtype="query">
		select	*
		from	questions
		where	id in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.questionfilter#" list="true">)
		</cfquery>
	</cfif>
		

	<!--- html --->
	<cfif form.format is "html">
	
		<!--- Begin Stat Display --->
		<cfset survey = application.survey.getSurvey(form.surveyidfk)>
		<cfset stats = application.survey.getStats(form.surveyidfk,form.earliestdate,form.latestdate)>

		<cfset title = "Stats for #survey.name#">
		<cfif isDate(form.earliestdate) or isDate(form.latestdate)>
			<cfset title = title & " (Restricted to ">
			<cfif isDate(form.earliestdate)>
				<cfset title = title & "results after #dateFormat(form.earliestdate)# ">
			</cfif>
			<cfif isDate(form.earliestdate) and isDate(form.latestdate)>
				<cfset title = title & " and ">
			</cfif>
			<cfif isDate(form.latestdate)>
				<cfset title = title & "results before #dateFormat(form.latestdate)#">
			</cfif>			
			<cfset title = title & ")">
		</cfif>
		
		<tags:layout templatename="admin" title="#title#">
		
		<cfoutput>
		
		<script>
		function popup(loc) {
			theWin = window.open(loc,'theWin','width=600,height=600,scrollbars=1');
			theWin.focus();
		}
		</script>
		
		<p>
		<table cellspacing=0 cellpadding=5 class="adminListTable" width="600">
			<tr class="adminListHeader">
				<td colspan="2">General Stats</td>
			</tr>
			<tr>
				<td><b>Total Number of Survey Results</b></td>
				<td>#stats.totalresults#</td>
			</tr>
			<tr>
				<td><b>First Result</b></td>
				<td>#dateFormat(stats.firstresult,"m/dd/yy")# #timeFormat(stats.firstresult,"h:mm tt")#&nbsp;</td>
			</tr>
			<tr>
				<td><b>Last Result</b></td>
				<td>#dateFormat(stats.lastresult,"m/dd/yy")# #timeFormat(stats.lastresult,"h:mm tt")#&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2">
				<a href="#cgi.script_name#?surveyidfk=#form.surveyidfk#&earliestdate=#form.earliestdate#&latestdate=#form.latestdate#&format=excel">Excel Report</a> / <a href="#cgi.script_name#?surveyidfk=#form.surveyidfk#&earliestdate=#form.earliestdate#&latestdate=#form.latestdate#&&format=pdf">PDF Report</a>
				</td>
			</tr> 
		</table>
		</p>
		</cfoutput>
		
		<cfset colorList = "##E48701,##A5BC4E,##1B95D9,##CACA9E,##6693B0,##F05E27,##86D1E4,##E4F9A0,##FFD512,##75B000,##0662B0">
		<cfset currentColorIndex = 1>

		<cfloop query="questions">
			
			<!--- fire stats handler for qt --->
			<cfmodule template="../handlers/#handlerRoot#/stats.cfm" 
				surveyidfk="#form.surveyidfk#"
				questionidfk="#id#"
				r_data="data" 
				earliestDate="#form.earliestDate#"
				latestDate="#form.latestDate#"
			 />
	
			<cfif isStruct(data) and questiontype is not "matrix">
				<!--- get max data --->
				<cfset max = 1>
				<cfloop item="key" collection="#data#">
					<cfif data[key] gt max>
						<cfset max = data[key]>
					</cfif>
				</cfloop>
			</cfif>

			<cfset currentColor = listGetAt(colorList, currentColorIndex)>
			<cfoutput>
			<p>
			<table cellspacing=0 cellpadding=5 class="adminListTable" width="600">
				<tr class="adminListHeader">
					<td colspan="2">
					#currentRow#. #question# (#questiontype#)
					<cfif not required>
						<cfset total = "">
						<cfswitch expression="#questiontype#">
							<cfcase value="Multiple Choice (Single Selection),Multiple Choice (Multiple Selection)">
								<cfset total = 0>
								<cfloop item="k" collection="#data#">
									<cfset total = total + data[k]>
								</cfloop>
							</cfcase>
							<cfcase value="Matrix">
								<cfset total = data.realTotal>
							</cfcase>
							<cfcase value="Text Box (Single),Text Box (Multi)">
								<cfset total = data.recordCount>
							</cfcase>
							<cfcase value="True/False,Yes/No">
								<cfset total = data.true + data.false>
							</cfcase>
						</cfswitch>

						<cfif isNumeric(total) and stats.totalresults gt 0>
							<cfset perc = total/stats.totalresults*100>
							(Response Rate: #numberFormat(perc,0.0)#%)
						</cfif>
					</cfif>
					</td>
				</tr>
				<tr>
					<td>
					<cfswitch expression="#questiontype#">
					
						<cfcase value="true/false,yes/no">
							<cfif questiontype is "true/false">
								<cfset t = "True">
								<cfset f = "False">
							<cfelse>
								<cfset t = "Yes">
								<cfset f = "No">
							</cfif>
							<cfif cfmx7>
								<cfinclude template="stats_pie.cfm">
							<cfelse>
								<cfchart format="flash" chartWidth="575" chartHeight="575"
										 rotated="yes" gridLines="#max+1#" show3d="true">
									<cfchartseries type="pie" paintStyle="raise" seriesColor="#currentColor#" dataLabelStyle="pattern">
										<cfchartdata item="#f#" value="#data.false#">						
										<cfchartdata item="#t#" value="#data.true#">
									</cfchartseries> 
								</cfchart>
							</cfif>
							<cfset currentColorIndex = currentColorIndex + 1>
						</cfcase>
	
						<cfcase value="multiple choice (single selection),Multiple Choice (Multi Selection) with Other,Multiple Choice (Single Selection) with Other,Multiple Choice (Multi Selection)">
							<cfset answers = application.question.getAnswers(id)>
	
							<cfif cfmx7>
							
								<cfinclude template="stats_mc.cfm">
	
							<cfelse>						
	
								<cfchart format="flash" chartWidth="575" chartHeight="575"
										 rotated="yes" gridlines="#max+1#" scaleFrom="0">
									<cfchartseries type="bar" paintStyle="raise" seriesColor="#currentColor#">
										<cfif structKeyExists(data,"other")>
											<cfchartdata item="Other" value="#data.other#">
										</cfif>
										<cfloop query="answers">
											<cfchartdata item="#answer#" value="#data[id]#">
										</cfloop>
									</cfchartseries> 
									<cfset currentColorIndex = currentColorIndex + 1>
								</cfchart>
							
							</cfif>
							
							<cfif findNoCase("other",questiontype)>
								<cfoutput>
								<p>
								<a href="javascript:popup('otherviewer.cfm?questionidfk=#id#&earliestdate=#form.earliestdate#&latestdate=#form.latestdate#')">View Other Results</a>
								</p>
								</cfoutput>
							</cfif>
							
						</cfcase>
						
						<cfcase value="text box (single),text box (multi)">
							<cfoutput>
							<a href="javascript:popup('textviewer.cfm?questionidfk=#id#&earliestdate=#form.earliestdate#&latestdate=#form.latestdate#')">View Answers</a>
							</cfoutput>
						</cfcase>
						
						<cfcase value="matrix">
							
							<cfset sortedAnswers = data.sortedAnswers>
							<cfset structDelete(data, "sortedAnswers")>
							<cfset sortedItems = data.sortedItems>
							<cfset structDelete(data, "sortedItems")>
							<cfset structDelete(data, "realTotal")>
							<!---
							This was intentionally disabled Apr 11, 2012 due to a bug with the display.
							I didn't have time to figure it out, so just "and 0"ing it was enough.
							--->
							<cfif cfmx7 and 0>
							
								<cfinclude template="stats_matrix.cfm">
								
							<cfelse>
	
								<cfchart format="flash" chartWidth="575" chartHeight="575" rotated="yes" show3d=true showLegend=true>
								<cfloop list="#sortedItems#" index="item">
									<cfset label = data[item].label>							
										<cfchartseries type="bar" paintStyle="raise" seriesColor="#currentColor#" seriesLabel="#label#">
											<cfloop list="#sortedAnswers#" index="v">
												<cfif v is not "label">
													<cfchartdata item="#data[item][v].label#" value="#data[item][v].count#">
												</cfif>
											</cfloop>
										</cfchartseries> 
										<cfset currentColorIndex = currentColorIndex + 1>
										<cfif currentColorIndex gt listLen(colorList)>
											<cfset currentColorIndex = 1>
										</cfif>
										<cfset currentColor = listGetAt(colorList, currentColorIndex)>
								</cfloop>
								</cfchart>
							
							</cfif>
							
							<cfset currentColorIndex = currentColorIndex + 1>
						</cfcase>					
	
						<cfdefaultcase>
							<!--- This should not happen --->
						</cfdefaultcase>
						
					</cfswitch>
					
					<cfif currentColorIndex gt listLen(colorList)>
						<cfset currentColorIndex = 1>
					</cfif>
	
					</td>
				</tr>
			</table>
			</p>
			</cfoutput>
		</cfloop>
		
		</tags:layout>
	
	<!--- handles both excel and pdf --->
	<cfelse>
	
		<!--- 
			Excel Generation
			It's like the Pepsi Generation - but not as cool. And not in a can.
			
			So, I'm going to use queries here. Normally I'd do everything via the CFC. 
			This is so special though I think it may make more sense here.
			Then again, I may just be lazy.
			But does anyone actually even look at the source code?
			I doubt it.
			Either way.
			Just know I really wanted to put this in the CFC.
			I feel really bad about it.
			But I'll live.
		--->
				
		<!--- step one. get all users who responded --->
		<cfquery name="getSurveyTakers" datasource="#application.settings.dsn#">
			select	ownerid, completed
			from	#application.settings.tableprefix#survey_results
			where	surveyidfk = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" maxlength="35" value="#form.surveyidfk#">
			<cfif isDate(form.earliestdate)>
			and		completed >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.earliestdate#">
			</cfif>
			<cfif isDate(form.latestdate)>
			and		completed <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.latestdate#">
			</cfif>

		</cfquery>
		
		<!--- output headers for excel --->
		<cfsavecontent variable="report">
		<cfoutput><table border="1" width="100%"></cfoutput>
		
		<cfoutput><tr><td>Survey Taker ID</td><td>Survey Taken</td><cfloop query="questions"><td>#question#</td></cfloop></tr></cfoutput>
	
		<cfloop query="getSurveyTakers">
			
			<cfset answerRow = "">
			<cfset oid = ownerid>
			<cfloop query="questions">
				<cfset answerRow = answerRow & "<td>" & htmlEditFormat(application.survey.getAnswerResult(id,oid)) & "</td>">
			</cfloop>
			
			<cfoutput><tr><td>#ownerid#</td><td>#dateFormat(completed,"mm/dd/yy")# #timeFormat(completed,"h:mm tt")#</td>#answerRow#</tr></cfoutput>
		</cfloop>
	
		<cfoutput></table></cfoutput>
		</cfsavecontent>
		
	
		<cfif form.format is "excel">
			<cfcontent type="application/msexcel">
			<cfheader name="content-disposition" value="attachment;filename=report.xls">
			<cfoutput>#report#</cfoutput>
			<cfabort>
		</cfif>
		
		<cfif form.format is "pdf">
			<cfcontent type="application/pdf">
			<cfheader name="content-disposition" value="attachment;filename=report.pdf">
			<cfdocument format="pdf" orientation="landscape">
			<cfoutput>#report#</cfoutput>
			</cfdocument>
		</cfif>
						
	</cfif>

</cfif>
	
<cfsetting enablecfoutputonly=false>