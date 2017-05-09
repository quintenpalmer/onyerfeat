--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.2
-- Dumped by pg_dump version 9.6.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ability_score_sets; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE ability_score_sets (
    id integer NOT NULL,
    str integer NOT NULL,
    dex integer NOT NULL,
    con integer NOT NULL,
    "int" integer NOT NULL,
    wis integer NOT NULL,
    cha integer NOT NULL
);


ALTER TABLE ability_score_sets OWNER TO pathfinder_user;

--
-- Name: ability_score_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE ability_score_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ability_score_sets_id_seq OWNER TO pathfinder_user;

--
-- Name: ability_score_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE ability_score_sets_id_seq OWNED BY ability_score_sets.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE characters (
    id integer NOT NULL,
    name text NOT NULL,
    ability_score_set_id integer NOT NULL,
    alignment_order text NOT NULL,
    alignment_morality text NOT NULL,
    player_name text NOT NULL,
    class text NOT NULL,
    deity text,
    race text NOT NULL
);


ALTER TABLE characters OWNER TO pathfinder_user;

--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE characters_id_seq OWNER TO pathfinder_user;

--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE characters_id_seq OWNED BY characters.id;


--
-- Name: ability_score_sets id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY ability_score_sets ALTER COLUMN id SET DEFAULT nextval('ability_score_sets_id_seq'::regclass);


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY characters ALTER COLUMN id SET DEFAULT nextval('characters_id_seq'::regclass);


--
-- Name: ability_score_sets ability_score_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY ability_score_sets
    ADD CONSTRAINT ability_score_sets_pkey PRIMARY KEY (id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: characters characters_ability_score_set_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_ability_score_set_id_fkey FOREIGN KEY (ability_score_set_id) REFERENCES ability_score_sets(id);


--
-- PostgreSQL database dump complete
--

