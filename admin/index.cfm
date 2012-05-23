<cfsetting enablecfoutputonly=true>
<!---
	Name         : index.cfm
	Author       : Raymond Camden 
	Created      : September 01, 2004
	Last Updated : February 11, 2006
	History      : Just changed the text a bit.
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<tags:layout templatename="admin" title="Welcome to the Soundings Administrator">

<cfoutput>
<p>
Welcome to Soundings #application.settings.version#. This administrator allows you to edit all aspects of your surveys. Please select an option from the top menu to begin.
</p>

<p>
Please send any bug reports to <a href="mailto:ray@camdenfamily.com">Raymond Camden</a>. For the latest
news and updates, visit the <a href="http://soundings.riaforge.org">Soundings project page</a>.
</p>
</cfoutput>

</tags:layout>

<cfsetting enablecfoutputonly=false>