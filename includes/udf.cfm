<cfsetting enablecfoutputonly=true>
<!---
	Name         : udf.cfm
	Author       : Raymond Camden 
	Created      : June 01, 2004
	Last Updated : August 22, 2007
	History      : 
	Purpose		 : 
--->

<cfscript>
function isLoggedOn() {
	return structKeyExists(session, "loggedin");
}
request.udf.isLoggedOn = isLoggedOn;

/**
* Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
* Update by David Kearns to support '
* SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
* More TLDs
* Version 4 by P Farrel, supports limits on u/h
* Added mobi
* v6 more tlds
*
* @param str      The string to check. (Required)
* @return Returns a boolean.
* @author Jeff Guillaume (SBrown@xacting.comjeff@kazoomis.com)
* @version 6, July 29, 2008
*/
function isEmail(str) {
	return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|asia|biz|cat|coop|info|museum|name|jobs|post|pro|tel|travel|mobi))$",arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
}
request.udf.isEmail = isEmail;

function isValidUsername(str) {
	if(reFindNoCase("[^a-z0-9]",str)) return false;
	return true;
}
request.udf.isValidUsername = isValidUsername;

function cleanStruct(s) {
	var key = "";
	var ignorelist = "";
	if(arrayLen(arguments) gte 2) ignorelist = arguments[2];
	for(key in s) {
		if(not listFindNoCase(ignorelist, key)) s[key] = trim(htmlEditFormat(s[key]));
	}
	return s;
}
request.udf.cleanStruct = cleanStruct;

/**
 * Returns a XHTML compliant string wrapped with properly formatted paragraph tags.
 * 
 * @param string 	 String you want XHTML formatted. 
 * @param attributeString 	 Optional attributes to assign to all opening paragraph tags (i.e. style=""font-family: tahoma""). 
 * @return Returns a string. 
 * @author Jeff Howden (jeff@members.evolt.org) 
 * @version 1.1, January 10, 2002 
 */
function XHTMLParagraphFormat(string) {
  var attributeString = '';
  var returnValue = '';
  
  //added by me to support different line breaks
  string = replace(string, chr(10) & chr(10), chr(13) & chr(10), "all");
  
  if(ArrayLen(arguments) GTE 2) attributeString = ' ' & arguments[2];
  if(Len(Trim(string)))
    returnValue = '<p' & attributeString & '>' & Replace(string, Chr(13) & Chr(10), '</p>' & Chr(13) & Chr(10) & '<p' & attributeString & '>', 'ALL') & '</p>';
  return returnValue;
}

request.udf.XHTMLParagraphFormat = XHTMLParagraphFormat;

function arrayDefinedAt(arr,pos) {
	var temp = "";
	try {
		temp = arr[pos];
		return true;
	} 
	catch(coldfusion.runtime.UndefinedElementException ex) {
		return false;
	}
	catch(coldfusion.runtime.CfJspPage$ArrayBoundException ex) {
		return false;
	}
}
request.udf.arrayDefinedAt = arrayDefinedAt;
</cfscript>

<cfsetting enablecfoutputonly=false>