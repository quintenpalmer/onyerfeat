--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.3
-- Dumped by pg_dump version 9.6.3

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
-- Name: armor_pieces; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE armor_pieces (
    id integer NOT NULL,
    armor_class text NOT NULL,
    name text NOT NULL,
    armor_bonus integer NOT NULL,
    max_dex_bonus integer NOT NULL,
    armor_check_penalty integer NOT NULL,
    arcane_spell_failure_chance integer NOT NULL,
    fast_speed integer NOT NULL,
    slow_speed integer NOT NULL,
    medium_weight integer NOT NULL
);


ALTER TABLE armor_pieces OWNER TO pathfinder_user;

--
-- Name: armor_pieces_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE armor_pieces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE armor_pieces_id_seq OWNER TO pathfinder_user;

--
-- Name: armor_pieces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE armor_pieces_id_seq OWNED BY armor_pieces.id;


--
-- Name: character_skill_choices; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE character_skill_choices (
    id integer NOT NULL,
    character_id integer NOT NULL,
    skill_id integer NOT NULL,
    count integer NOT NULL
);


ALTER TABLE character_skill_choices OWNER TO pathfinder_user;

--
-- Name: character_skill_choices_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE character_skill_choices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE character_skill_choices_id_seq OWNER TO pathfinder_user;

--
-- Name: character_skill_choices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE character_skill_choices_id_seq OWNED BY character_skill_choices.id;


--
-- Name: character_sub_skill_choices; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE character_sub_skill_choices (
    id integer NOT NULL,
    character_id integer NOT NULL,
    sub_skill_id integer NOT NULL,
    count integer NOT NULL
);


ALTER TABLE character_sub_skill_choices OWNER TO pathfinder_user;

--
-- Name: character_sub_skill_choices_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE character_sub_skill_choices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE character_sub_skill_choices_id_seq OWNER TO pathfinder_user;

--
-- Name: character_sub_skill_choices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE character_sub_skill_choices_id_seq OWNED BY character_sub_skill_choices.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE characters (
    id integer NOT NULL,
    player_name text NOT NULL,
    creature_id integer NOT NULL,
    class_id integer NOT NULL
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
-- Name: class_skill_constructors; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE class_skill_constructors (
    id integer NOT NULL,
    class_id integer NOT NULL,
    skill_constructor_id integer NOT NULL
);


ALTER TABLE class_skill_constructors OWNER TO pathfinder_user;

--
-- Name: class_skill_constructors_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE class_skill_constructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE class_skill_constructors_id_seq OWNER TO pathfinder_user;

--
-- Name: class_skill_constructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE class_skill_constructors_id_seq OWNED BY class_skill_constructors.id;


--
-- Name: class_skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE class_skills (
    id integer NOT NULL,
    class_id integer NOT NULL,
    skill_id integer NOT NULL
);


ALTER TABLE class_skills OWNER TO pathfinder_user;

--
-- Name: class_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE class_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE class_skills_id_seq OWNER TO pathfinder_user;

--
-- Name: class_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE class_skills_id_seq OWNED BY class_skills.id;


--
-- Name: class_sub_skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE class_sub_skills (
    id integer NOT NULL,
    class_id integer NOT NULL,
    sub_skill_id integer NOT NULL
);


ALTER TABLE class_sub_skills OWNER TO pathfinder_user;

--
-- Name: class_sub_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE class_sub_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE class_sub_skills_id_seq OWNER TO pathfinder_user;

--
-- Name: class_sub_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE class_sub_skills_id_seq OWNED BY class_sub_skills.id;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE classes (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE classes OWNER TO pathfinder_user;

--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE classes_id_seq OWNER TO pathfinder_user;

--
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE classes_id_seq OWNED BY classes.id;


--
-- Name: creature_armor_pieces; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE creature_armor_pieces (
    id integer NOT NULL,
    creature_id integer NOT NULL,
    armor_piece_id integer NOT NULL
);


ALTER TABLE creature_armor_pieces OWNER TO pathfinder_user;

--
-- Name: creature_armor_pieces_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE creature_armor_pieces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE creature_armor_pieces_id_seq OWNER TO pathfinder_user;

--
-- Name: creature_armor_pieces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE creature_armor_pieces_id_seq OWNED BY creature_armor_pieces.id;


--
-- Name: creatures; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE creatures (
    id integer NOT NULL,
    name text NOT NULL,
    ability_score_set_id integer NOT NULL,
    alignment_order text NOT NULL,
    alignment_morality text NOT NULL,
    race text NOT NULL,
    deity text,
    age integer NOT NULL,
    size text NOT NULL,
    max_hit_points integer NOT NULL,
    current_hit_points integer NOT NULL,
    nonlethal_damage integer NOT NULL,
    base_attack_bonus integer NOT NULL
);


ALTER TABLE creatures OWNER TO pathfinder_user;

--
-- Name: creatures_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE creatures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE creatures_id_seq OWNER TO pathfinder_user;

--
-- Name: creatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE creatures_id_seq OWNED BY creatures.id;


--
-- Name: shields; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE shields (
    id integer NOT NULL,
    name text NOT NULL,
    ac_bonus integer NOT NULL,
    max_dex integer,
    skill_penalty integer NOT NULL,
    arcane_spell_failure_chance integer NOT NULL,
    weight integer NOT NULL
);


ALTER TABLE shields OWNER TO pathfinder_user;

--
-- Name: shields_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE shields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shields_id_seq OWNER TO pathfinder_user;

--
-- Name: shields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE shields_id_seq OWNED BY shields.id;


--
-- Name: skill_constructors; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE skill_constructors (
    id integer NOT NULL,
    name text NOT NULL,
    trained_only boolean NOT NULL,
    ability text NOT NULL
);


ALTER TABLE skill_constructors OWNER TO pathfinder_user;

--
-- Name: skill_constructors_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE skill_constructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skill_constructors_id_seq OWNER TO pathfinder_user;

--
-- Name: skill_constructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE skill_constructors_id_seq OWNED BY skill_constructors.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE skills (
    id integer NOT NULL,
    name text NOT NULL,
    trained_only boolean NOT NULL,
    ability text NOT NULL
);


ALTER TABLE skills OWNER TO pathfinder_user;

--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE skills_id_seq OWNER TO pathfinder_user;

--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE skills_id_seq OWNED BY skills.id;


--
-- Name: sub_skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE sub_skills (
    id integer NOT NULL,
    name text NOT NULL,
    skill_constructor_id integer NOT NULL
);


ALTER TABLE sub_skills OWNER TO pathfinder_user;

--
-- Name: sub_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE sub_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE sub_skills_id_seq OWNER TO pathfinder_user;

--
-- Name: sub_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE sub_skills_id_seq OWNED BY sub_skills.id;


--
-- Name: ability_score_sets id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY ability_score_sets ALTER COLUMN id SET DEFAULT nextval('ability_score_sets_id_seq'::regclass);


--
-- Name: armor_pieces id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY armor_pieces ALTER COLUMN id SET DEFAULT nextval('armor_pieces_id_seq'::regclass);


--
-- Name: character_skill_choices id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_skill_choices ALTER COLUMN id SET DEFAULT nextval('character_skill_choices_id_seq'::regclass);


--
-- Name: character_sub_skill_choices id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_sub_skill_choices ALTER COLUMN id SET DEFAULT nextval('character_sub_skill_choices_id_seq'::regclass);


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY characters ALTER COLUMN id SET DEFAULT nextval('characters_id_seq'::regclass);


--
-- Name: class_skill_constructors id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skill_constructors ALTER COLUMN id SET DEFAULT nextval('class_skill_constructors_id_seq'::regclass);


--
-- Name: class_skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skills ALTER COLUMN id SET DEFAULT nextval('class_skills_id_seq'::regclass);


--
-- Name: class_sub_skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_sub_skills ALTER COLUMN id SET DEFAULT nextval('class_sub_skills_id_seq'::regclass);


--
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY classes ALTER COLUMN id SET DEFAULT nextval('classes_id_seq'::regclass);


--
-- Name: creature_armor_pieces id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creature_armor_pieces ALTER COLUMN id SET DEFAULT nextval('creature_armor_pieces_id_seq'::regclass);


--
-- Name: creatures id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creatures ALTER COLUMN id SET DEFAULT nextval('creatures_id_seq'::regclass);


--
-- Name: shields id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY shields ALTER COLUMN id SET DEFAULT nextval('shields_id_seq'::regclass);


--
-- Name: skill_constructors id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY skill_constructors ALTER COLUMN id SET DEFAULT nextval('skill_constructors_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY skills ALTER COLUMN id SET DEFAULT nextval('skills_id_seq'::regclass);


--
-- Name: sub_skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY sub_skills ALTER COLUMN id SET DEFAULT nextval('sub_skills_id_seq'::regclass);


--
-- Name: ability_score_sets ability_score_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY ability_score_sets
    ADD CONSTRAINT ability_score_sets_pkey PRIMARY KEY (id);


--
-- Name: armor_pieces armor_pieces_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY armor_pieces
    ADD CONSTRAINT armor_pieces_pkey PRIMARY KEY (id);


--
-- Name: character_skill_choices character_skill_choices_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_skill_choices
    ADD CONSTRAINT character_skill_choices_pkey PRIMARY KEY (id);


--
-- Name: character_skill_choices character_skills_unique_choices; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_skill_choices
    ADD CONSTRAINT character_skills_unique_choices UNIQUE (character_id, skill_id);


--
-- Name: character_sub_skill_choices character_sub_skill_choices_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_choices_pkey PRIMARY KEY (id);


--
-- Name: character_sub_skill_choices character_sub_skill_unique_choices; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_unique_choices UNIQUE (character_id, sub_skill_id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: class_skill_constructors class_skill_constructor_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skill_constructors
    ADD CONSTRAINT class_skill_constructor_unique UNIQUE (class_id, skill_constructor_id);


--
-- Name: class_skill_constructors class_skill_constructors_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skill_constructors
    ADD CONSTRAINT class_skill_constructors_pkey PRIMARY KEY (id);


--
-- Name: class_skills class_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skills
    ADD CONSTRAINT class_skills_pkey PRIMARY KEY (id);


--
-- Name: class_skills class_skills_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skills
    ADD CONSTRAINT class_skills_unique UNIQUE (class_id, skill_id);


--
-- Name: class_sub_skills class_sub_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_sub_skills
    ADD CONSTRAINT class_sub_skills_pkey PRIMARY KEY (id);


--
-- Name: class_sub_skills class_sub_skills_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_sub_skills
    ADD CONSTRAINT class_sub_skills_unique UNIQUE (class_id, sub_skill_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: creature_armor_pieces creature_armor_pieces_creature_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creature_armor_pieces
    ADD CONSTRAINT creature_armor_pieces_creature_unique UNIQUE (creature_id);


--
-- Name: creature_armor_pieces creature_armor_pieces_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creature_armor_pieces
    ADD CONSTRAINT creature_armor_pieces_pkey PRIMARY KEY (id);


--
-- Name: creatures creatures_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creatures
    ADD CONSTRAINT creatures_pkey PRIMARY KEY (id);


--
-- Name: shields shields_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY shields
    ADD CONSTRAINT shields_pkey PRIMARY KEY (id);


--
-- Name: skill_constructors skill_constructors_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY skill_constructors
    ADD CONSTRAINT skill_constructors_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: sub_skills sub_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY sub_skills
    ADD CONSTRAINT sub_skills_pkey PRIMARY KEY (id);


--
-- Name: characters character_class_id; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT character_class_id FOREIGN KEY (class_id) REFERENCES classes(id);


--
-- Name: characters character_creature_id; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY characters
    ADD CONSTRAINT character_creature_id FOREIGN KEY (creature_id) REFERENCES creatures(id);


--
-- Name: character_skill_choices character_skill_choices_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_skill_choices
    ADD CONSTRAINT character_skill_choices_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id);


--
-- Name: character_skill_choices character_skill_choices_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_skill_choices
    ADD CONSTRAINT character_skill_choices_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skills(id);


--
-- Name: character_sub_skill_choices character_sub_skill_choices_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_choices_character_id_fkey FOREIGN KEY (character_id) REFERENCES characters(id);


--
-- Name: character_sub_skill_choices character_sub_skill_choices_sub_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_choices_sub_skill_id_fkey FOREIGN KEY (sub_skill_id) REFERENCES sub_skills(id);


--
-- Name: class_skill_constructors class_skill_constructors_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skill_constructors
    ADD CONSTRAINT class_skill_constructors_class_id_fkey FOREIGN KEY (class_id) REFERENCES classes(id);


--
-- Name: class_skill_constructors class_skill_constructors_skill_constructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skill_constructors
    ADD CONSTRAINT class_skill_constructors_skill_constructor_id_fkey FOREIGN KEY (skill_constructor_id) REFERENCES skill_constructors(id);


--
-- Name: class_skills class_skills_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skills
    ADD CONSTRAINT class_skills_class_id_fkey FOREIGN KEY (class_id) REFERENCES classes(id);


--
-- Name: class_skills class_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_skills
    ADD CONSTRAINT class_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES skills(id);


--
-- Name: class_sub_skills class_sub_skills_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_sub_skills
    ADD CONSTRAINT class_sub_skills_class_id_fkey FOREIGN KEY (class_id) REFERENCES classes(id);


--
-- Name: class_sub_skills class_sub_skills_sub_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY class_sub_skills
    ADD CONSTRAINT class_sub_skills_sub_skill_id_fkey FOREIGN KEY (sub_skill_id) REFERENCES sub_skills(id);


--
-- Name: creature_armor_pieces creature_armor_pieces_armor_piece_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creature_armor_pieces
    ADD CONSTRAINT creature_armor_pieces_armor_piece_id_fkey FOREIGN KEY (armor_piece_id) REFERENCES armor_pieces(id);


--
-- Name: creature_armor_pieces creature_armor_pieces_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creature_armor_pieces
    ADD CONSTRAINT creature_armor_pieces_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES creatures(id);


--
-- Name: creatures creatures_ability_score_set_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY creatures
    ADD CONSTRAINT creatures_ability_score_set_id_fkey FOREIGN KEY (ability_score_set_id) REFERENCES ability_score_sets(id);


--
-- Name: sub_skills sub_skills_skill_constructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY sub_skills
    ADD CONSTRAINT sub_skills_skill_constructor_id_fkey FOREIGN KEY (skill_constructor_id) REFERENCES skill_constructors(id);


--
-- PostgreSQL database dump complete
--

