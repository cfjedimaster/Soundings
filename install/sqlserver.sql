/****** Object:  Table [dbo].[answers]    Script Date: 10/6/2004 8:44:30 PM ******/
CREATE TABLE [dbo].[answers] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[questionidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[answer] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rank] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[questionbranches] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[questionidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[nextquestionvalue] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[nextquestion] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rank] [int] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[questions]    Script Date: 10/6/2004 8:44:32 PM ******/
CREATE TABLE [dbo].[questions] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[surveyidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[question] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[questiontypeidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[rank] [int] NOT NULL ,
	[required] [bit] NOT NULL
	
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[questiontypes]    Script Date: 10/6/2004 8:44:32 PM ******/
CREATE TABLE [dbo].[questiontypes] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[handlerroot] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[results]    Script Date: 10/6/2004 8:44:32 PM ******/
CREATE TABLE [dbo].[results] (
	[owneridfk] [nvarchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[questionidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[answeridfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[truefalse] [bit] NULL ,
	[textbox] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[textboxmulti] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[other] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [itemidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

/****** Object:  Table [dbo].[survey_emailaddresses]    Script Date: 10/6/2004 8:44:32 PM ******/
CREATE TABLE [dbo].[survey_emailaddresses] (
	[surveyidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[emailaddress] [nvarchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[survey_results]    Script Date: 10/6/2004 8:44:32 PM ******/
CREATE TABLE [dbo].[survey_results] (
	[surveyidfk] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[ownerid] [nvarchar] (320) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[completed] [datetime] NOT NULL 
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[surveys]    Script Date: 10/6/2004 8:44:32 PM ******/
CREATE TABLE [dbo].[surveys] (
	[id] [nvarchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[name] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[description] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[active] [bit] NOT NULL ,
	[datebegin] [datetime] NULL ,
	[dateend] [datetime] NULL ,
	[resultmailto] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[surveypassword] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[thankyoumsg] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
  [useridfk] [nvarchar] (35) NOT NULL,
  [templateidfk] [nvarchar] (35) default NULL,
  [allowembed] [bit] default NULL,
  [showinpubliclist] [bit] default NULL,
  [questionsperpage] [int] NULL  

) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[templates] (
  [header] [ntext] NOT NULL,
  [id] [nvarchar] (35) NOT NULL,
  [footer] [ntext] NOT NULL,
  [useridfk] [nvarchar] (35) NOT NULL,
  [name] [nvarchar] (255) NOT NULL,
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[users] (
	[username] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[password] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
  	[isadmin] [bit] default NULL,
  	[id] [nvarchar] (35) default NULL
) ON [PRIMARY] 
GO

ALTER TABLE [dbo].[templates] WITH NOCHECK ADD 
	CONSTRAINT [PK_templates] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[answers] WITH NOCHECK ADD 
	CONSTRAINT [PK_answers] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[questions] WITH NOCHECK ADD 
	CONSTRAINT [PK_questions] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[surveys] WITH NOCHECK ADD 
	CONSTRAINT [PK_conferences] PRIMARY KEY  CLUSTERED 
	(
		[id]
	)  ON [PRIMARY] 
GO

INSERT questiontypes(id,name,handlerroot) VALUES('EB630C1D-D60E-C291-376C5DC8D421E540','True/False','truefalse')
INSERT questiontypes(id,name,handlerroot) VALUES('1208782D-D3B9-F6D4-969C76BE28A42B81','Yes/No','yesno')
INSERT questiontypes(id,name,handlerroot) VALUES('196A44E0-B9D4-AB9B-11975561F1F54D71','Multiple Choice (Single Selection)','multiplechoice')
INSERT questiontypes(id,name,handlerroot) VALUES('1E950757-C4F2-A935-A25143E9658EF0A4','Multiple Choice (Multi Selection)','multiplechoicemulti')
INSERT questiontypes(id,name,handlerroot) VALUES('1E9D2DE3-B675-8035-C217485FC0AB0504','Multiple Choice (Multi Selection) with Other','multiplechoicemultiother')
INSERT questiontypes(id,name,handlerroot) VALUES('1E9D6956-A402-C7A8-438A5980CB09D174','Multiple Choice (Single Selection) with Other','multiplechoiceother')
INSERT questiontypes(id,name,handlerroot) VALUES('1E9F94A2-F891-24EB-0B958132B3E90F4D','Text Box (Single)','textbox')
INSERT questiontypes(id,name,handlerroot) VALUES('1E9FBB54-F2D2-64FE-CC53AD6C2B7F32C2','Text Box (Multi)','textboxmulti')
INSERT questiontypes(id,name,handlerroot) VALUES('1EB9DDE1-C9C4-302C-3B98D7C3FEFD49E6','Matrix','matrix')
INSERT INTO users(username, password,isadmin,id)
  VALUES('admin', '21232F297A57A5A743894A0E4A801FC3',1,'7DFC0843-99A6-B280-667D443F86BC2FEA')

