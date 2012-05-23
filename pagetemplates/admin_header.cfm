<cfsetting enablecfoutputonly=false>
<!---
	Name         : admin_header.cfm
	Author       : Raymond Camden 
	Created      : September 6, 2004
	Last Updated : April 10, 2006
	History      : work w/o mapping (rkc 3/10/06)
				 : minor html mod (rkc 4/10/06)
	Purpose		 : 
--->

<cfoutput>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<title>#attributes.title#</title>
<link rel="stylesheet" type="text/css" href="../stylesheets/adminStyle.css">
	<script src="javaScripts.cfm"></script>
	<cfif attributes.loadspry>
	<script src="../includes/SpryData.js"></script>
	<script src="../includes/xpath.js"></script>		
	</cfif>
	<script src="../includes/jquery-1.5.2.min.js"></script>
	<script src="../includes/jquery.json-2.2.min.js"></script>
</head>

<body onload="MM_preloadImages('../images/menu1Hot.gif','../images/menu2Hot.gif','../images/menu3Hot.gif','../images/menu4Hot.gif')">
<table width="709" border="0" align="center" cellpadding="0" cellspacing="0">
  <tr>
    <td background="../images/bodyBg.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td><img src="../images/headerTop.gif" width="709" height="106" /></td>
      </tr>
      <tr>
        <td><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><img src="../images/menuLeft.gif" width="165" height="37" /></td>
            <td><a href="" onmouseout="MM_swapImgRestore();delayhidemenu()" onmouseover="MM_swapImage('Image5','','../images/menu1Hot.gif',1);dropdownmenu(this, event, menu1, '148px')"><img src="../images/menu1.gif" name="Image5" width="150" height="37" border="0" id="Image5" /></a></td>
            <td><a href="" onmouseout="MM_swapImgRestore();delayhidemenu()" onmouseover="MM_swapImage('Image6','','../images/menu2Hot.gif',1);dropdownmenu(this, event, menu2, '147px')"><img src="../images/menu2.gif" name="Image6" width="149" height="37" border="0" id="Image6" /></a></td>
            <td><a href="" onmouseout="MM_swapImgRestore();delayhidemenu()" onmouseover="MM_swapImage('Image7','','../images/menu3Hot.gif',1);dropdownmenu(this, event, menu3, '113px')"><img src="../images/menu3.gif" name="Image7" width="115" height="37" border="0" id="Image7" /></a></td>
            <td><a href="" onmouseout="MM_swapImgRestore();delayhidemenu()" onmouseover="MM_swapImage('Image8','','../images/menu4Hot.gif',1);dropdownmenu(this, event, menu4, '113px')"><img src="../images/menu4.gif" name="Image8" width="115" height="37" border="0" id="Image8" /></a></td>
            <td><img src="../images/menuRight.gif" width="15" height="37" /></td>
          </tr>
        </table></td>
      </tr>
      <tr>
        <td height="300" valign="top"><table width="100%" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="1%" valign="top"><img src="../images/left.gif" width="18" height="159" /></td>
            <td width="98%" valign="top"><br />
		<div class="adminPageHeader">#attributes.title#</div>
		<div class="adminBody">
</cfoutput>

<cfsetting enablecfoutputonly=true>

