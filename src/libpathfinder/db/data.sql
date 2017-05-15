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
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY classes (id, name) FROM stdin;
1	fighter
\.


--
-- Data for Name: creatures; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY creatures (id, name, ability_score_set_id, alignment_order, alignment_morality, race, deity, age, size, max_hit_points, current_hit_points) FROM stdin;
1	IDRIGOTH	1	neutral	good	dwarf	\N	128	medium	28	8
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY characters (id, player_name, creature_id, class_id) FROM stdin;
1	Quinten	1	1
\.


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('characters_id_seq', 3, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('classes_id_seq', 1, true);


--
-- Name: creatures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('creatures_id_seq', 1, true);


--
-- Data for Name: skill_constructors; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY skill_constructors (id, name, trained_only, ability) FROM stdin;
1	craft	f	int
2	knowledge	t	int
3	perform	f	cha
4	profession	t	wis
\.


--
-- Name: skill_constructors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('skill_constructors_id_seq', 4, true);


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY skills (id, name, trained_only, ability) FROM stdin;
1	acrobatics	f	dex
2	appraise	f	int
3	bluff	f	cha
4	climb	f	str
5	diplomacy	f	cha
6	disable device	t	dex
7	disguise	f	cha
8	escape artist	f	dex
9	fly	f	dex
10	handle animal	t	cha
11	heal	f	wis
12	intimidate	f	cha
13	linguistics	t	int
14	perception	f	wis
15	ride	f	dex
16	sense motive	f	wis
17	sleight of hand	t	dex
18	spellcraft	t	int
19	stealth	f	dex
20	survival	f	wis
21	swim	f	str
22	use magic device	t	cha
\.


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('skills_id_seq', 22, true);


--
-- Data for Name: sub_skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY sub_skills (id, name, skill_constructor_id) FROM stdin;
1	arcana	2
2	dungeoneering	2
3	engineering	2
4	geography	2
5	history	2
6	local	2
7	nature	2
8	nobility	2
9	planes	2
10	religion	2
\.


--
-- Name: sub_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('sub_skills_id_seq', 10, true);


--
-- PostgreSQL database dump complete
--

