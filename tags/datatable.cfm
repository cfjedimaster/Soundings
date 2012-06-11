<cfsetting enablecfoutputonly=true>
<!---
	Name         : datatable.cfm
	Author       : Raymond Camden 
	Created      : June 02, 2004
	Last Updated : July 23, 2004
	History      : JS fix (7/23/04)
	Purpose		 : A VERY app specific datable tag. 
--->

<cfif thisTag.hasEndTag and thisTag.executionMode is "start">
	<cfsetting enablecfoutputonly=false>
	<cfexit method="EXITTEMPLATE">
</cfif>

<cfparam name="attributes.data" type="query">
<cfparam name="attributes.linkcol" default="#listFirst(attributes.data.columnList)#">
<cfparam name="attributes.linkval" default="id">
<cfparam name="attributes.list" default="#attributes.data.columnList#">
<cfparam name="attributes.labellist" default="#attributes.list#">
<cfparam name="attributes.deleteMsg" default="Are you sure?">
<cfparam name="attributes.queryString" default="">
<cfparam name="attributes.perpage" default="10">

<cfparam name="url.page" default="1">

<cfset colWidths = structNew()>
<cfset formatCols = structNew()>

<!--- allow for datacol overrides --->
<cfif structKeyExists(thisTag,"assocAttribs")>
	<cfset attributes.list = "">
	<cfset attributes.labellist = "">
	
	<cfloop index="x" from="1" to="#arrayLen(thisTag.assocAttribs)#">
		<cfset attributes.list = listAppend(attributes.list, thisTag.assocAttribs[x].name)>
		<cfif structKeyExists(thisTag.assocAttribs[x], "label")>
			<cfset label = thisTag.assocAttribs[x].label>
		<cfelse>
			<cfset label = thisTag.assocAttribs[x].name>
		</cfif>
		<cfif structKeyExists(thisTag.assocAttribs[x], "format")>
			<cfset formatCols[thisTag.assocAttribs[x].name] = thisTag.assocAttribs[x].format>
		</cfif>		
		<cfset attributes.labellist = listAppend(attributes.labellist, label)>
		<cfif structKeyExists(thisTag.assocAttribs[x], "width")>
			<cfset colWidths[label] = thisTag.assocAttribs[x].width>
		</cfif>
	</cfloop>
</cfif>

<cfif not isNumeric(url.page) or url.page lte 0>
	<cfset url.page = 1>
</cfif>

<cfif isDefined("url.msg")>
	<cfoutput>
	<p>
	<b>#url.msg#</b>
	</p>
	</cfoutput>
</cfif>

<cfoutput>
<script>
function checksubmit() {
	if(document.listing.mark.length == null) {
		if(document.listing.mark.checked) {
			document.listing.submit();
			return;
		}
	}

	for(i=0; i < document.listing.mark.length; i++) {
		if(document.listing.mark[i].checked) document.listing.submit();
	}
}
</script>

<p>
<form name="listing" action="#cgi.script_name#?#attributes.queryString#" method="post">
<table cellspacing=0 cellpadding=5 class="adminListTable">
	<cfset qs = cgi.query_string>
	<cfset qs = reReplaceNoCase(qs,"page=[0-9]+","")>
	<cfif right(qs,1) is "&">
		<cfset qs = left(qs, len(qs)-1)>
	</cfif>
	<!--- add a dummy url variable - so we don't end up with ?&a=b which a user reported through an error in iis --->
	<cfif not len(qs)>
		<cfset qs = "pref=1">
	</cfif>
	
	
	<cfif attributes.data.recordCount gt attributes.perpage>
		<tr>
		<td colspan="#1+listLen(attributes.labelList)#">
		<p align="right">
		[[
		<cfif url.page gt 1>
			<a href="#cgi.script_name#?#qs#&page=#url.page-1#">Previous</a>
		<cfelse>
			Previous
		</cfif>
		--
		<cfif url.page * attributes.perpage lt attributes.data.recordCount>
			<a href="#cgi.script_name#?#qs#&page=#url.page+1#">Next</a>
		<cfelse>
			Next
		</cfif>
		]]
		</p>
		</td>
		</tr>
	</cfif>
	<tr class="adminListHeader">
		<td width="30">&nbsp;</td>
		<cfloop index="c" list="#attributes.labellist#">
			<td <cfif structKeyExists(colWidths, c)>width="#colWidths[c]#"</cfif>>
			<!--- static rewrites of a few of the columns --->
			#c#
			</td>
		</cfloop>
	</tr>
</cfoutput>

<cfif attributes.data.recordCount>

	<cfoutput query="attributes.data" startrow="#(url.page-1)*attributes.perpage + 1#" maxrows="#attributes.perpage#">
		<cfset theLink = attributes.editlink & "?id=#attributes.data[attributes.linkval][currentRow]#">
		<tr class="adminList#currentRow mod 2#">
			<td width="20"><input type="checkbox" name="mark" value="#attributes.data[attributes.linkval][currentRow]#"></td>
			<cfloop index="c" list="#attributes.list#">
				<cfset value = attributes.data[c][currentRow]>
				<cfif value is "">
					<cfset value = "&nbsp;">
				</cfif>
				<cfif structKeyExists(formatCols, c)>
					<cfswitch expression="#formatCols[c]#">

						<cfcase value="yesno">
							<cfset value = yesNoFormat(value)>
						</cfcase>
						
						<cfcase value="datetime">
							<cfset value = dateFormat(value,"mm/dd/yy") & " " & timeFormat(value,"h:mm tt")>
						</cfcase>

					</cfswitch>
				</cfif>
				<td>
				<cfif c is attributes.linkcol>
				<a href="#attributes.editlink#?id=#attributes.data[attributes.linkval][currentRow]#&#attributes.queryString#">#value#</a>
				<cfelse>
				#value#
				</cfif>
				</td>
			</cfloop>
		</tr>
	</cfoutput>
<cfelse>

</cfif>

<cfoutput>
	<tr>
		<td colspan="#1+listLen(attributes.labellist)#">
		<p align="right">
		[<a href="#attributes.editlink#?id=0&#attributes.queryString#">Add #attributes.label#</a>] [<a href="javaScript:if(confirm('#jsStringFormat(attributes.deleteMsg)#')) checksubmit()">Delete Selected</a>]
		</p>
		</td>
	</tr>
</table>
</form>
</p>
</cfoutput>

<cfsetting enablecfoutputonly=false>

