ReadMe for Soundings

License:
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this
file except in compliance with the License. You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software distributed under the
License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
CONDITIONS OF ANY KIND, either express or implied. See the License for the
specific language governing permissions and limitations under the License.


This readme file only contains release notes and changes. For more information, read the Welcome to Soundings document included
with the zip. If you find this application useful, please consider visitng my Amazon 
wishlist: http://www.amazon.com/o/registry/2TCL1D08EZEYE


========================================= CURRENT UPDATES =========================================
Last Update: June 10, 2012 (Version 4.5.2)
/cfcs/settings.xml.cfm - version
/cfcs/survey.cfc and question.cfc - fixes for duplicating surveys and questions. Credit to user Grant

========================================= ARCHIVED UPDATES =========================================
Last Update: April 25, 2012 (Version 4.5.1)
/cfcs/settings.xml.cfm - version
/tags/surverydisplay.cfm - yet another branching fix

Last Update: April 11, 2012 (Version 4.5)
/admin/stats.cfm - display bug - not a real fix - just disabled he cf7 one

Last Update: March 6, 2012 (Version 4.4)
/install/sqlserver.sql - missing rank

Last Update: February 12, 2012 (Version 4.3)
Thanks to Bill Rae for testing/investigating.

/install/sqlserver.sql - typos in file
/cfcs/question.cfc - more logical fixes to branching
/cfcs/settings.xml.cfm - version
/handlers/nextquestion.cfm - more branching fixes

Last Update: January 19, 2012 (Version 4.2)

/cfcs/settings.xml.cfm - Just the version
/handlers/* - multiple updates to fix bugs 62 and 63
/import/mysql.sql - fixes

All fixes credit to Jens Herden

Last Update: November 21, 2011 (Version 4.1)

A major update to branching has been added. You can now do multiple
'logic' thingies based on question responses. Unfortunately, any older
survey that used this logic will not be supported. Simply go to your survey
and update it with your logic.

Note - nextquestion and nextquestionvalue have been removed from the questions
table and questionbranches has been added as a table.

As for the files, I'd recommend copying everything ever.


Last Update: November 21, 2011 (Version 4.004)
/cfcs/settings.xml.cfm - version #
/handlers/matrix/save.cfm - bug if question was skipped,thx to Michael Forell
/cfcs/survey.cfc - fix a bug when deleting surveys

Last Update: November, 2011 (Version 4.003)
/cfcs/settings.xml.cfm - version #
/tags/surveydisplay.cfm - Should fix the issue with Previous sending you
to a question you would have skipped.
/handlers/nextquestion.cfm - remove console.log
/cfcs/*.cfc, /Application.cfc - Kevin Penny sent in changes to how the CFCs are inited - makes em a bit simpler.

Last Update: July 25, 2011 (Version 4.002)
/install/mysql.sql - added questionsperpage to the survey table. The code
was done earlier - just forgot to update the sql file.
/cfcs/settings.xml.cfm - version #


Last Update: July 25, 2011 (Version 4.001)
/cfcs/question.cfc - fixes a bug with duplicating surveys
/cfcs/settings.xml.cfm - version #

Last Update: May 24, 2011 (Version 4)
Official release. Enjoy the silence.

Last Update: March 6, 2011 (Version 4 (Beta))
Note that almost every file has changed.
Note that the docs are not updated.
Note that the databases are not updated.
Use this script in MySQL:
ALTER TABLE `soundings`.`questions` ADD COLUMN `nextquestion` VARCHAR(35) NULL  AFTER `required` , ADD COLUMN `nextquestionvalue` VARCHAR(255) NULL  AFTER `nextquestion` ;
ALTER TABLE `soundings`.`surveys` ADD COLUMN `questionsperpage` INT NULL  AFTER `showinpubliclist` ;

Maily this update:
Allows for question branching based on conditional logic.
Adds preview ability of questions in admin.
Fixes many small bugs, including a survey editing suggestion by Jared Raddigan.

Last Update: February 8, 2011 (Version 3.012)
Linda Liebermann found a few bugs with templates, this is corrected in admin\template_edit.cfm

NOTE - While there is still MS ACCESS code around, MS ACCESS IS NOT SUPPORTED. The docs have been updated
to reflect this. Users who run MS Access can still run Soundings, but should consider their setup to be unsupported going forward.

/cfcs/settings.xml.cfm - just the version

Last Update: December 10, 2010 (Version 3.011)
/cfcs/settings.xml.cfm - just the version
/cfcs/survery.cfc, user.cfc, utils.cfc - support for PostgresSQL - made by Mischa Sameli
Support for postgressql added to install folder as well.

Last Update: November 16, 2010 (Version 3.010)
/cfcs/settings.xml.cfm - just the version
/handlers/multiplechoice/stats.cfm - fixes an issue where incorrect data was returned

Last Update: November 2, 2010 (Version 3.009)
/cfcs/settings.xml.cfm - just the version
/admin/stats.cfm - Fix div by 0 issue with empty surveys.
/admin/surveys_edit.cfm, cfcs/survey.cfc - enforce limit of 255 on surveymailtos
/install/mysql.sql + sqlserver.sql - ditto above - standardize the size to 255

Last Update: August 24, 2010 (Version 3.008)
/cfcs/settings.xml.cfm - just the version
/admin/surveys_edit.cfm - You can now enter a list of email addresses to mail results to.

Last Update: August 20, 2010 (Version 3.007)
/cfcs/settings.xml.cfm - just the version
/tags/surveydisplay.cfm - If you go Back now in a survey it will attempt to store your answers. Any question
answered incorrectly will not store anything, but an error will not be shown. 

Last Update: March 8, 2010 (Version 3.005)
/tags/datatable.cfm - Made it so we don't have ?& in a URL which seemed to confuse IIS.
/cfcs/settings.xml.cfm - just the version

Last Update: March 8, 2010 (Version 3.005)
/survey.cfm - Updated the file to fix an IE embed issue.
/cfcs/settings.xml.cfm - just the version


Last Update: March 26, 2009 (Version 3.004)
/cfcs/template.cfc - You would get an error if you did a blank header and footer, but they should allow for blanks.
/cfcs/settings.xml.cfm - just the version

Last Update: March 26, 2009 (Version 3.003)
/install/access.mdb - Fix the Access db, thanks Gary Fenton
Access related fixes. 
/admin - various updates to stat display

Notice - you may see some print related files. These files may be safely copied, but they are NOT ready for production yet.
Print support will come soon. I promise. :)

/admin -> Updates in multiple files to lock down survey security, including Questions, Stats

Last Update: January 4, 2009 (Version 3.002)
/admin/users_edit.cfm - addtoken to cflocation
/survey.cfm - You could take an inactive survey
/cfcs/user.cfc - Add User didn't return the new id
/cfcs/survey.cfc - bug in duplicate survey
/cfcs/settings.xml.cfm - version
/install/sqlserver.cfc - fixed bad sql in SQL Server install script, specifically templateidfk in surveys table

Last Update: December 28, 2008 (Version 3.001)
Install scripts for mysql/sql server did not correctly set a user id for the admin user.
Access db is still out of date.
Survey editing - the preview links didn't show the port if non-port 80

Last Update: December 22, 2008 (Version 3)
Just fixed the missing tableprefix value in assignsurveys.cfm. Thanks to use cnl.

Last Update: December 19, 2008 (Version 3)
Final release of 3. Please note the Access database has not been updated. Looking for a volunteer.

Last Update: December 12, 2008 (Version 3)

Please copy all files. I've changed far too many to list them all. I'll describe new features below.

The following database changes must be made - see individual install scripts for precise column types.

surveys:
	add useridfk - varchar/35
	add templateidfk - varchar/35
	add allowembed - tinyint/1
	add showinpubliclist - tinyint/1
	
templates table - new - copy from db script

users:
	add id - varchar/35
	add isAdmin - tinyint/1
	
Now go into the migrate3 folder. Open Application.cfm and remove <cfabort>. Run userid.cfm. This gives a UUID to every user. 
Then run assignsurveys.cfm. You ONLY have to run this if you have surveys. It assigns all surveys to the first user in the 
system. You can edit the userid to assign them all to some other user.

Note - you must edit the users table and set yourself to isAdmin=1.

NEW FEATURES:

Users can be set to be an admin, or just a normal users. The migration script sets everyone to admins. A user that is
not an admin does not have the ability to edit question types or other users. Think of these as survey creators only.
When they view surveys, they will only see their own content. Ditto for reporting. Basically, they have their own system
now.

Surveys have multiple new options.

Show in Public List: This refers to the simple list of surveys on the Soundings public page. Turning this off doesn't protect surveys,
it just removes it from the list. Use this is you want to hand out the URL for a survey to people but not have it shown to the world
at large.

Embed: If turned on, you will be given embed code (iframe) that allows you to place the survey on another site.

Templates: You can now pick a template for a survey. If selected, the header and footer from the template is used instead of the default
Soundings UI.

Reporting: You can now filter reports by dates. I also now show a response rate for optional questions. 



Last Update: February 19, 2008 (Version 2.1)
/Application.cfm, /admin/Application.cfm, removal of cflogin related stuff
/survey.cfm - fix a case issue
/index.cfm - display end date for a survey with an end date
/tags/surveydisplay.cfm - show note about required questions
/stylesheets/style.css - a style for required questions
/includes/udf.cfm - updated security udf, and isemail

For handlers/matrix, textbox, and truefalse:
  save updated to support owneridfk max length of 320 - this supports long emaila ddresses
  display updated to support marking required q
  
 /cfcs/survey.cfc - support longer email addresses
 
 /admin/surveys_edit.cfm - better handling of bad dates

/install/mysql.sql and sqlserver.sql had email related columns (owneridfk's as well) updated to support 320 size

WARNING - ACCESS DB NOT UPDATED. LOOKING FOR VOLUNTEER TO MAKE CHANGES....

Last Update: February 19, 2008 (Version 2.007)
Fixes to various handlers, and stats files in admin. otherview.cfm linked to the wrong file.
Stats had HTML embedded. HTML is now stripped on entry, and on display (for folks w/ old data).
Please copy all files. I'm getting tired of editing release notes, and SVN, and files.

Last Update: December 12, 2007 (Version 2.006)
/admin/surveys.cfm - typo

Last Update: December 12, 2007 (Version 2.005)
/admin/stats.cfm - Fix to Excel link from HTML version. Also added a PDF link there.

Last Update: November 14, 2007 (Version 2.004)
/handlers/matrix/edit.cfm - Typo
/admin/surveys.cfm - Added a quick way to get to questions
/tags/surveydisplay.cfm - problem with max questions

Last Update: August 22, 2007 (Version 2.003)
/includes/udf.cfm - added a new udf
/tags/surveydisplay.cfm - fix for broken Arrays

Last Update: August 16, 2007 (Version 2.002)
Updated MySQL install script by Jared Raddigan

Last Update: August 7, 2007 (Version 2.001)
Updated MySQL install script by Lola Beno
Changed title of admin/password.cfm

Last Update: August 3, 2007 (Version 2)
Most files were updated. I didn't correctly log them all, so just consider
everything updated.

John Ramon did the new design.
Logo by Alex McKinney.

Major new features:

Pagination is supported in surveys now. Currently set to soundings.ini perpage value.
Next version will allow per survey page setting.

Reports updated to include PDF.
Reports now let you filter out questions using Spry.

Admin has new look and feel.

True user manager for admin. Right now all users can do anything they want in admin. You need to add the users table to your database.

Last Update: April 10, 2006 (Version 1.6)
I haven't tracked particular files, but this update includes a fix for CF8 compatability and some
minor layout updates. More updates coming soon.

Last Update: April 10, 2006 (Version 1.5.2)
/cfcs/question.cfc and survey.cfc: Fixes for a bug that occurs when you delete a question and don't correct rank.
/handlers/text/display.cfm
/handlers/truefalse/display.cfm
/pagetemplates/admin_header.cfm
/pagetemplates/main_header.cfm
/pagetemplates/main_footer.cfm
/pagetemplates/plain_header.cfm
/stylesheets/style.css

All of the above: Minor layout changes by John Paul Ashenfelter. Less use of tables. More CSS. good++;

/tags/surveydisplay.cfm - show name of survey in survey display

/handlers/matrix/display.cfm - wasn't working when you went backwards.


Last Update: March 30, 2006 (Version 1.5.1)
/admin/stats.cfm - tableprefix fix
/admin/surveys_edit.cfm - support for Clear Results action
/cfcs/question.cfc - tableprefix fix
/cfcs/survey.cfc - support for Clear Results action
/handlers/matrix/save.cfm and stats.cfm - tableprefix fix
/handlers/muptiplechoice/ Ditto the above
/handlers/textbox/ Ditto the above
/handlers/truefalse/ DItto the abofe

Last Update: March 22, 2006 (Version 1.5.003)
/cfcs/survey.cfm - Forgot one thing for CFMX6 support.

Last Update: March 22, 2006 (Version 1.5.002)
/admin/stat.cfm - Forgot one thing for CFMX6 support.

Last Update: March 22, 2006 (Version 1.5.001)
/cfcs/survey.cfc for a table prefix fix.
/cfcs/question.cfc - Make getAnswers order by rank

Last Update: March 10, 2006
Update: 3/10/06 (Version 1.5)
/admin/* - All files in admin touched as part of 'Remove Mapping' update. Note that I didn't bother updating the headers for some pages.
/admin/stats* - Support for CFMX6 brought back in. Charts now all have a set height. Kinda big - but simpler.
/cfc/* - Support for table prefix. Removed mapping setting from ini file.
/pagetemplates/main_header and plain_header - Modded to work w/o mapping
/tags/layout.cfm, surveycomplete.cfm, surveydisplay.cfm - ditto
/Application.cfm, ditto, plus IE fix for hitting Enter in logon form
/index.cfm, /survey.cfm - removed mapping need
Docs updated to reflect no mapping and tableprefix feature.

Update: 2/11/06 (Version 1.4)
/admin/index.cfm - I just changed the text a bit.
/admin/stats.cfm - Fixed an ordering bug in matrix reports.
/cfcs/survey.cfc - Caching to help excel reporting. 
/handlers/matrix/stats.cfm - Helps fix ordering issue in matrix reports.
/install/ - Word doc updated with license and PDF added.

12/19/05
MySQL file had a bug. It marked answers.rank as unsigned. It needs to be signed for Matrix support.

11/22/05
/handlers/matrix/edit.cfm - error when deleting item - Thanks to Mal Brisbane

11/2/05
/admin/index.cfm - just changed the date
/handlers/multiplechoice/stats.cfm - major fix
handlers/matrix/display.cfm - fix for UUIDs with #s in them

10/28/05
admin/stats - forgot to remove debug code, fix in matrix stat colors
handlers/multiplechoice/edit and display - limits to field size
handlers/textbox/ditto
install/mysql.sql - typo fix

10/8/05
Many files changed, so I recommend copying all of them over.
Added support for Matrix style questions. This requires 1-2 database changes.
The first change you must make. Edit the results table and add a itemidfk column. Type should be nvarchar (or equivalent) with size=35. Null ok.
The second change is to add support for Matrix style questions. You can either copy the insert from the db script, or use the Soundings admin
to add it yourself. Name should be Matrix, and handler root should be matrix.