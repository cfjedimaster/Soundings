

<cfchart format="flash" chartWidth="575" chartHeight="575"
		 show3d="true" style="style_pie.xml">
	<cfchartseries type="pie" paintStyle="raise" seriesColor="#currentColor#">
		<cfchartdata item="#f#" value="#data.false#">						
		<cfchartdata item="#t#" value="#data.true#">
	</cfchartseries> 
</cfchart>
