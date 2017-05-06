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

SET search_path = public, pg_catalog;

--
-- Data for Name: ability_score_sets; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY ability_score_sets (id, str, dex, con, "int", wis, cha) FROM stdin;
1	12	15	18	14	10	8
\.


--
-- Name: ability_score_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('ability_score_sets_id_seq', 3, true);


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY characters (id, name, ability_score_set_id, alignment_order, alignment_morality, player_name) FROM stdin;
1	IDRIGOTH	1	neutral	good	Quinten
\.


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('characters_id_seq', 3, true);


--
-- PostgreSQL database dump complete
--

