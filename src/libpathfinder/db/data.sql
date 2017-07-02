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
1	12	16	18	14	10	8
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

COPY creatures (id, name, ability_score_set_id, alignment_order, alignment_morality, race, deity, age, size, max_hit_points, current_hit_points, nonlethal_damage, base_attack_bonus, level) FROM stdin;
1	IDRIGOTH	1	neutral	good	dwarf	\N	128	medium	54	38	0	4	4
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
9	1	1	1
10	1	6	1
11	1	2	1
\.


--
-- Name: character_skill_choices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('character_skill_choices_id_seq', 11, true);


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
5	1	4	1
\.


--
-- Name: character_sub_skill_choices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('character_sub_skill_choices_id_seq', 5, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('characters_id_seq', 3, true);


--
-- Data for Name: class_armor_proficiencies; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY class_armor_proficiencies (id, class_id, level, armor_check_penalty_reduction, max_dex_bonus) FROM stdin;
1	1	1	0	0
2	1	2	0	0
3	1	3	-1	1
4	1	4	-1	1
5	1	5	-1	1
6	1	6	-1	1
7	1	7	-2	2
8	1	8	-2	2
9	1	9	-2	2
10	1	10	-2	2
11	1	11	-3	3
12	1	12	-3	3
13	1	13	-3	3
14	1	14	-3	3
15	1	15	-4	4
16	1	16	-4	4
17	1	17	-4	4
18	1	18	-4	4
19	1	19	-4	4
20	1	20	-4	4
\.


--
-- Name: class_armor_proficiencies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('class_armor_proficiencies_id_seq', 20, true);


--
-- Data for Name: class_saving_throws; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY class_saving_throws (id, class_id, level, fortitude, reflex, will) FROM stdin;
1	1	1	2	0	0
2	1	2	3	0	0
3	1	3	3	1	1
4	1	4	4	1	1
5	1	5	4	1	1
6	1	6	5	2	2
7	1	7	5	2	2
8	1	8	6	2	2
9	1	9	6	3	3
10	1	10	7	3	3
11	1	11	7	3	3
12	1	12	8	4	4
13	1	13	8	4	4
14	1	14	9	4	4
15	1	15	9	5	5
16	1	16	10	5	5
17	1	17	10	5	5
18	1	18	11	6	6
19	1	19	11	6	6
20	1	20	12	6	6
\.


--
-- Name: class_saving_throws_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('class_saving_throws_id_seq', 20, true);


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
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY items (id, name, description) FROM stdin;
1	Dwarven Coin	Ancient coin from some dwarven society
2	Rope (10ft)	10 feet of sturdy rope
\.


--
-- Data for Name: creature_items; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY creature_items (id, creature_id, item_id, count) FROM stdin;
2	1	2	6
1	1	1	43
\.


--
-- Name: creature_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('creature_items_id_seq', 2, true);


--
-- Data for Name: shields; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY shields (id, name, ac_bonus, max_dex, skill_penalty, arcane_spell_failure_chance, weight, size_style) FROM stdin;
1	Buckler	1	\N	-1	5	5	\N
6	Shield, tower	4	2	-10	50	45	\N
2	Shield, light wooden	1	\N	-1	5	5	light_melee
3	Shield, light steel	1	\N	-1	5	6	light_melee
4	Shield, heavy wooden	2	\N	-2	15	10	one_handed_melee
5	Shield, heavy steel	2	\N	-2	15	15	one_handed_melee
\.


--
-- Data for Name: creature_shields; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY creature_shields (id, creature_id, shield_id, has_spikes) FROM stdin;
1	1	3	t
\.


--
-- Name: creature_shields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('creature_shields_id_seq', 1, true);


--
-- Data for Name: weapons; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY weapons (id, name, training_type, size_style, cost, small_damage, medium_damage, critical, range, weight, damage_type) FROM stdin;
1	Waraxe, dwarven	exotic	one_handed_melee	30	(1,8)	(1,10)	(20,3)	\N	8	(f,f,t,f)
2	Crossbow, heavy	simple	ranged	50	(1,8)	(1,10)	(19,2)	120	8	(f,t,f,f)
3	Crossbow, light	simple	ranged	35	(1,6)	(1,8)	(19,2)	80	4	(f,t,f,f)
4	Morningstar	simple	one_handed_melee	35	(1,6)	(1,8)	(20,2)	\N	6	(t,t,f,t)
5	Dagger	simple	light_melee	2	(1,3)	(1,4)	(19,2)	10	1	(f,t,t,f)
6	Rapier	martial	one_handed_melee	20	(1,4)	(1,6)	(18,2)	\N	2	(f,t,f,f)
\.


--
-- Data for Name: creature_weapons; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY creature_weapons (id, creature_id, weapon_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	6
\.


--
-- Name: creature_weapons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('creature_weapons_id_seq', 4, true);


--
-- Name: creatures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('creatures_id_seq', 1, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('items_id_seq', 2, true);


--
-- Data for Name: shield_damage; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY shield_damage (id, size_style, spiked, small_damage, medium_damage, critical, range, damage_type) FROM stdin;
5	light_melee	f	(1,2)	(1,3)	(20,2)	\N	(t,f,f,f)
6	light_melee	t	(1,3)	(1,4)	(20,2)	\N	(f,t,f,f)
7	one_handed_melee	f	(1,3)	(1,4)	(20,2)	\N	(t,f,f,f)
8	one_handed_melee	t	(1,4)	(1,6)	(20,2)	\N	(f,t,f,f)
\.


--
-- Name: shield_damage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('shield_damage_id_seq', 8, true);


--
-- Name: shields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('shields_id_seq', 6, true);


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
-- Name: weapons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('weapons_id_seq', 6, true);


--
-- PostgreSQL database dump complete
--

