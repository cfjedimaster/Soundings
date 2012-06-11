<!---
	Name         : C:\projects\soundings\wwwroot\soundings\admin\stats_matrix.cfm
	Author       : Raymond Camden 
	Created      : 03/02/06
	Last Updated : 
	History      : 
--->


<cfchart format="flash" chartWidth="575" chartHeight="575" rotated="yes" show3d=true showLegend=true style="style.xml">
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
						
