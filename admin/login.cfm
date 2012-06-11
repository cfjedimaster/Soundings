<cfsetting enablecfoutputonly=true>
<!---
	Name         : login.cfm
	Author       : Raymond Camden 
	Created      : September 01, 2004
	Last Updated : March 4, 2005
	History      : removed bad js
	Purpose		 : 
--->
<cfimport taglib="../tags/" prefix="tags">

<tags:layout templatename="plain" title="Soundings Admin Login">

<cfoutput>

<TABLE WIDTH="100%" BORDER="0" CELLSPACING="0" CELLPADDING="0" height="90%" width="100%">
	<TR>
		<TD ALIGN="center" VALIGN="middle">
		
<form action="#cgi.script_name#?#cgi.query_string#" method="post" name="login">	
<table width="585" height="115" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td><div align="center"><img src="../images/logo.gif" width="172" height="185"></div></td>
  </tr>
  <tr>
    <td height="115" background="../images/login.gif"><table width="68%" border="0" align="right" cellpadding="7" cellspacing="0">
       <tr>
        <td>
          <input type="text" name="username" value="">
        </td>
      </tr>
      <tr>
        <td>
          <input type="password" name="password" value=""> <input type="submit" name="logon" value="Login"></td>
      </tr>

    </table></td>
  </tr>
</table>
</form>
		</TD>
	</TR>
</TABLE>
<script>
document.login.username.focus();
</script>
</cfoutput>

</tags:layout>

<cfsetting enablecfoutputonly=false>