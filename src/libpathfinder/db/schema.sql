--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.8
-- Dumped by pg_dump version 9.6.8

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
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


--
-- Name: critical_damage; Type: TYPE; Schema: public; Owner: pathfinder_user
--

CREATE TYPE public.critical_damage AS (
	required_roll integer,
	multiplier integer
);


ALTER TYPE public.critical_damage OWNER TO pathfinder_user;

--
-- Name: dice_damage; Type: TYPE; Schema: public; Owner: pathfinder_user
--

CREATE TYPE public.dice_damage AS (
	num_dice integer,
	die_size integer
);


ALTER TYPE public.dice_damage OWNER TO pathfinder_user;

--
-- Name: physical_damage_type; Type: TYPE; Schema: public; Owner: pathfinder_user
--

CREATE TYPE public.physical_damage_type AS (
	bludgeoning boolean,
	piercing boolean,
	slashing boolean,
	and_together boolean
);


ALTER TYPE public.physical_damage_type OWNER TO pathfinder_user;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ability_score_sets; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.ability_score_sets (
    id integer NOT NULL,
    str integer NOT NULL,
    dex integer NOT NULL,
    con integer NOT NULL,
    "int" integer NOT NULL,
    wis integer NOT NULL,
    cha integer NOT NULL
);


ALTER TABLE public.ability_score_sets OWNER TO pathfinder_user;

--
-- Name: ability_score_sets_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.ability_score_sets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ability_score_sets_id_seq OWNER TO pathfinder_user;

--
-- Name: ability_score_sets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.ability_score_sets_id_seq OWNED BY public.ability_score_sets.id;


--
-- Name: armor_piece_instances; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.armor_piece_instances (
    id integer NOT NULL,
    armor_piece_id integer NOT NULL,
    is_masterwork boolean NOT NULL,
    special text
);


ALTER TABLE public.armor_piece_instances OWNER TO pathfinder_user;

--
-- Name: armor_piece_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.armor_piece_instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.armor_piece_instances_id_seq OWNER TO pathfinder_user;

--
-- Name: armor_piece_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.armor_piece_instances_id_seq OWNED BY public.armor_piece_instances.id;


--
-- Name: armor_pieces; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.armor_pieces (
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


ALTER TABLE public.armor_pieces OWNER TO pathfinder_user;

--
-- Name: armor_pieces_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.armor_pieces_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.armor_pieces_id_seq OWNER TO pathfinder_user;

--
-- Name: armor_pieces_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.armor_pieces_id_seq OWNED BY public.armor_pieces.id;


--
-- Name: aura_magnitudes; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.aura_magnitudes (
    id integer NOT NULL,
    magnitude text NOT NULL
);


ALTER TABLE public.aura_magnitudes OWNER TO pathfinder_user;

--
-- Name: aura_magnitudes_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.aura_magnitudes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.aura_magnitudes_id_seq OWNER TO pathfinder_user;

--
-- Name: aura_magnitudes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.aura_magnitudes_id_seq OWNED BY public.aura_magnitudes.id;


--
-- Name: aura_schools; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.aura_schools (
    id integer NOT NULL,
    school text NOT NULL
);


ALTER TABLE public.aura_schools OWNER TO pathfinder_user;

--
-- Name: aura_schools_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.aura_schools_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.aura_schools_id_seq OWNER TO pathfinder_user;

--
-- Name: aura_schools_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.aura_schools_id_seq OWNED BY public.aura_schools.id;


--
-- Name: character_skill_choices; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.character_skill_choices (
    id integer NOT NULL,
    character_id integer NOT NULL,
    skill_id integer NOT NULL,
    count integer NOT NULL
);


ALTER TABLE public.character_skill_choices OWNER TO pathfinder_user;

--
-- Name: character_skill_choices_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.character_skill_choices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.character_skill_choices_id_seq OWNER TO pathfinder_user;

--
-- Name: character_skill_choices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.character_skill_choices_id_seq OWNED BY public.character_skill_choices.id;


--
-- Name: character_sub_skill_choices; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.character_sub_skill_choices (
    id integer NOT NULL,
    character_id integer NOT NULL,
    sub_skill_id integer NOT NULL,
    count integer NOT NULL
);


ALTER TABLE public.character_sub_skill_choices OWNER TO pathfinder_user;

--
-- Name: character_sub_skill_choices_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.character_sub_skill_choices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.character_sub_skill_choices_id_seq OWNER TO pathfinder_user;

--
-- Name: character_sub_skill_choices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.character_sub_skill_choices_id_seq OWNED BY public.character_sub_skill_choices.id;


--
-- Name: characters; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.characters (
    id integer NOT NULL,
    player_name text NOT NULL,
    creature_id integer NOT NULL,
    class_id integer NOT NULL
);


ALTER TABLE public.characters OWNER TO pathfinder_user;

--
-- Name: characters_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.characters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.characters_id_seq OWNER TO pathfinder_user;

--
-- Name: characters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.characters_id_seq OWNED BY public.characters.id;


--
-- Name: class_armor_proficiencies; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.class_armor_proficiencies (
    id integer NOT NULL,
    class_id integer NOT NULL,
    level integer NOT NULL,
    armor_check_penalty_reduction integer NOT NULL,
    max_dex_bonus integer NOT NULL
);


ALTER TABLE public.class_armor_proficiencies OWNER TO pathfinder_user;

--
-- Name: class_armor_proficiencies_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.class_armor_proficiencies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_armor_proficiencies_id_seq OWNER TO pathfinder_user;

--
-- Name: class_armor_proficiencies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.class_armor_proficiencies_id_seq OWNED BY public.class_armor_proficiencies.id;


--
-- Name: class_bonuses; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.class_bonuses (
    id integer NOT NULL,
    class_id integer NOT NULL,
    level integer NOT NULL,
    fortitude integer NOT NULL,
    reflex integer NOT NULL,
    will integer NOT NULL,
    cha_bonus boolean DEFAULT false NOT NULL
);


ALTER TABLE public.class_bonuses OWNER TO pathfinder_user;

--
-- Name: class_saving_throws_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.class_saving_throws_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_saving_throws_id_seq OWNER TO pathfinder_user;

--
-- Name: class_saving_throws_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.class_saving_throws_id_seq OWNED BY public.class_bonuses.id;


--
-- Name: class_skill_constructors; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.class_skill_constructors (
    id integer NOT NULL,
    class_id integer NOT NULL,
    skill_constructor_id integer NOT NULL
);


ALTER TABLE public.class_skill_constructors OWNER TO pathfinder_user;

--
-- Name: class_skill_constructors_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.class_skill_constructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_skill_constructors_id_seq OWNER TO pathfinder_user;

--
-- Name: class_skill_constructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.class_skill_constructors_id_seq OWNED BY public.class_skill_constructors.id;


--
-- Name: class_skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.class_skills (
    id integer NOT NULL,
    class_id integer NOT NULL,
    skill_id integer NOT NULL
);


ALTER TABLE public.class_skills OWNER TO pathfinder_user;

--
-- Name: class_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.class_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_skills_id_seq OWNER TO pathfinder_user;

--
-- Name: class_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.class_skills_id_seq OWNED BY public.class_skills.id;


--
-- Name: class_sub_skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.class_sub_skills (
    id integer NOT NULL,
    class_id integer NOT NULL,
    sub_skill_id integer NOT NULL
);


ALTER TABLE public.class_sub_skills OWNER TO pathfinder_user;

--
-- Name: class_sub_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.class_sub_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.class_sub_skills_id_seq OWNER TO pathfinder_user;

--
-- Name: class_sub_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.class_sub_skills_id_seq OWNED BY public.class_sub_skills.id;


--
-- Name: classes; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.classes (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.classes OWNER TO pathfinder_user;

--
-- Name: classes_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.classes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.classes_id_seq OWNER TO pathfinder_user;

--
-- Name: classes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.classes_id_seq OWNED BY public.classes.id;


--
-- Name: creature_items; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.creature_items (
    id integer NOT NULL,
    creature_id integer NOT NULL,
    item_id integer NOT NULL,
    count integer NOT NULL
);


ALTER TABLE public.creature_items OWNER TO pathfinder_user;

--
-- Name: creature_items_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.creature_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.creature_items_id_seq OWNER TO pathfinder_user;

--
-- Name: creature_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.creature_items_id_seq OWNED BY public.creature_items.id;


--
-- Name: creature_languages; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.creature_languages (
    id integer NOT NULL,
    creature_id integer NOT NULL,
    language_id integer NOT NULL
);


ALTER TABLE public.creature_languages OWNER TO pathfinder_user;

--
-- Name: creature_languages_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.creature_languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.creature_languages_id_seq OWNER TO pathfinder_user;

--
-- Name: creature_languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.creature_languages_id_seq OWNED BY public.creature_languages.id;


--
-- Name: creature_shields; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.creature_shields (
    id integer NOT NULL,
    creature_id integer NOT NULL,
    shield_id integer NOT NULL,
    has_spikes boolean NOT NULL,
    is_masterwork boolean NOT NULL,
    special text
);


ALTER TABLE public.creature_shields OWNER TO pathfinder_user;

--
-- Name: creature_shields_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.creature_shields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.creature_shields_id_seq OWNER TO pathfinder_user;

--
-- Name: creature_shields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.creature_shields_id_seq OWNED BY public.creature_shields.id;


--
-- Name: creature_weapons; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.creature_weapons (
    id integer NOT NULL,
    creature_id integer NOT NULL,
    weapon_instance_id integer NOT NULL
);


ALTER TABLE public.creature_weapons OWNER TO pathfinder_user;

--
-- Name: creature_weapons_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.creature_weapons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.creature_weapons_id_seq OWNER TO pathfinder_user;

--
-- Name: creature_weapons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.creature_weapons_id_seq OWNED BY public.creature_weapons.id;


--
-- Name: creatures; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.creatures (
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
    base_attack_bonus integer NOT NULL,
    level integer NOT NULL,
    armor_piece_instance_id integer NOT NULL
);


ALTER TABLE public.creatures OWNER TO pathfinder_user;

--
-- Name: creatures_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.creatures_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.creatures_id_seq OWNER TO pathfinder_user;

--
-- Name: creatures_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.creatures_id_seq OWNED BY public.creatures.id;


--
-- Name: item_body_slots; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.item_body_slots (
    id integer NOT NULL,
    name text NOT NULL,
    max_count_in_slot integer NOT NULL,
    examples text NOT NULL
);


ALTER TABLE public.item_body_slots OWNER TO pathfinder_user;

--
-- Name: item_body_slots_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.item_body_slots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.item_body_slots_id_seq OWNER TO pathfinder_user;

--
-- Name: item_body_slots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.item_body_slots_id_seq OWNED BY public.item_body_slots.id;


--
-- Name: items; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.items (
    id integer NOT NULL,
    name text NOT NULL,
    description text NOT NULL
);


ALTER TABLE public.items OWNER TO pathfinder_user;

--
-- Name: items_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.items_id_seq OWNER TO pathfinder_user;

--
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.items_id_seq OWNED BY public.items.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.languages (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.languages OWNER TO pathfinder_user;

--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.languages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.languages_id_seq OWNER TO pathfinder_user;

--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: shield_damage; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.shield_damage (
    id integer NOT NULL,
    size_style text NOT NULL,
    spiked boolean NOT NULL,
    small_damage public.dice_damage NOT NULL,
    medium_damage public.dice_damage NOT NULL,
    critical public.critical_damage NOT NULL,
    range integer,
    damage_type public.physical_damage_type NOT NULL
);


ALTER TABLE public.shield_damage OWNER TO pathfinder_user;

--
-- Name: shield_damage_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.shield_damage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shield_damage_id_seq OWNER TO pathfinder_user;

--
-- Name: shield_damage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.shield_damage_id_seq OWNED BY public.shield_damage.id;


--
-- Name: shields; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.shields (
    id integer NOT NULL,
    name text NOT NULL,
    ac_bonus integer NOT NULL,
    max_dex integer,
    skill_penalty integer NOT NULL,
    arcane_spell_failure_chance integer NOT NULL,
    weight integer NOT NULL,
    size_style text
);


ALTER TABLE public.shields OWNER TO pathfinder_user;

--
-- Name: shields_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.shields_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shields_id_seq OWNER TO pathfinder_user;

--
-- Name: shields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.shields_id_seq OWNED BY public.shields.id;


--
-- Name: skill_constructors; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.skill_constructors (
    id integer NOT NULL,
    name text NOT NULL,
    trained_only boolean NOT NULL,
    ability text NOT NULL
);


ALTER TABLE public.skill_constructors OWNER TO pathfinder_user;

--
-- Name: skill_constructors_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.skill_constructors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.skill_constructors_id_seq OWNER TO pathfinder_user;

--
-- Name: skill_constructors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.skill_constructors_id_seq OWNED BY public.skill_constructors.id;


--
-- Name: skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.skills (
    id integer NOT NULL,
    name text NOT NULL,
    trained_only boolean NOT NULL,
    ability text NOT NULL
);


ALTER TABLE public.skills OWNER TO pathfinder_user;

--
-- Name: skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.skills_id_seq OWNER TO pathfinder_user;

--
-- Name: skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.skills_id_seq OWNED BY public.skills.id;


--
-- Name: sub_skills; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.sub_skills (
    id integer NOT NULL,
    name text NOT NULL,
    skill_constructor_id integer NOT NULL
);


ALTER TABLE public.sub_skills OWNER TO pathfinder_user;

--
-- Name: sub_skills_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.sub_skills_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sub_skills_id_seq OWNER TO pathfinder_user;

--
-- Name: sub_skills_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.sub_skills_id_seq OWNED BY public.sub_skills.id;


--
-- Name: weapon_instances; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.weapon_instances (
    id integer NOT NULL,
    weapon_id integer NOT NULL,
    name text,
    is_masterwork boolean NOT NULL,
    special text
);


ALTER TABLE public.weapon_instances OWNER TO pathfinder_user;

--
-- Name: weapon_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.weapon_instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.weapon_instances_id_seq OWNER TO pathfinder_user;

--
-- Name: weapon_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.weapon_instances_id_seq OWNED BY public.weapon_instances.id;


--
-- Name: weapons; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.weapons (
    id integer NOT NULL,
    name text NOT NULL,
    training_type text NOT NULL,
    size_style text NOT NULL,
    cost integer NOT NULL,
    small_damage public.dice_damage NOT NULL,
    medium_damage public.dice_damage NOT NULL,
    critical public.critical_damage NOT NULL,
    range integer,
    weight integer NOT NULL,
    damage_type public.physical_damage_type NOT NULL
);


ALTER TABLE public.weapons OWNER TO pathfinder_user;

--
-- Name: weapons_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.weapons_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.weapons_id_seq OWNER TO pathfinder_user;

--
-- Name: weapons_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.weapons_id_seq OWNED BY public.weapons.id;


--
-- Name: wondrous_item_auras; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.wondrous_item_auras (
    id integer NOT NULL,
    wondrous_item_id integer NOT NULL,
    aura_magnitude_id integer NOT NULL,
    aura_school_id integer NOT NULL
);


ALTER TABLE public.wondrous_item_auras OWNER TO pathfinder_user;

--
-- Name: wondrous_item_auras_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.wondrous_item_auras_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wondrous_item_auras_id_seq OWNER TO pathfinder_user;

--
-- Name: wondrous_item_auras_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.wondrous_item_auras_id_seq OWNED BY public.wondrous_item_auras.id;


--
-- Name: wondrous_items; Type: TABLE; Schema: public; Owner: pathfinder_user
--

CREATE TABLE public.wondrous_items (
    id integer NOT NULL,
    name text NOT NULL,
    caster_level integer NOT NULL,
    slot_id integer,
    price integer NOT NULL,
    weight integer NOT NULL,
    description text NOT NULL,
    construction_requirements_text text NOT NULL
);


ALTER TABLE public.wondrous_items OWNER TO pathfinder_user;

--
-- Name: wondrous_items_id_seq; Type: SEQUENCE; Schema: public; Owner: pathfinder_user
--

CREATE SEQUENCE public.wondrous_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.wondrous_items_id_seq OWNER TO pathfinder_user;

--
-- Name: wondrous_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: pathfinder_user
--

ALTER SEQUENCE public.wondrous_items_id_seq OWNED BY public.wondrous_items.id;


--
-- Name: ability_score_sets id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.ability_score_sets ALTER COLUMN id SET DEFAULT nextval('public.ability_score_sets_id_seq'::regclass);


--
-- Name: armor_piece_instances id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.armor_piece_instances ALTER COLUMN id SET DEFAULT nextval('public.armor_piece_instances_id_seq'::regclass);


--
-- Name: armor_pieces id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.armor_pieces ALTER COLUMN id SET DEFAULT nextval('public.armor_pieces_id_seq'::regclass);


--
-- Name: aura_magnitudes id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.aura_magnitudes ALTER COLUMN id SET DEFAULT nextval('public.aura_magnitudes_id_seq'::regclass);


--
-- Name: aura_schools id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.aura_schools ALTER COLUMN id SET DEFAULT nextval('public.aura_schools_id_seq'::regclass);


--
-- Name: character_skill_choices id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_skill_choices ALTER COLUMN id SET DEFAULT nextval('public.character_skill_choices_id_seq'::regclass);


--
-- Name: character_sub_skill_choices id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_sub_skill_choices ALTER COLUMN id SET DEFAULT nextval('public.character_sub_skill_choices_id_seq'::regclass);


--
-- Name: characters id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.characters ALTER COLUMN id SET DEFAULT nextval('public.characters_id_seq'::regclass);


--
-- Name: class_armor_proficiencies id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_armor_proficiencies ALTER COLUMN id SET DEFAULT nextval('public.class_armor_proficiencies_id_seq'::regclass);


--
-- Name: class_bonuses id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_bonuses ALTER COLUMN id SET DEFAULT nextval('public.class_saving_throws_id_seq'::regclass);


--
-- Name: class_skill_constructors id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skill_constructors ALTER COLUMN id SET DEFAULT nextval('public.class_skill_constructors_id_seq'::regclass);


--
-- Name: class_skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skills ALTER COLUMN id SET DEFAULT nextval('public.class_skills_id_seq'::regclass);


--
-- Name: class_sub_skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_sub_skills ALTER COLUMN id SET DEFAULT nextval('public.class_sub_skills_id_seq'::regclass);


--
-- Name: classes id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.classes ALTER COLUMN id SET DEFAULT nextval('public.classes_id_seq'::regclass);


--
-- Name: creature_items id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_items ALTER COLUMN id SET DEFAULT nextval('public.creature_items_id_seq'::regclass);


--
-- Name: creature_languages id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_languages ALTER COLUMN id SET DEFAULT nextval('public.creature_languages_id_seq'::regclass);


--
-- Name: creature_shields id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_shields ALTER COLUMN id SET DEFAULT nextval('public.creature_shields_id_seq'::regclass);


--
-- Name: creature_weapons id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_weapons ALTER COLUMN id SET DEFAULT nextval('public.creature_weapons_id_seq'::regclass);


--
-- Name: creatures id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creatures ALTER COLUMN id SET DEFAULT nextval('public.creatures_id_seq'::regclass);


--
-- Name: item_body_slots id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.item_body_slots ALTER COLUMN id SET DEFAULT nextval('public.item_body_slots_id_seq'::regclass);


--
-- Name: items id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.items ALTER COLUMN id SET DEFAULT nextval('public.items_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: shield_damage id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.shield_damage ALTER COLUMN id SET DEFAULT nextval('public.shield_damage_id_seq'::regclass);


--
-- Name: shields id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.shields ALTER COLUMN id SET DEFAULT nextval('public.shields_id_seq'::regclass);


--
-- Name: skill_constructors id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.skill_constructors ALTER COLUMN id SET DEFAULT nextval('public.skill_constructors_id_seq'::regclass);


--
-- Name: skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.skills ALTER COLUMN id SET DEFAULT nextval('public.skills_id_seq'::regclass);


--
-- Name: sub_skills id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.sub_skills ALTER COLUMN id SET DEFAULT nextval('public.sub_skills_id_seq'::regclass);


--
-- Name: weapon_instances id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.weapon_instances ALTER COLUMN id SET DEFAULT nextval('public.weapon_instances_id_seq'::regclass);


--
-- Name: weapons id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.weapons ALTER COLUMN id SET DEFAULT nextval('public.weapons_id_seq'::regclass);


--
-- Name: wondrous_item_auras id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.wondrous_item_auras ALTER COLUMN id SET DEFAULT nextval('public.wondrous_item_auras_id_seq'::regclass);


--
-- Name: wondrous_items id; Type: DEFAULT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.wondrous_items ALTER COLUMN id SET DEFAULT nextval('public.wondrous_items_id_seq'::regclass);


--
-- Name: ability_score_sets ability_score_sets_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.ability_score_sets
    ADD CONSTRAINT ability_score_sets_pkey PRIMARY KEY (id);


--
-- Name: armor_piece_instances armor_piece_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.armor_piece_instances
    ADD CONSTRAINT armor_piece_instances_pkey PRIMARY KEY (id);


--
-- Name: armor_pieces armor_pieces_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.armor_pieces
    ADD CONSTRAINT armor_pieces_pkey PRIMARY KEY (id);


--
-- Name: aura_magnitudes aura_magnitudes_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.aura_magnitudes
    ADD CONSTRAINT aura_magnitudes_pkey PRIMARY KEY (id);


--
-- Name: aura_schools aura_schools_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.aura_schools
    ADD CONSTRAINT aura_schools_pkey PRIMARY KEY (id);


--
-- Name: character_skill_choices character_skill_choices_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_skill_choices
    ADD CONSTRAINT character_skill_choices_pkey PRIMARY KEY (id);


--
-- Name: character_skill_choices character_skills_unique_choices; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_skill_choices
    ADD CONSTRAINT character_skills_unique_choices UNIQUE (character_id, skill_id);


--
-- Name: character_sub_skill_choices character_sub_skill_choices_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_choices_pkey PRIMARY KEY (id);


--
-- Name: character_sub_skill_choices character_sub_skill_unique_choices; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_unique_choices UNIQUE (character_id, sub_skill_id);


--
-- Name: characters characters_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT characters_pkey PRIMARY KEY (id);


--
-- Name: class_armor_proficiencies class_armor_proficiencies_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_armor_proficiencies
    ADD CONSTRAINT class_armor_proficiencies_pkey PRIMARY KEY (id);


--
-- Name: class_bonuses class_saving_throws_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_bonuses
    ADD CONSTRAINT class_saving_throws_pkey PRIMARY KEY (id);


--
-- Name: class_skill_constructors class_skill_constructor_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skill_constructors
    ADD CONSTRAINT class_skill_constructor_unique UNIQUE (class_id, skill_constructor_id);


--
-- Name: class_skill_constructors class_skill_constructors_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skill_constructors
    ADD CONSTRAINT class_skill_constructors_pkey PRIMARY KEY (id);


--
-- Name: class_skills class_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skills
    ADD CONSTRAINT class_skills_pkey PRIMARY KEY (id);


--
-- Name: class_skills class_skills_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skills
    ADD CONSTRAINT class_skills_unique UNIQUE (class_id, skill_id);


--
-- Name: class_sub_skills class_sub_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_sub_skills
    ADD CONSTRAINT class_sub_skills_pkey PRIMARY KEY (id);


--
-- Name: class_sub_skills class_sub_skills_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_sub_skills
    ADD CONSTRAINT class_sub_skills_unique UNIQUE (class_id, sub_skill_id);


--
-- Name: classes classes_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.classes
    ADD CONSTRAINT classes_pkey PRIMARY KEY (id);


--
-- Name: creature_items creature_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_items
    ADD CONSTRAINT creature_items_pkey PRIMARY KEY (id);


--
-- Name: creature_languages creature_languages_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_languages
    ADD CONSTRAINT creature_languages_pkey PRIMARY KEY (id);


--
-- Name: creature_shields creature_shields_creature_unique; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_shields
    ADD CONSTRAINT creature_shields_creature_unique UNIQUE (creature_id);


--
-- Name: creature_shields creature_shields_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_shields
    ADD CONSTRAINT creature_shields_pkey PRIMARY KEY (id);


--
-- Name: creature_weapons creature_weapons_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_weapons
    ADD CONSTRAINT creature_weapons_pkey PRIMARY KEY (id);


--
-- Name: creatures creatures_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creatures
    ADD CONSTRAINT creatures_pkey PRIMARY KEY (id);


--
-- Name: item_body_slots item_body_slots_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.item_body_slots
    ADD CONSTRAINT item_body_slots_pkey PRIMARY KEY (id);


--
-- Name: items items_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: shield_damage shield_damage_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.shield_damage
    ADD CONSTRAINT shield_damage_pkey PRIMARY KEY (id);


--
-- Name: shields shields_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.shields
    ADD CONSTRAINT shields_pkey PRIMARY KEY (id);


--
-- Name: skill_constructors skill_constructors_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.skill_constructors
    ADD CONSTRAINT skill_constructors_pkey PRIMARY KEY (id);


--
-- Name: skills skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.skills
    ADD CONSTRAINT skills_pkey PRIMARY KEY (id);


--
-- Name: sub_skills sub_skills_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.sub_skills
    ADD CONSTRAINT sub_skills_pkey PRIMARY KEY (id);


--
-- Name: weapon_instances weapon_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.weapon_instances
    ADD CONSTRAINT weapon_instances_pkey PRIMARY KEY (id);


--
-- Name: weapons weapons_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.weapons
    ADD CONSTRAINT weapons_pkey PRIMARY KEY (id);


--
-- Name: wondrous_item_auras wondrous_item_auras_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.wondrous_item_auras
    ADD CONSTRAINT wondrous_item_auras_pkey PRIMARY KEY (id);


--
-- Name: wondrous_items wondrous_items_pkey; Type: CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.wondrous_items
    ADD CONSTRAINT wondrous_items_pkey PRIMARY KEY (id);


--
-- Name: armor_piece_instances armor_piece_instances_armor_piece_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.armor_piece_instances
    ADD CONSTRAINT armor_piece_instances_armor_piece_id_fkey FOREIGN KEY (armor_piece_id) REFERENCES public.armor_pieces(id);


--
-- Name: characters character_class_id; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT character_class_id FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: characters character_creature_id; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.characters
    ADD CONSTRAINT character_creature_id FOREIGN KEY (creature_id) REFERENCES public.creatures(id);


--
-- Name: character_skill_choices character_skill_choices_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_skill_choices
    ADD CONSTRAINT character_skill_choices_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);


--
-- Name: character_skill_choices character_skill_choices_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_skill_choices
    ADD CONSTRAINT character_skill_choices_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: character_sub_skill_choices character_sub_skill_choices_character_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_choices_character_id_fkey FOREIGN KEY (character_id) REFERENCES public.characters(id);


--
-- Name: character_sub_skill_choices character_sub_skill_choices_sub_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.character_sub_skill_choices
    ADD CONSTRAINT character_sub_skill_choices_sub_skill_id_fkey FOREIGN KEY (sub_skill_id) REFERENCES public.sub_skills(id);


--
-- Name: class_armor_proficiencies class_armor_proficiencies_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_armor_proficiencies
    ADD CONSTRAINT class_armor_proficiencies_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: class_bonuses class_saving_throws_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_bonuses
    ADD CONSTRAINT class_saving_throws_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: class_skill_constructors class_skill_constructors_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skill_constructors
    ADD CONSTRAINT class_skill_constructors_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: class_skill_constructors class_skill_constructors_skill_constructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skill_constructors
    ADD CONSTRAINT class_skill_constructors_skill_constructor_id_fkey FOREIGN KEY (skill_constructor_id) REFERENCES public.skill_constructors(id);


--
-- Name: class_skills class_skills_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skills
    ADD CONSTRAINT class_skills_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: class_skills class_skills_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_skills
    ADD CONSTRAINT class_skills_skill_id_fkey FOREIGN KEY (skill_id) REFERENCES public.skills(id);


--
-- Name: class_sub_skills class_sub_skills_class_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_sub_skills
    ADD CONSTRAINT class_sub_skills_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.classes(id);


--
-- Name: class_sub_skills class_sub_skills_sub_skill_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.class_sub_skills
    ADD CONSTRAINT class_sub_skills_sub_skill_id_fkey FOREIGN KEY (sub_skill_id) REFERENCES public.sub_skills(id);


--
-- Name: creature_items creature_items_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_items
    ADD CONSTRAINT creature_items_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id);


--
-- Name: creature_items creature_items_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_items
    ADD CONSTRAINT creature_items_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.items(id);


--
-- Name: creature_languages creature_languages_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_languages
    ADD CONSTRAINT creature_languages_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id);


--
-- Name: creature_languages creature_languages_language_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_languages
    ADD CONSTRAINT creature_languages_language_id_fkey FOREIGN KEY (language_id) REFERENCES public.languages(id);


--
-- Name: creature_shields creature_shields_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_shields
    ADD CONSTRAINT creature_shields_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id);


--
-- Name: creature_shields creature_shields_shield_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_shields
    ADD CONSTRAINT creature_shields_shield_id_fkey FOREIGN KEY (shield_id) REFERENCES public.shields(id);


--
-- Name: creature_weapons creature_weapons_creature_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_weapons
    ADD CONSTRAINT creature_weapons_creature_id_fkey FOREIGN KEY (creature_id) REFERENCES public.creatures(id);


--
-- Name: creature_weapons creature_weapons_weapon_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creature_weapons
    ADD CONSTRAINT creature_weapons_weapon_instance_id_fkey FOREIGN KEY (weapon_instance_id) REFERENCES public.weapon_instances(id);


--
-- Name: creatures creatures_ability_score_set_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creatures
    ADD CONSTRAINT creatures_ability_score_set_id_fkey FOREIGN KEY (ability_score_set_id) REFERENCES public.ability_score_sets(id);


--
-- Name: creatures creatures_armor_piece_instance_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.creatures
    ADD CONSTRAINT creatures_armor_piece_instance_id_fkey FOREIGN KEY (armor_piece_instance_id) REFERENCES public.armor_piece_instances(id);


--
-- Name: sub_skills sub_skills_skill_constructor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.sub_skills
    ADD CONSTRAINT sub_skills_skill_constructor_id_fkey FOREIGN KEY (skill_constructor_id) REFERENCES public.skill_constructors(id);


--
-- Name: weapon_instances weapon_instances_weapon_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.weapon_instances
    ADD CONSTRAINT weapon_instances_weapon_id_fkey FOREIGN KEY (weapon_id) REFERENCES public.weapons(id);


--
-- Name: wondrous_item_auras wondrous_item_auras_aura_magnitude_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.wondrous_item_auras
    ADD CONSTRAINT wondrous_item_auras_aura_magnitude_id_fkey FOREIGN KEY (aura_magnitude_id) REFERENCES public.aura_magnitudes(id);


--
-- Name: wondrous_item_auras wondrous_item_auras_aura_school_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.wondrous_item_auras
    ADD CONSTRAINT wondrous_item_auras_aura_school_id_fkey FOREIGN KEY (aura_school_id) REFERENCES public.aura_schools(id);


--
-- Name: wondrous_item_auras wondrous_item_auras_wondrous_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: pathfinder_user
--

ALTER TABLE ONLY public.wondrous_item_auras
    ADD CONSTRAINT wondrous_item_auras_wondrous_item_id_fkey FOREIGN KEY (wondrous_item_id) REFERENCES public.wondrous_items(id);


--
-- PostgreSQL database dump complete
--

