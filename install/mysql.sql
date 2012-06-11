DROP TABLE IF EXISTS `answers`;
CREATE TABLE `answers` (
  `id` varchar(35) NOT NULL,
  `questionidfk` varchar(35) NOT NULL,
  `answer` varchar(255) NOT NULL,
  `rank` int(10) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `questions`
--

DROP TABLE IF EXISTS `questionbranches`;
CREATE TABLE questionbranches  ( 
	id               	varchar(35) NOT NULL,
	questionidfk     	varchar(35) NOT NULL,
	nextquestion     	varchar(35) NOT NULL,
	nextquestionvalue	varchar(255) NOT NULL,
	rank             	int(11) NOT NULL,
	PRIMARY KEY(id)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `questions`;
CREATE TABLE `questions` (
  `id` varchar(35) NOT NULL,
  `surveyidfk` varchar(35) NOT NULL,
  `question` varchar(255) NOT NULL,
  `questiontypeidfk` varchar(35) NOT NULL,
  `rank` int(10) unsigned NOT NULL default '0',
  `required` tinyint(3) unsigned NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `questiontypes`
--

DROP TABLE IF EXISTS `questiontypes`;
CREATE TABLE `questiontypes` (
  `id` varchar(35) NOT NULL,
  `name` varchar(50) NOT NULL,
  `handlerroot` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
CREATE TABLE `results` (
  `owneridfk` varchar(320) NOT NULL,
  `questionidfk` varchar(35) NOT NULL,
  `answeridfk` varchar(35) default NULL,
  `truefalse` tinyint(3) unsigned default NULL,
  `textbox` varchar(255) default NULL,
  `textboxmulti` text,
  `other` varchar(255) default NULL,
  `itemidfk` varchar(35) default NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `survey_emailaddresses`
--

DROP TABLE IF EXISTS `survey_emailaddresses`;
CREATE TABLE `survey_emailaddresses` (
  `surveyidfk` varchar(35) NOT NULL,
  `emailaddress` varchar(320) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `survey_results`
--

DROP TABLE IF EXISTS `survey_results`;
CREATE TABLE `survey_results` (
  `surveyidfk` varchar(35) NOT NULL,
  `ownerid` varchar(320) NOT NULL,
  `completed` datetime NOT NULL default '0000-00-00 00:00:00'
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `surveys`
--

DROP TABLE IF EXISTS `surveys`;
CREATE TABLE `surveys` (
  `id` varchar(35) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(255) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL default '0',
  `datebegin` datetime default NULL,
  `dateend` datetime default NULL,
  `resultmailto` varchar(255) default NULL,
  `surveypassword` varchar(50) default NULL,
  `thankyoumsg` text,
  `useridfk` varchar(35) NOT NULL,
  `templateidfk` varchar(35) default NULL,
  `allowembed` tinyint(4) default NULL,
  `showinpubliclist` tinyint(4) default NULL,
  `questionsperpage`	int(11) NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `templates`
--

DROP TABLE IF EXISTS `templates`;
CREATE TABLE `templates` (
  `header` text NOT NULL,
  `id` varchar(35) NOT NULL,
  `footer` text NOT NULL,
  `useridfk` varchar(35) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) default NULL,
  `isadmin` tinyint(4) default NULL,
  `id` varchar(35) default NULL,
  PRIMARY KEY  (`username`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;


INSERT INTO questiontypes(id, name, handlerroot)
VALUES('1EB9DDE1-C9C4-302C-3B98D7C3FEFD49E6', 'Matrix', 'matrix');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C3818CC-0A9C-D457-7471E322BAD72874', 'True/False', 'truefalse');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C38479C-9A5D-10AA-84C4575501F22BAB', 'Yes/No', 'yesno');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C386D16-A997-7B46-A0A52A767EC27586', 'Multiple Choice (Single Selection)', 'multiplechoice');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C3898D9-B098-B443-BA496411714AF499', 'Multiple Choice (Multi Selection)', 'multiplechoicemulti');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C38BE43-0B52-6068-0725ABBD4380A2A4', 'Multiple Choice (Multi Selection) with Other', 'multiplechoicemultiother');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C38E841-9913-D91D-2A84D3F4A13AF92E', 'Multiple Choice (Single Selection) with Other', 'multiplechoiceother');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C390D2F-BA60-EA48-8EF87424CF09FD03', 'Text Box (Single)', 'textbox');

INSERT INTO questiontypes(id, name, handlerroot)
VALUES('6C3930D4-AA69-D471-58DBBC6CF38E5101', 'Text Box (Multi)', 'textboxmulti');

INSERT INTO users(username, password,isadmin,id)
VALUES('admin', '21232F297A57A5A743894A0E4A801FC3',1,'7DFC0843-99A6-B280-667D443F86BC2FEA');