<!---
	Name         : C:\projects\soundings\wwwroot\soundings\admin\stats_mc.cfm
	Author       : Raymond Camden 
	Created      : 03/02/06
	Last Updated : 
	History      : 
	style="style.xml" 
--->

<cfchart format="flash" chartWidth="575" chartHeight="575"
		 gridlines="#max+1#" style="style.xml" scaleFrom="0">
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
