<cfsetting enablecfoutputonly=true>
<!---
	Name         : textviewer.cfm
	Author       : Raymond Camden 
	Created      : September 16, 2004
	Last Updated : September 16, 2004
	History      : 
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<cfif not isDefined("url.questionidfk")>
	<cfabort>
</cfif>

<cfset question = application.question.getQuestion(url.questionidfk)>
<cfset qt = application.questiontype.getQuestionType(question.questiontypeidfk)>
<cfmodule template="../handlers/#qt.handlerRoot#/stats.cfm" 
			questionidfk="#url.questionidfk#"
			r_data="data" 
/>

<cfparam name="url.start" default="1">
<cfset perpage = 20>

<tags:layout templatename="plain" title="Text Answers">

<cfoutput>
<h2>Text Answers for #question.question#</h2>
</cfoutput>

<cfif data.recordCount is 0>

	<cfoutput>
	<p>
	There are no results for this answer.
	</p>
	</cfoutput>
	
<cfelse>

	<cfif data.recordCount gt perpage>
		<cfoutput>
		<p align="right">
		</cfoutput>
		<cfif url.start gt 1>
			<cfoutput>
			<a href="textviewer.cfm?questionidfk=#url.questionidfk#&start=#url.start-perpage#">Previous</a>
			</cfoutput>
		</cfif>
		<cfif (url.start + perpage - 1) lt data.recordCount>
			<cfoutput>
			<a href="textviewer.cfm?questionidfk=#url.questionidfk#&start=#url.start+perpage#">Next</a>
			</cfoutput>
		</cfif>
	</cfif>
	
	<cfoutput>
	<p>
	<table width="100%" border="1">
	</cfoutput>
	
	<cfset column = listFirst(data.columnlist)>
	<cfoutput query="data" startrow="#url.start#" maxrows="#perpage#">
		<cfset val = data[column][currentRow]>
		<tr
			<cfif currentRow mod 2>bgcolor="yellow"</cfif>
		>
		<td>#currentRow#</td>
		<td width="95%">#val#</td>
		</tr>
	</cfoutput>
	
	<cfoutput>
	</table>
	</p>
	</cfoutput>

</cfif>

</tags:layout>

