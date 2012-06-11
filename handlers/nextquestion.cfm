<cfif attributes.questions.recordCount lt 2>
	<cfexit>
</cfif>

<script>
$(document).ready(function() {

	<!---
	Ok, so our logic here is a loop from 1 to N, which is
	total crap. But for the first draft it will work. 
	In the next draft, we'll do it better. As it stands,
	this code won't duplicate more than 2-3 times in a
	request, so it shouldn't be a big deal. It's also only
	a perf issue for admin editing.
	--->
	<cfif structKeyExists(attributes, "question") and attributes.question.branches.recordCount gt 0>
		<cfoutput query="attributes.question.branches">

		$("##nextquestionaction_#currentRow#").change(function() {
			var selvalue = $("##nextquestionaction_#currentRow# option:selected").val();
			if (selvalue == "goto") {
				$("##nextquestionlistarea_#currentRow#").show();
			} else {
				$("##nextquestionlistarea_#currentRow#").hide();
			}
		});
	
		$("##questionfilter_#currentRow#").change(function() {
			var selvalue = $("option:selected", this).val();
			if (selvalue == "onlyif") {
				$("##nextquestionvaluearea_#currentRow#").show();
			} else {
				$("##nextquestionvaluearea_#currentRow#").hide();
			}
		});

		</cfoutput>	
	</cfif>
	
	$("#nextquestionaction_new").change(function() {
		var selvalue = $("#nextquestionaction_new option:selected").val();
		if (selvalue == "goto") {
			$("#nextquestionlistarea_new").show();
		} else {
			$("#nextquestionlistarea_new").hide();
		}
	});

	$("#questionfilter_new").change(function() {
		var selvalue = $("option:selected", this).val();
		if (selvalue == "onlyif") {
			$("#nextquestionvaluearea_new").show();
		} else {
			$("#nextquestionvaluearea_new").hide();
		}
	});

});
</script>

<cfif structKeyExists(attributes, "question")>
	<cfoutput query="attributes.question.branches">
	
	<cfif not structKeyExists(form, "nextquestionaction_#currentRow#")>
		<cfparam name="form.questionfilter_#currentRow#" default="">
		<cfset variables["showblock_#currentRow#"] = false>
		<cfset variables["showanswerblock_#currentRow#"] = false>
	
		<cfif nextquestion neq "">
			<cfset form["nextquestionaction_#currentRow#"] = "goto">
			<cfset variables["showblock_#currentRow#"] = true>
		<cfelse>
			<cfset form["nextquestionaction_#currentRow#"] = "">
		</cfif>
		<cfif nextquestionvalue is not "">
			<cfparam name="form.nextquestionvalue_#currentRow#" default="#nextquestionvalue#">
			<cfset form["questionfilter_#currentRow#"] = "onlyif">
			<cfset variables["showanswerblock_#currentRow#"] = true>
		<cfelse>
			<cfparam name="form.nextquestionvalue_#currentRow#" default="">
		</cfif>
		<cfparam name="form.nextquestion_#currentRow#" default="#nextquestion#">
	<cfelse>
		<cfset variables["showblock_#currentRow#"] = true>
		<cfset variables["showanswerblock_#currentRow#"] = true>
	</cfif>
	
	<tr>
		<td colspan="2">
		<p>
		<b>Post Question Action #currentRow#</b>
		</p>
		When the question is answered 
		<select name="nextquestionaction_#currentRow#" id="nextquestionaction_#currentRow#">
		<option value="" <cfif form["nextquestionaction_#currentRow#"] is "">selected</cfif>>do nothing</option>
		<option value="goto" <cfif form["nextquestionaction_#currentRow#"] is "goto">selected</cfif>>go to</option>
		</select>
		
		<span id="nextquestionlistarea_#currentRow#" <cfif not variables["showblock_#currentRow#"]>style="display:none"</cfif>>
	
			question
			<select name="nextquestion_#currentRow#" id="nextquestionlist_#currentRow#">
				<cfset thisRow = currentRow>
				<cfloop query="attributes.questions">
					<cfif not structKeyExists(attributes, "question")
						or (structKeyExists(attributes, "question") and id neq attributes.question.id)>
					<option value="#id#" <cfif form["nextquestion_#thisRow#"] is id>selected</cfif>>#question#</option>
					</cfif>
				</cfloop>
			</select>
			
			<!---
			We allow you to filter by answer ONLY on
			truefalse+yesno
			MC
			--->
			<cfset qt = attributes.questiontype.name>
			<cfset filterOkList = "Yes/No,True/False,Multiple Choice (Single Selection),Multiple Choice (Single Selection) with Other">
			
			<cfif listFindNoCase(filterOkList, qt)>
				<select id="questionfilter_#currentRow#" name="questionfilter_#currentRow#">
				<option value="" <cfif form["questionfilter_#currentRow#"] is "">selected</cfif>></option>
				<option value="onlyif" <cfif form["questionfilter_#currentRow#"] is "onlyif">selected</cfif>>only if the answer is</option>
				</select>
		
				<!--- possible answers depends on type --->
				<span id="nextquestionvaluearea_#currentRow#" <cfif not variables["showanswerblock_#currentRow#"]>style="display:none"</cfif>>
				<cfswitch expression="#qt#">
					<cfcase value="Yes/No,True/False">
						<select name="nextquestionvalue_#currentRow#">
						<option value="1" <cfif isBoolean(form["nextquestionvalue_#currentRow#"]) and form["nextquestionvalue_#currentRow#"]>selected</cfif>><cfif qt is "Yes/No">Yes<cfelse>True</cfif></option>
						<option value="0" <cfif isBoolean(form["nextquestionvalue_#currentRow#"]) and not form["nextquestionvalue_#currentRow#"]>selected</cfif>><cfif qt is "Yes/No">No<cfelse>False</cfif></option>
						</select>
					</cfcase>
					<cfcase value="Multiple Choice (Single Selection),Multiple Choice (Single Selection) with Other">
						<select name="nextquestionvalue_#currentRow#">
							<cfloop from="1" to="#arrayLen(answers)#" index="x">
								<option value="#answers[x].id#" <cfif form["nextquestionvalue_#currentRow#"] is answers[x].id>selected</cfif>>#answers[x].answer#</option>
							</cfloop>
						</select>
					</cfcase>
				</cfswitch>
				</span>
			</cfif>				
		</span>
		
		</td>
	</tr>
	</cfoutput>
</cfif>

<!--- used for the "new" post q action --->
<cfset showblock_new = false>
<cfset showanswerblock_new = false>
<cfparam name="form.questionfilter_new" default="">
<cfparam name="form.nextquestion_new" default="">
<cfparam name="form.nextquestionaction_new" default="">
<cfparam name="form.nextquestionvalue_new" default="">

<cfoutput>
<tr>
	<td colspan="2">
	<p>
	<b>New Post Question Action</b>
	</p>
	When the question is answered 
	<select name="nextquestionaction_new" id="nextquestionaction_new">
	<option value="" <cfif form.nextquestionaction_new is "">selected</cfif>>do nothing</option>
	<option value="goto" <cfif form.nextquestionaction_new is "goto">selected</cfif>>go to</option>
	</select>
	
	<span id="nextquestionlistarea_new" <cfif not showblock_new>style="display:none"</cfif>>

		question
		<select name="nextquestion_new" id="nextquestionlist_new">
			<cfloop query="attributes.questions">
				<cfif not structKeyExists(attributes, "question")
					or (structKeyExists(attributes, "question") and id neq attributes.question.id)>
				<option value="#id#" <cfif form.nextquestion_new is id>selected</cfif>>#question#</option>
				</cfif>
			</cfloop>
		</select>
		
		<!---
		We allow you to filter by answer ONLY on
		truefalse+yesno
		MC
		--->
		<cfset qt = attributes.questiontype.name>
		<cfset filterOkList = "Yes/No,True/False,Multiple Choice (Single Selection),Multiple Choice (Single Selection) with Other">
		
		<cfif listFindNoCase(filterOkList, qt)>
			<select id="questionfilter_new" name="questionfilter_new">
			<option value="" <cfif form.questionfilter_new is "">selected</cfif>></option>
			<option value="onlyif" <cfif form.questionfilter_new is "onlyif">selected</cfif>>only if the answer is</option>
			</select>
	
			<!--- possible answers depends on type --->
			<span id="nextquestionvaluearea_new" <cfif not showanswerblock_new>style="display:none"</cfif>>
			<cfswitch expression="#qt#">
				<cfcase value="Yes/No,True/False">
					<select name="nextquestionvalue_new">
					<option value="1" <cfif isBoolean(form.nextquestionvalue_new) and form.nextquestionvalue_new>selected</cfif>><cfif qt is "Yes/No">Yes<cfelse>True</cfif></option>
					<option value="0" <cfif isBoolean(form.nextquestionvalue_new) and not form.nextquestionvalue_new>selected</cfif>><cfif qt is "Yes/No">No<cfelse>False</cfif></option>
					</select>
				</cfcase>
				<cfcase value="Multiple Choice (Single Selection),Multiple Choice (Single Selection) with Other">
					<select name="nextquestionvalue_new">
						<cfloop from="1" to="#arrayLen(answers)#" index="x">
							<option value="#answers[x].id#" <cfif form.nextquestionvalue_new is answers[x].id>selected</cfif>>#answers[x].answer#</option>
						</cfloop>
					</select>
				</cfcase>
				<!---
				Decided against supporting this - since you can say, go to N if you pick A, B, and a user may be pick
				A and C, I can't imagine this logic actually being something you want. May change my mind so
				I'm commenting it...
				<cfcase value="Multiple Choice (Multi Selection),Multiple Choice (Multi Selection) with Other">
					<select name="nextquestionvalue" multiple="true" size="4">
						<cfloop from="1" to="#arrayLen(answers)#" index="x">
							<option value="#answers[x].id#" <cfif listFind(form.nextquestionvalue,answers[x].id)>selected</cfif>>#answers[x].answer#</option>
						</cfloop>
					</select>
				</cfcase>
				--->
			</cfswitch>
			</span>
		</cfif>				
	</span>
	
	</td>
</tr>
</cfoutput>
