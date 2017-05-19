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
-- Data for Name: armor_pieces; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY armor_pieces (id, armor_class, name, armor_bonus, max_dex_bonus, armor_check_penalty, arcane_spell_failure_chance, fast_speed, slow_speed, medium_weight) FROM stdin;
1	light	Padded	1	8	0	5	30	20	10
2	light	Leather	2	6	0	10	30	20	15
3	light	Studded leather	3	5	-1	15	30	20	20
4	light	Chain shirt	4	4	-2	20	30	20	25
5	medium	Hide	4	4	-3	20	20	15	25
6	medium	Scale mail	5	3	-4	25	20	15	30
7	medium	Chainmail	6	2	-5	30	20	15	40
8	medium	Breastplate	6	3	-4	25	20	15	30
9	heavy	Splint mail	7	0	-7	40	20	15	45
10	heavy	Banded mail	7	1	-6	35	20	15	35
11	heavy	Half-plate	8	0	-7	40	20	15	50
12	heavy	Full plate	9	1	-6	35	20	15	50
\.


--
-- Name: armor_pieces_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('armor_pieces_id_seq', 12, true);


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY classes (id, name) FROM stdin;
1	fighter
\.


--
-- Data for Name: creatures; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY creatures (id, name, ability_score_set_id, alignment_order, alignment_morality, race, deity, age, size, max_hit_points, current_hit_points, nonlethal_damage) FROM stdin;
1	IDRIGOTH	1	neutral	good	dwarf	\N	128	medium	40	40	0
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY characters (id, player_name, creature_id, class_id) FROM stdin;
1	Quinten	1	1
\.


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
-- Data for Name: character_skill_choices; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY character_skill_choices (id, character_id, skill_id, count) FROM stdin;
1	1	4	1
2	1	12	1
3	1	15	1
4	1	20	1
5	1	21	1
6	1	11	1
7	1	10	1
8	1	19	1
\.


--
-- Name: character_skill_choices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('character_skill_choices_id_seq', 8, true);


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
11	traps	1
12	architect	4
\.


--
-- Data for Name: character_sub_skill_choices; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY character_sub_skill_choices (id, character_id, sub_skill_id, count) FROM stdin;
1	1	2	1
2	1	3	1
3	1	11	1
4	1	12	1
\.


--
-- Name: character_sub_skill_choices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('character_sub_skill_choices_id_seq', 4, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('characters_id_seq', 3, true);


--
-- Data for Name: class_skill_constructors; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY class_skill_constructors (id, class_id, skill_constructor_id) FROM stdin;
1	1	1
2	1	4
\.


--
-- Name: class_skill_constructors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('class_skill_constructors_id_seq', 2, true);


--
-- Data for Name: class_skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY class_skills (id, class_id, skill_id) FROM stdin;
1	1	4
2	1	10
3	1	12
4	1	15
5	1	20
6	1	21
\.


--
-- Name: class_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('class_skills_id_seq', 6, true);


--
-- Data for Name: class_sub_skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY class_sub_skills (id, class_id, sub_skill_id) FROM stdin;
1	1	3
2	1	2
\.


--
-- Name: class_sub_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('class_sub_skills_id_seq', 2, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('classes_id_seq', 1, true);


--
-- Data for Name: creature_armor_pieces; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY creature_armor_pieces (id, creature_id, armor_piece_id) FROM stdin;
1	1	8
\.


--
-- Name: creature_armor_pieces_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('creature_armor_pieces_id_seq', 1, true);


--
-- Name: creatures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('creatures_id_seq', 1, true);


--
-- Name: skill_constructors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('skill_constructors_id_seq', 4, true);


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('skills_id_seq', 22, true);


--
-- Name: sub_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('sub_skills_id_seq', 12, true);


--
-- PostgreSQL database dump complete
--

