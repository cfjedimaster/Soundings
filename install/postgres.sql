--
-- PostgreSQL database dump
--

-- Dumped from database version 8.4.4
-- Dumped by pg_dump version 9.0.1
-- Started on 2010-11-19 06:08:53 CET

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

DROP TABLE IF EXISTS answers, questionbranches, questions, questiontypes, results, survey_emailaddresses, survey_results, surveys, templates, users

CREATE TABLE answers (
    id character varying(35) NOT NULL,
    questionidfk character varying(35) NOT NULL,
    answer character varying(255) NOT NULL,
    rank integer DEFAULT 1 NOT NULL
);


CREATE TABLE questionbranches (
    id character varying(35) NOT NULL,
    questionidfk character varying(35) NOT NULL,
    nextquestion character varying(35) NOT NULL,
    nextquestionvalue character varying(255) NOT NULL
);

CREATE TABLE questions (
    id character varying(35) NOT NULL,
    surveyidfk character varying(35) NOT NULL,
    question character varying(255) NOT NULL,
    questiontypeidfk character varying(35) NOT NULL,
    rank integer DEFAULT 1 NOT NULL,
    required boolean DEFAULT false NOT NULL
);

CREATE TABLE questiontypes (
    id character varying(35) NOT NULL,
    name character varying(50) NOT NULL,
    handlerroot character varying(50) NOT NULL
);


CREATE TABLE results (
    id integer NOT NULL,
    owneridfk character varying(320) NOT NULL,
    questionidfk character varying(35) NOT NULL,
    answeridfk character varying(35),
    textbox character varying(255),
    textboxmulti text,
    other character varying(255),
    itemidfk character varying(35),
    truefalse boolean DEFAULT false NOT NULL
);



CREATE SEQUENCE results_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;



ALTER SEQUENCE results_id_seq OWNED BY results.id;


SELECT pg_catalog.setval('results_id_seq', 17, true);


CREATE TABLE survey_emailaddresses (
    surveyidfk character varying(35) NOT NULL,
    emailaddress character varying(320) NOT NULL,
    id integer NOT NULL
);


CREATE SEQUENCE survey_emailaddresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE survey_emailaddresses_id_seq OWNED BY survey_emailaddresses.id;



SELECT pg_catalog.setval('survey_emailaddresses_id_seq', 1, false);



CREATE TABLE survey_results (
    surveyidfk character varying(35) NOT NULL,
    ownerid character varying(320) NOT NULL,
    completed timestamp with time zone DEFAULT now() NOT NULL
);



CREATE TABLE surveys (
    id character varying(35) NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255) NOT NULL,
    datebegin timestamp with time zone,
    dateend timestamp with time zone,
    resultmailto character varying(255),
    surveypassword character varying(50),
    thankyoumsg text,
    useridfk character varying(35) NOT NULL,
    templateidfk character varying(35),
    allowembed boolean DEFAULT false NOT NULL,
    showinpubliclist boolean DEFAULT false NOT NULL,
    active boolean DEFAULT false NOT NULL,
    questionsperpage integer NULL
);

CREATE TABLE templates (
    header text NOT NULL,
    id character varying(35) NOT NULL,
    footer text NOT NULL,
    useridfk character varying(35) NOT NULL,
    name character varying(255) NOT NULL
);



CREATE TABLE users (
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    id character varying(35) NOT NULL,
    isadmin boolean DEFAULT false NOT NULL
);



ALTER TABLE results ALTER COLUMN id SET DEFAULT nextval('results_id_seq'::regclass);



ALTER TABLE survey_emailaddresses ALTER COLUMN id SET DEFAULT nextval('survey_emailaddresses_id_seq'::regclass);


INSERT INTO questiontypes (id, name, handlerroot) VALUES ('EB630C1D-D60E-C291-376C5DC8D421E540', 'True/False', 'truefalse');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('1208782D-D3B9-F6D4-969C76BE28A42B81', 'Yes/No', 'yesno');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('196A44E0-B9D4-AB9B-11975561F1F54D71', 'Multiple Choice (Single Selection)', 'multiplechoice');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('1E950757-C4F2-A935-A25143E9658EF0A4', 'Multiple Choice (Multi Selection)', 'multiplechoicemulti');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('1E9D2DE3-B675-8035-C217485FC0AB0504', 'Multiple Choice (Multi Selection) with Other', 'multiplechoicemultiother');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('1E9D6956-A402-C7A8-438A5980CB09D174', 'Multiple Choice (Single Selection) with Other', 'multiplechoiceother');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('1E9F94A2-F891-24EB-0B958132B3E90F4D', 'Text Box (Single)', 'textbox');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('1E9FBB54-F2D2-64FE-CC53AD6C2B7F32C2', 'Text Box (Multi)', 'textboxmulti');
INSERT INTO questiontypes (id, name, handlerroot) VALUES ('1EB9DDE1-C9C4-302C-3B98D7C3FEFD49E6', 'Matrix', 'matrix');

INSERT INTO users (username, password, id, isadmin) VALUES ('admin', '21232F297A57A5A743894A0E4A801FC3', '7DFC0843-99A6-B280-667D443F86BC2FEA', true);


ALTER TABLE ONLY answers
    ADD CONSTRAINT answers_pkey PRIMARY KEY (id);


ALTER TABLE ONLY questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);



ALTER TABLE ONLY questiontypes
    ADD CONSTRAINT questiontypes_pkey PRIMARY KEY (id);



ALTER TABLE ONLY results
    ADD CONSTRAINT results_pkey PRIMARY KEY (id);



ALTER TABLE ONLY survey_emailaddresses
    ADD CONSTRAINT survey_emailaddresses_pkey PRIMARY KEY (id);



ALTER TABLE ONLY survey_results
    ADD CONSTRAINT survey_results_pkey PRIMARY KEY (surveyidfk, ownerid);



ALTER TABLE ONLY surveys
    ADD CONSTRAINT surveys_pkey PRIMARY KEY (id);



ALTER TABLE ONLY templates
    ADD CONSTRAINT templates_pkey PRIMARY KEY (id);



ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);



REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2010-11-19 06:08:54 CET

--
-- PostgreSQL database dump complete
--

