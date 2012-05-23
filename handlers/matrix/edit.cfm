<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/matrix/edit.cfm
	Author       : Raymond Camden 
	Created      : September 20, 2004
	Last Updated : November 14, 2007
	History      : Bug in deleting items (rkc 11/22/05)
				 : Typo, editor said it was multiple choice (rkc 11/14/07)
	Purpose		 : 
--->

<cfparam name="attributes.multi" default="false">
<cfparam name="answers" default="#arrayNew(1)#">
<cfparam name="items" default="#arrayNew(1)#">

<cfif isDefined("attributes.question")>
	<cfparam name="form.question" default="#attributes.question.question#">
	<cfparam name="form.rank" default="#attributes.question.rank#">
	<cfparam name="form.required" default="#attributes.question.required#">

	<cfquery name="qanswers" dbtype="query">
	select	*
	from	attributes.question.answers
	where	rank >= 0
	</cfquery>
	<cfquery name="qitems" dbtype="query">
	select	*
	from	attributes.question.answers
	where	rank <=0
	order by rank desc
	</cfquery>

	<cfloop query="qanswers">
		<cfset answers[arrayLen(answers)+1] = structNew()>
		<cfset answers[arrayLen(answers)].answer = answer>
		<cfset answers[arrayLen(answers)].rank = rank>
		<cfset answers[arrayLen(answers)].id = id>
	</cfloop>
	<cfloop query="qitems">
		<cfset items[arrayLen(items)+1] = structNew()>
		<cfset items[arrayLen(items)].answer = answer>
		<cfset items[arrayLen(items)].rank = -1 * rank>
		<cfset items[arrayLen(items)].id = id>		
	</cfloop>
<cfelse>
	<cfparam name="form.question" default="">
	<cfparam name="form.rank" default="#attributes.toprank+1#">
	<cfparam name="form.required" default="false">
</cfif>
<cfparam name="form.answer_new" default="">
<cfparam name="form.rank_new" default="">
<cfparam name="form.answer_new2" default="">
<cfparam name="form.rank_new2" default="">
<cfparam name="form.item_new" default="">
<cfparam name="form.itemrank_new" default="">
<cfparam name="form.item_new2" default="">
<cfparam name="form.itemrank_new2" default="">

<cfif isDefined("form.delete")>
	<cfset index = listLast(form.delete," ")>
	<cfset id = answers[index].id>
	<cfset application.question.deleteAnswer(id)>
	<cfset arrayDeleteAt(answers,index)>
</cfif>

<cfif isDefined("form.delete_item")>
	<cfset index = listLast(form.delete_item," ")>
	<cfset id = items[index].id>
	<cfset application.question.deleteAnswer(id)>
	<cfset arrayDeleteAt(items,index)>
</cfif>

<cfif isDefined("form.save")>
	<cfset form = request.udf.cleanStruct(form)>
	<cfset errors = "">

	<cfif not len(form.question)>
		<cfset errors = errors & "You must enter a question.<br>">
	</cfif>
	
	<cfif form.rank is "" or not isNumeric(form.rank) or form.rank lte 0>
		<cfset errors = errors & "Rank must be 1 or above.<br>">
	</cfif>
	
	<!--- ANSWERS --->
	<cfset answers = arrayNew(1)>
	<cfset counter = 1>
	<cfloop condition="isDefined(""form.answer#counter#"")">
		<cfset a = form["answer#counter#"]>
		<cfset r = form["rank#counter#"]>
		<cfif len(a) and len(r) and isNumeric(r) and r gte 1>
			<cfset answers[arrayLen(answers)+1] = structNew()>
			<cfset answers[arrayLen(answers)].answer = a>
			<cfset answers[arrayLen(answers)].rank = r>
			<cfif isDefined("form.answerid#counter#")>
				<cfset answers[arrayLen(answers)].id = form["answerid#counter#"]>
			</cfif>
		</cfif>
		<cfif a is "" and r is "">
			<!--- deletion of answer, it's ok, really --->
		<cfelse>
			<cfif a is "">
				<cfset errors = errors & "The answer cannot be blank.<br>">
			<cfelseif r is "">
				<cfset errors = errors & "The rank for #a# cannot be blank.<br>">
			<cfelseif not isNumeric(r) or r lte 0>
				<cfset errors = errors & "The rank, #r#, must be numeric and greater than zero.<br>">
			</cfif> 
		</cfif>
		<cfset counter = counter + 1>
	</cfloop>
	<cfif len(form.answer_new)>
		<cfif not len(form.rank_new) or not isNumeric(form.rank_new) or form.rank_new lte 0>
			<cfset errors = errors & "Your rank for the new answer must be numeric and greater than one.<br>">
		<cfelse>
			<cfset answers[arrayLen(answers)+1] = structNew()>
			<cfset answers[arrayLen(answers)].answer = form.answer_new>
			<cfset answers[arrayLen(answers)].rank = form.rank_new>
			<cfset form.answer_new = "">
			<cfset form.rank_new = "">
		</cfif>			
	</cfif>
	<cfif len(form.answer_new2)>
		<cfif not len(form.rank_new2) or not isNumeric(form.rank_new2) or form.rank_new2 lte 0>
			<cfset errors = errors & "Your rank for the new answer must be numeric and greater than one.<br>">
		<cfelse>
			<cfset answers[arrayLen(answers)+1] = structNew()>
			<cfset answers[arrayLen(answers)].answer = form.answer_new2>
			<cfset answers[arrayLen(answers)].rank = form.rank_new2>
			<cfset form.answer_new2 = "">
			<cfset form.rank_new2 = "">
		</cfif>			
	</cfif>

	<cfif arrayLen(answers) lt 2>
		<cfset errors = errors & "You must have at least two answers.<br>">
	</cfif>
		
	<!--- ITEMS --->
	<cfset items = arrayNew(1)>
	<cfset counter = 1>
	<cfloop condition="isDefined(""form.item#counter#"")">
		<cfset a = form["item#counter#"]>
		<cfset r = form["itemrank#counter#"]>
		<cfif len(a) and len(r) and isNumeric(r) and r gte 1>
			<cfset items[arrayLen(items)+1] = structNew()>
			<cfset items[arrayLen(items)].answer = a>
			<cfset items[arrayLen(items)].rank = r>
			<cfif isDefined("form.itemid#counter#")>
				<cfset items[arrayLen(items)].id = form["itemid#counter#"]>
			</cfif>
		</cfif>
		<cfif a is "" and r is "">
			<!--- deletion of answer, it's ok, really --->
		<cfelse>
			<cfif a is "">
				<cfset errors = errors & "The item cannot be blank.<br>">
			<cfelseif r is "">
				<cfset errors = errors & "The rank for #a# cannot be blank.<br>">
			<cfelseif not isNumeric(r) or r lte 0>
				<cfset errors = errors & "The rank, #r#, must be numeric and greater than zero.<br>">
			</cfif> 
		</cfif>
		<cfset counter = counter + 1>
	</cfloop>
	<cfif len(form.item_new)>
		<cfif not len(form.itemrank_new) or not isNumeric(form.itemrank_new) or form.itemrank_new lte 0>
			<cfset errors = errors & "Your rank for the new item must be numeric and greater than one.<br>">
		<cfelse>
			<cfset items[arrayLen(items)+1] = structNew()>
			<cfset items[arrayLen(items)].answer = form.item_new>
			<cfset items[arrayLen(items)].rank = form.itemrank_new>
			<cfset form.item_new = "">
			<cfset form.itemrank_new = "">
		</cfif>			
	</cfif>
	<cfif len(form.item_new2)>
		<cfif not len(form.itemrank_new2) or not isNumeric(form.itemrank_new2) or form.itemrank_new2 lte 0>
			<cfset errors = errors & "Your rank for the new answer must be numeric and greater than one.<br>">
		<cfelse>
			<cfset items[arrayLen(items)+1] = structNew()>
			<cfset items[arrayLen(items)].answer = form.item_new2>
			<cfset items[arrayLen(items)].rank = form.itemrank_new2>
			<cfset form.item_new2 = "">
			<cfset form.itemrank_new2 = "">
		</cfif>			
	</cfif>

	<cfif arrayLen(items) lt 2>
		<cfset errors = errors & "You must have at least two items.<br>">
	</cfif>
		
	<cfif not len(errors)>
		<cftry>
			<!--- before saving, invert items and add to answers --->
			<cfloop index="x" from="1" to="#arrayLen(items)#">
				<cfset tempItem = duplicate(items[x])>
				<cfset tempItem.rank = -1 * tempItem.rank>
				<cfset arrayAppend(answers, tempItem)>
			</cfloop>
			
			<cfif not isDefined("attributes.question")>
				<cfset qid = application.question.addQuestion(question=form.question,rank=form.rank,required=form.required,surveyidfk=attributes.surveyidfk,questiontypeidfk=attributes.questionType.id,answers=answers)>
			<cfelse>
				<cfset application.question.updateQuestion(id=attributes.question.id,question=form.question,rank=form.rank,required=form.required,surveyidfk=attributes.surveyidfk,questiontypeidfk=attributes.questiontype.id,answers=answers)>
				<cfset qid = attributes.question.id>
			</cfif>

			<cfinclude template="../nextquestionlogic.cfm">

			<cfset msg = "Your question has been saved.">
			<cflocation url="questions.cfm?surveyidfk=#attributes.surveyidfk#&msg=#urlEncodedFormat(msg)#" addToken="false">
			<cfcatch>
				<cfset errors = cfcatch.message>
				<!--- clean answers --->
				<cfloop index="x" to="#arrayLen(answers)#" from="1" step="-1">
					<cfif answers[x].rank lt 0>
						<cfset arrayDeleteAt(answers, x)>
					</cfif>
				</cfloop>
			</cfcatch>
		</cftry>
	</cfif>
	
</cfif>

<cfoutput>
<p>
Please use the form below to edit the Matrix question. You must have at least two choices. 
</p>

<p>
<cfif isDefined("errors")><ul><b>#errors#</b></ul></cfif>
<form action="#cgi.script_name#?#attributes.queryString#" method="post">
<table cellspacing=0 cellpadding=5 class="adminEditTable" width="100%">
	<tr valign="top">
		<td width="200"><b>(*) Question:</b></td>
		<td><input type="text" name="question" value="#form.question#" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>(*) Rank:</b></td>
		<td><input type="text" name="rank" value="#form.rank#" size="2"></td>
	</tr>
	<tr valign="top">
		<td><b>(*) Required:</b></td>
		<td>
			<input type="radio" name="required" value="true" <cfif form.required>checked</cfif>>Yes<br>	
			<input type="radio" name="required" value="false" <cfif not form.required>checked</cfif>>No<br>
		</td>
	</tr>

	<!--- Answers --->	
	<tr>
		<td colspan="2">The following answers apply to the values for your matrix. This is how the user will rate each item.</td>
	</tr>
	<cfloop index="x" from="1" to="#arrayLen(answers)#">
		<cfif structKeyExists(answers[x],"id")>
			<input type="hidden" name="answerid#x#" value="#answers[x].id#">
		</cfif>
		<tr>
			<td><b>Answer #x#:</b></td>
			<td><input type="text" name="answer#x#" value="#answers[x].answer#" size="50"></td>
		</tr>
		<tr valign="top">
			<td><b>Rank #x#:</b></td>
			<td><input type="text" name="rank#x#" value="#answers[x].rank#" size="2"> <cfif structKeyExists(answers[x],"id")><input type="submit" name="delete" value="Delete Answer #x#" onClick="return confirm('This change cannot be undone. Are you sure?')"></cfif></td>
		</tr>	
	</cfloop>
	<tr>
		<td><b>New Answer:</b></td>
		<td><input type="text" name="answer_new" value="#form.answer_new#" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>New Rank:</b></td>
		<td><input type="text" name="rank_new" value="#form.rank_new#" size="2"></td>
	</tr>	
	<tr>
		<td><b>New Answer:</b></td>
		<td><input type="text" name="answer_new2" value="#form.answer_new2#" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>New Rank:</b></td>
		<td><input type="text" name="rank_new2" value="#form.rank_new2#" size="2"></td>
	</tr>	

	<!--- items --->
	<tr>
		<td colspan="2">The following are the items that will be ranked.</td>
	</tr>
	<cfloop index="x" from="1" to="#arrayLen(items)#">
		<cfif structKeyExists(items[x],"id")>
			<input type="hidden" name="itemid#x#" value="#items[x].id#">
		</cfif>
		<tr>
			<td><b>Item #x#:</b></td>
			<td><input type="text" name="item#x#" value="#items[x].answer#" size="50"></td>
		</tr>
		<tr valign="top">
			<td><b>Rank #x#:</b></td>
			<td><input type="text" name="itemrank#x#" value="#items[x].rank#" size="2"> <cfif structKeyExists(items[x],"id")><input type="submit" name="delete_item" value="Delete Item #x#" onClick="return confirm('This change cannot be undone. Are you sure?')"></cfif></td>
		</tr>	
	</cfloop>
	<tr>
		<td><b>New Item:</b></td>
		<td><input type="text" name="item_new" value="#form.item_new#" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>New Rank:</b></td>
		<td><input type="text" name="itemrank_new" value="#form.itemrank_new#" size="2"></td>
	</tr>	
	<tr>
		<td><b>New Item:</b></td>
		<td><input type="text" name="item_new2" value="#form.item_new2#" size="50"></td>
	</tr>
	<tr valign="top">
		<td><b>New Rank:</b></td>
		<td><input type="text" name="itemrank_new2" value="#form.itemrank_new2#" size="2"></td>
	</tr>	

	<cfinclude template="../nextquestion.cfm">	

	<tr>
		<td>&nbsp;</td>
		<td><input type="submit" name="save" value="Save"> <input type="submit" name="cancel" value="Cancel"></td>
	</tr>
</table>
</form>
</p>

</cfoutput>

<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">