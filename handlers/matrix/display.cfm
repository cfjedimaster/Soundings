<cfsetting enablecfoutputonly=true>
<!---
	Name         : handlers/matrix/display.cfm
	Author       : Raymond Camden 
	Created      : October 7, 2005
	Last Updated : April 10, 2006
	History      : Wasn't working when you went backwards (rkc 4/10/06)
	Purpose		 : Supports Matrix
--->

<cfparam name="attributes.question">
<cfparam name="attributes.r_result" default="result">
<cfparam name="attributes.answer">
<cfparam name="attributes.step">

<cfif not structKeyExists(attributes, "answers")>
	<cfset answers = application.question.getAnswers(attributes.question.id)>	
<cfelse>
	<cfset answers = attributes.answers>
</cfif>

<cfquery name="getAnswers" dbtype="query">
	select 		*
	from		answers
	where		rank >= 0
	order by 	rank asc
</cfquery>

<cfquery name="getItems" dbtype="query">
	select 		*
	from		answers
	where		rank < 0
	order by 	rank desc
</cfquery>

<cfif isDefined("form.submit")>
	<cfif attributes.question.required>
		<cfloop query="getItems">
			<cfif not structKeyExists(form, "q" & replace(id,"-","_","all"))>
				<cfset errors = "You must select an answer for each item.">
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
				
	<cfif not isDefined("errors")>
		<cfset result = structNew()>
		<cfloop query="getItems">
			<cfparam name="form.q#replace(id,"-","_","all")#" default="">
			<cfset result[id] = form["q" & replace(id,"-","_","all")]>
		</cfloop>

		<!--- param for non required results --->
		<cfset caller[attributes.r_result] = result>
	</cfif>
</cfif>

	
<cfif isDefined("errors")>
	<cfoutput>
	<p class="error">#errors#</p>
	</cfoutput>
</cfif>
	
<cfoutput>
<p>
<table>
	<tr valign="top">
		<td>#attributes.step#) #attributes.question.question# <cfif attributes.question.required EQ 1><strong class="required">*</strong></cfif></td>
	</tr>
	<tr valign="top">
		<td>
		<table border="1" cellpadding="5">
			<tr>
				<td>&nbsp;</td>
				<cfloop query="getAnswers">
					<td>#answer#</td>
				</cfloop>
			</tr>
			<cfloop query="getItems">
				<cfset itemid = id>
				<cfset itemname = replace(itemid,"-","_","all")>
				<tr>
					<td><label for="q#itemname#_#id#">#answer#</label></td>
					<cfloop query="getAnswers">
					<!---<cfset selected = isDefined("form.q#itemname#") and form["q" & itemname] is id>--->
					<cfset selected = false>
					<cfif (isDefined("form.q#itemname#") and form["q" & itemname] is id)
							or
						  (structKeyExists(attributes, "answer") and isStruct(attributes.answer) and structKeyExists(attributes.answer, itemid) and attributes.answer[itemid] is id)
						  	>
						<cfset selected = true>
					</cfif>			  	
					<td><input type="radio" name="q#itemname#" id="q#itemname#_#id#" value="#id#" <cfif selected>checked</cfif>></td>
					</cfloop>
				</tr>
			</cfloop>
		</table>
		</td>
	</tr>
</table>
</p>
</cfoutput>
				
<cfsetting enablecfoutputonly=false>

<cfexit method="exittag">