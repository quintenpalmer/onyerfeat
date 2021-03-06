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
-- Data for Name: ability_score_sets; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.ability_score_sets (id, str, dex, con, "int", wis, cha) FROM stdin;
1	13	16	18	14	10	8
5	15	14	13	13	8	16
4	16	13	16	10	14	6
6	18	14	17	6	12	6
7	16	13	14	10	12	8
8	16	14	16	12	10	10
9	16	12	16	10	10	8
10	14	14	12	10	10	8
\.


--
-- Name: ability_score_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.ability_score_sets_id_seq', 10, true);


--
-- Data for Name: armor_pieces; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.armor_pieces (id, armor_class, name, armor_bonus, max_dex_bonus, armor_check_penalty, arcane_spell_failure_chance, fast_speed, slow_speed, medium_weight) FROM stdin;
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
-- Data for Name: armor_piece_instances; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.armor_piece_instances (id, armor_piece_id, is_masterwork, special) FROM stdin;
2	8	t	\N
3	8	t	\N
1	8	f	\N
4	2	f	\N
5	5	t	\N
6	5	t	\N
7	12	t	\N
8	8	t	\N
\.


--
-- Name: armor_piece_instances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.armor_piece_instances_id_seq', 8, true);


--
-- Name: armor_pieces_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.armor_pieces_id_seq', 12, true);


--
-- Data for Name: aura_magnitudes; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.aura_magnitudes (id, magnitude) FROM stdin;
1	faint
2	moderate
3	strong
\.


--
-- Name: aura_magnitudes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.aura_magnitudes_id_seq', 3, true);


--
-- Data for Name: aura_schools; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.aura_schools (id, school) FROM stdin;
1	abjuration
2	conjuration
3	divination
4	enchantment
5	evocation
6	illusion
7	necromancy
8	transmutation
\.


--
-- Name: aura_schools_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.aura_schools_id_seq', 8, true);


--
-- Data for Name: creatures; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.creatures (id, name, ability_score_set_id, alignment_order, alignment_morality, race, deity, age, size, max_hit_points, current_hit_points, nonlethal_damage, base_attack_bonus, armor_piece_instance_id) FROM stdin;
3	Datanamàsh	4	neutral	good	dwarf	\N	78	medium	51	51	0	5	2
5	Charger	6	lawful	good	Horse	\N	10	large	36	36	0	3	4
4	Atolabsam	5	lawful	good	dwarf	\N	80	medium	48	31	0	5	3
1	IDRIGOTH	1	neutral	good	dwarf	\N	63	medium	85	42	0	6	1
6	Amalgam	7	neutral	neutral	centaur	\N	30	medium	52	52	0	6	5
7	Rager	8	chaotic	good	dwarf	\N	64	medium	59	59	0	6	6
8	Stonelaurd	9	lawful	good	dwarf	\N	58	medium	120	120	0	8	7
9	Yorick	10	chaotic	neutral	human	\N	31	medium	40	40	0	6	8
\.


--
-- Data for Name: characters; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.characters (id, player_name, creature_id) FROM stdin;
1	Quinten	1
4	Quinten	3
5	Quinten	4
6	Quinten	5
7	Quinten	6
8	Quinten	7
9	Quinten	8
10	Quinten	9
\.


--
-- Data for Name: class_bonus_sets; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_bonus_sets (id) FROM stdin;
1
2
3
4
5
6
\.


--
-- Data for Name: class_skill_sets; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_skill_sets (id) FROM stdin;
1
2
3
4
5
6
\.


--
-- Data for Name: classes; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.classes (id, name, class_bonus_set_id, class_skill_set_id) FROM stdin;
1	fighter	1	1
2	paladin	2	2
3	animal companion	3	3
4	barbarian	4	4
5	stalwart defender	5	5
\.


--
-- Data for Name: class_archetypes; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_archetypes (id, class_id, name, class_bonus_set_id, class_skill_set_id) FROM stdin;
1	1	\N	\N	\N
2	2	\N	\N	\N
3	3	\N	\N	\N
4	4	\N	\N	\N
5	5	\N	\N	\N
6	4	Savage Technologist	6	6
\.


--
-- Data for Name: character_classes; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.character_classes (id, character_id, class_archetype_id, level) FROM stdin;
1	1	1	6
2	4	1	5
3	5	2	5
4	6	3	5
5	7	1	3
7	7	3	3
8	8	4	6
9	9	4	7
10	9	5	1
11	10	6	6
\.


--
-- Name: character_classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.character_classes_id_seq', 11, true);


--
-- Data for Name: skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.skills (id, name, trained_only, ability) FROM stdin;
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

COPY public.character_skill_choices (id, character_id, skill_id, count) FROM stdin;
2	1	12	1
3	1	15	1
4	1	20	1
6	1	11	1
7	1	10	1
10	1	6	1
11	1	2	1
8	1	19	2
9	1	1	2
1	1	4	2
5	1	21	2
12	4	20	1
13	4	10	1
14	4	15	1
15	4	4	1
16	4	21	1
17	4	14	1
18	5	10	1
19	5	15	1
20	5	16	1
22	5	11	1
23	5	14	1
21	5	5	3
24	5	18	1
\.


--
-- Name: character_skill_choices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.character_skill_choices_id_seq', 24, true);


--
-- Data for Name: skill_constructors; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.skill_constructors (id, name, trained_only, ability) FROM stdin;
1	craft	f	int
2	knowledge	t	int
3	perform	f	cha
4	profession	t	wis
\.


--
-- Data for Name: sub_skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.sub_skills (id, name, skill_constructor_id) FROM stdin;
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
13	books	1
14	archaeologist	4
15	beer	1
16	brewer	4
\.


--
-- Data for Name: character_sub_skill_choices; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.character_sub_skill_choices (id, character_id, sub_skill_id, count) FROM stdin;
1	1	2	1
2	1	3	1
3	1	11	1
4	1	12	1
5	1	4	1
6	4	15	1
7	4	16	1
8	4	2	1
9	4	3	1
10	5	13	1
12	5	8	1
13	5	10	1
11	5	14	3
\.


--
-- Name: character_sub_skill_choices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.character_sub_skill_choices_id_seq', 13, true);


--
-- Name: characters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.characters_id_seq', 10, true);


--
-- Name: class_archetypes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_archetypes_id_seq', 6, true);


--
-- Name: class_bonus_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_bonus_sets_id_seq', 6, true);


--
-- Data for Name: class_bonuses; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_bonuses (id, class_bonus_set_id, level, cha_bonus, ac_penalty_reduction, max_dex_bonus, natural_armor_bonus, str_dex_bonus, ac_dodge_bonus) FROM stdin;
1	1	1	f	0	0	0	0	0
2	1	2	f	0	0	0	0	0
3	3	1	f	0	0	0	0	0
4	3	2	f	0	0	0	0	0
5	2	2	t	0	0	0	0	0
6	2	3	t	0	0	0	0	0
7	2	4	t	0	0	0	0	0
8	2	5	t	0	0	0	0	0
9	2	6	t	0	0	0	0	0
10	2	7	t	0	0	0	0	0
11	2	8	t	0	0	0	0	0
12	2	9	t	0	0	0	0	0
13	2	10	t	0	0	0	0	0
14	2	11	t	0	0	0	0	0
15	2	12	t	0	0	0	0	0
16	2	13	t	0	0	0	0	0
17	2	14	t	0	0	0	0	0
18	2	15	t	0	0	0	0	0
19	2	16	t	0	0	0	0	0
20	2	17	t	0	0	0	0	0
21	2	18	t	0	0	0	0	0
22	2	19	t	0	0	0	0	0
23	2	20	t	0	0	0	0	0
24	2	1	f	0	0	0	0	0
25	1	3	f	-1	1	0	0	0
26	1	4	f	-1	1	0	0	0
27	1	5	f	-1	1	0	0	0
28	1	6	f	-1	1	0	0	0
29	1	7	f	-2	2	0	0	0
30	1	8	f	-2	2	0	0	0
31	1	9	f	-2	2	0	0	0
32	1	10	f	-2	2	0	0	0
33	1	11	f	-3	3	0	0	0
34	1	12	f	-3	3	0	0	0
35	1	13	f	-3	3	0	0	0
36	1	14	f	-3	3	0	0	0
37	1	15	f	-4	4	0	0	0
38	1	16	f	-4	4	0	0	0
39	1	17	f	-4	4	0	0	0
40	1	18	f	-4	4	0	0	0
41	1	19	f	-4	4	0	0	0
42	1	20	f	-4	4	0	0	0
43	3	3	f	0	0	2	1	0
44	3	4	f	0	0	2	1	0
45	3	5	f	0	0	2	1	0
46	3	6	f	0	0	4	2	0
47	3	7	f	0	0	4	2	0
48	3	8	f	0	0	4	2	0
49	3	9	f	0	0	6	3	0
50	3	10	f	0	0	6	3	0
51	3	11	f	0	0	6	3	0
52	3	12	f	0	0	8	4	0
53	3	13	f	0	0	8	4	0
54	3	14	f	0	0	8	4	0
55	3	15	f	0	0	10	5	0
56	3	16	f	0	0	10	5	0
57	3	17	f	0	0	10	5	0
58	3	18	f	0	0	12	6	0
59	3	19	f	0	0	12	6	0
60	3	20	f	0	0	12	6	0
61	4	1	f	0	0	0	0	0
62	4	2	f	0	0	0	0	0
63	4	3	f	0	0	0	0	0
64	4	4	f	0	0	0	0	0
65	4	5	f	0	0	0	0	0
66	4	6	f	0	0	0	0	0
67	4	7	f	0	0	0	0	0
68	4	8	f	0	0	0	0	0
69	4	9	f	0	0	0	0	0
70	4	10	f	0	0	0	0	0
71	4	11	f	0	0	0	0	0
72	4	12	f	0	0	0	0	0
73	4	13	f	0	0	0	0	0
74	4	14	f	0	0	0	0	0
75	4	15	f	0	0	0	0	0
76	4	16	f	0	0	0	0	0
77	4	17	f	0	0	0	0	0
78	4	18	f	0	0	0	0	0
79	4	19	f	0	0	0	0	0
80	4	20	f	0	0	0	0	0
81	5	1	f	0	0	0	0	1
82	5	2	f	0	0	0	0	1
83	5	3	f	0	0	0	0	1
84	5	4	f	0	0	0	0	2
85	5	5	f	0	0	0	0	2
86	5	6	f	0	0	0	0	2
87	5	7	f	0	0	0	0	2
88	5	8	f	0	0	0	0	3
89	5	9	f	0	0	0	0	3
90	5	10	f	0	0	0	0	4
91	6	1	f	0	0	0	0	0
92	6	2	f	0	0	0	0	0
93	6	3	f	0	0	0	0	0
94	6	4	f	0	0	0	0	0
95	6	5	f	0	0	0	0	0
96	6	6	f	0	0	0	0	0
97	6	7	f	0	0	0	0	0
98	6	8	f	0	0	0	0	0
99	6	9	f	0	0	0	0	0
100	6	10	f	0	0	0	0	0
101	6	11	f	0	0	0	0	0
102	6	12	f	0	0	0	0	0
103	6	13	f	0	0	0	0	0
104	6	14	f	0	0	0	0	0
105	6	15	f	0	0	0	0	0
106	6	16	f	0	0	0	0	0
107	6	17	f	0	0	0	0	0
108	6	18	f	0	0	0	0	0
109	6	19	f	0	0	0	0	0
110	6	20	f	0	0	0	0	0
\.


--
-- Name: class_bonuses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_bonuses_id_seq', 110, true);


--
-- Data for Name: class_saving_throws; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_saving_throws (id, class_id, level, fortitude, reflex, will) FROM stdin;
1	1	1	2	0	0
2	1	2	3	0	0
41	3	1	3	3	0
42	3	2	3	3	1
22	2	2	3	0	3
23	2	3	3	1	3
24	2	4	4	1	4
25	2	5	4	1	4
26	2	6	5	2	5
27	2	7	5	2	5
28	2	8	6	2	6
29	2	9	6	3	6
30	2	10	7	3	7
31	2	11	7	3	7
32	2	12	8	4	8
33	2	13	8	4	8
34	2	14	9	4	9
35	2	15	9	5	9
36	2	16	10	5	10
37	2	17	10	5	10
38	2	18	11	6	11
39	2	19	11	6	11
40	2	20	12	6	12
21	2	1	2	0	2
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
43	3	3	3	3	1
44	3	4	4	4	1
45	3	5	4	4	1
46	3	6	5	5	2
47	3	7	5	5	2
48	3	8	5	5	2
49	3	9	6	6	2
50	3	10	6	6	6
51	3	11	6	6	6
52	3	12	7	7	7
53	3	13	8	7	7
54	3	14	9	8	8
55	3	15	9	8	8
56	3	16	9	8	8
57	3	17	10	9	9
58	3	18	11	9	9
59	3	19	11	9	9
60	3	20	12	10	10
61	4	1	2	0	0
62	4	2	3	0	0
63	4	3	3	1	1
64	4	4	4	1	1
65	4	5	4	1	1
66	4	6	5	2	2
67	4	7	5	2	2
68	4	8	6	2	2
69	4	9	6	3	3
70	4	10	7	3	3
71	4	11	7	3	3
72	4	12	8	4	4
73	4	13	8	4	4
74	4	14	9	4	4
75	4	15	9	5	5
76	4	16	10	5	5
77	4	17	10	5	5
78	4	18	11	6	6
79	4	19	11	6	6
80	4	20	12	6	6
81	5	1	1	0	1
82	5	2	1	1	1
83	5	3	2	1	2
84	5	4	2	1	2
85	5	5	3	2	3
86	5	6	3	2	3
87	5	7	4	2	4
88	5	8	4	3	4
89	5	9	5	3	5
90	5	10	5	3	5
\.


--
-- Name: class_saving_throws_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_saving_throws_id_seq', 90, true);


--
-- Data for Name: class_skill_constructors; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_skill_constructors (id, class_skill_set_id, skill_constructor_id) FROM stdin;
1	1	1
2	1	4
3	2	1
4	2	4
5	4	1
6	6	1
\.


--
-- Name: class_skill_constructors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_skill_constructors_id_seq', 6, true);


--
-- Name: class_skill_sets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_skill_sets_id_seq', 6, true);


--
-- Data for Name: class_skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_skills (id, class_skill_set_id, skill_id) FROM stdin;
1	1	4
2	1	10
3	1	12
4	1	15
5	1	20
6	1	21
7	2	5
8	2	10
9	2	11
10	2	15
11	2	16
12	2	18
26	6	1
27	6	4
28	6	5
29	6	12
30	6	14
31	6	16
32	6	15
33	6	20
34	6	21
21	5	1
22	5	4
23	5	12
24	5	14
25	5	16
13	4	1
14	4	4
15	4	10
16	4	12
17	4	14
18	4	15
19	4	20
20	4	21
\.


--
-- Name: class_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_skills_id_seq', 34, true);


--
-- Data for Name: class_sub_skills; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.class_sub_skills (id, class_skill_set_id, sub_skill_id) FROM stdin;
1	1	3
2	1	2
3	2	8
4	2	10
5	4	7
6	6	6
\.


--
-- Name: class_sub_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.class_sub_skills_id_seq', 6, true);


--
-- Name: classes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.classes_id_seq', 5, true);


--
-- Data for Name: items; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.items (id, name, description) FROM stdin;
1	Dwarven Coin	Ancient coin from some dwarven society
2	Rope (10ft)	10 feet of sturdy rope
3	Flask (ale)	A flask full of ale
4	Sleeping bag	Good for a good night's sleep
5	Bucket	Can hold one gallon of liquid
\.


--
-- Data for Name: creature_items; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.creature_items (id, creature_id, item_id, count) FROM stdin;
2	1	2	6
1	1	1	43
4	1	3	1
5	1	4	1
6	1	5	1
7	3	3	1
8	3	2	5
9	3	4	1
10	4	3	1
11	4	2	10
12	4	4	1
\.


--
-- Name: creature_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.creature_items_id_seq', 12, true);


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.languages (id, name) FROM stdin;
1	Common
2	Dwarf
3	Terran
4	Giant
5	Orc
\.


--
-- Data for Name: creature_languages; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.creature_languages (id, creature_id, language_id) FROM stdin;
1	1	1
2	1	2
3	1	3
4	1	4
5	3	1
6	3	2
7	4	1
8	4	2
9	4	5
\.


--
-- Name: creature_languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.creature_languages_id_seq', 9, true);


--
-- Data for Name: shields; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.shields (id, name, ac_bonus, max_dex, skill_penalty, arcane_spell_failure_chance, weight, size_style) FROM stdin;
1	Buckler	1	\N	-1	5	5	\N
6	Shield, tower	4	2	-10	50	45	\N
2	Shield, light wooden	1	\N	-1	5	5	light_melee
3	Shield, light steel	1	\N	-1	5	6	light_melee
4	Shield, heavy wooden	2	\N	-2	15	10	one_handed_melee
5	Shield, heavy steel	2	\N	-2	15	15	one_handed_melee
7	Dork Firespitter Shield	1	\N	-1	5	7	light_melee
\.


--
-- Data for Name: creature_shields; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.creature_shields (id, creature_id, shield_id, has_spikes, is_masterwork, special) FROM stdin;
1	1	7	t	t	lite on fire for 3 rounds of 1d6 fire on contact; +1 AC on arrows
2	8	6	t	t	\N
\.


--
-- Name: creature_shields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.creature_shields_id_seq', 2, true);


--
-- Data for Name: weapons; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.weapons (id, name, training_type, size_style, cost, small_damage, medium_damage, critical, range, weight, damage_type) FROM stdin;
1	Waraxe, dwarven	exotic	one_handed_melee	30	(1,8)	(1,10)	(20,3)	\N	8	(f,f,t,f)
2	Crossbow, heavy	simple	ranged	50	(1,8)	(1,10)	(19,2)	120	8	(f,t,f,f)
3	Crossbow, light	simple	ranged	35	(1,6)	(1,8)	(19,2)	80	4	(f,t,f,f)
4	Morningstar	simple	one_handed_melee	35	(1,6)	(1,8)	(20,2)	\N	6	(t,t,f,t)
5	Dagger	simple	light_melee	2	(1,3)	(1,4)	(19,2)	10	1	(f,t,t,f)
6	Rapier	martial	one_handed_melee	20	(1,4)	(1,6)	(18,2)	\N	2	(f,t,f,f)
7	Greatsword	martial	two_handed_melee	50	(1,10)	(2,6)	(19,2)	\N	8	(f,f,t,f)
8	Longbow	martial	ranged	75	(1,6)	(1,8)	(20,3)	100	3	(f,t,f,f)
9	Axe, throwing	martial	light_melee	8	(1,4)	(1,6)	(20,2)	10	2	(f,f,t,f)
10	Handaxe	martial	light_melee	8	(1,4)	(1,6)	(20,3)	\N	3	(f,f,t,f)
11	Glaive	martial	two_handed_melee	8	(1,8)	(1,10)	(20,3)	\N	10	(f,f,t,f)
13	Lance	martial	two_handed_melee	10	(1,6)	(1,8)	(20,3)	\N	10	(f,t,f,f)
12	Guisarme	martial	two_handed_melee	9	(1,6)	(2,4)	(20,3)	\N	12	(f,f,t,f)
14	Ranseur	martial	two_handed_melee	10	(1,6)	(2,4)	(20,3)	\N	11	(f,t,f,f)
15	Horse Bite	martial	two_handed_melee	0	(1,3)	(1,4)	(20,2)	\N	1	(t,f,f,f)
16	Horse Hooves	martial	two_handed_melee	0	(1,4)	(1,6)	(20,2)	\N	1	(t,f,f,f)
\.


--
-- Data for Name: weapon_instances; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.weapon_instances (id, weapon_id, name, is_masterwork, special) FROM stdin;
1	1	\N	f	\N
3	7	\N	t	\N
4	7	\N	t	\N
5	8	Backbiter Bow	t	Always deals max damage on hit; wielder takes 8-1d8 damage on hit
6	9	\N	f	\N
7	10	\N	f	\N
8	10	\N	f	\N
2	2	\N	f	Has grappling hook extension bows
10	15	\N	f	\N
11	16	\N	f	-5 attack
12	13	\N	f	\N
13	11	Mecho-Glaive	f	wind as move action to give +2 damage for 3 rounds
14	2	Rusty Clockwork Crossbow	f	Load 10 fletchets; shoots all of them (blows up on d=#fletchets)
15	13	\N	t	\N
16	16	\N	t	\N
17	7	\N	t	\N
18	6	\N	t	\N
\.


--
-- Data for Name: creature_weapons; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.creature_weapons (id, creature_id, weapon_instance_id) FROM stdin;
1	1	1
2	1	2
5	3	3
6	4	4
7	1	5
8	1	6
9	1	7
10	1	8
12	5	10
13	5	11
14	4	12
15	1	13
16	1	14
17	6	15
18	6	16
19	7	17
20	8	18
\.


--
-- Name: creature_weapons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.creature_weapons_id_seq', 20, true);


--
-- Name: creatures_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.creatures_id_seq', 9, true);


--
-- Data for Name: item_body_slots; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.item_body_slots (id, name, max_count_in_slot, examples) FROM stdin;
1	armor	1	suits of armor
2	belt	1	belts and girdles
3	body	1	robes and vestements
4	chest	1	mantles, shirts, and vests
5	eyes	1	eyes, glasses, and goggles
6	feet	1	boots, shoes, and slippers
7	hands	1	gauntlets and gloves
8	head	1	circlets, crowns, hats, hemls, and masks
9	headband	1	headbands and phylacteries
10	neck	1	amulets, brooches, medallions, necklaces, periapts, and scarabs
11	ring	2	rings
12	shield	1	shields
13	shoulders	1	capes and cloaks
14	wrist	1	bracelets and bracers
\.


--
-- Name: item_body_slots_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.item_body_slots_id_seq', 14, true);


--
-- Name: items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.items_id_seq', 5, true);


--
-- Name: languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.languages_id_seq', 5, true);


--
-- Data for Name: shield_damage; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.shield_damage (id, size_style, spiked, small_damage, medium_damage, critical, range, damage_type) FROM stdin;
5	light_melee	f	(1,2)	(1,3)	(20,2)	\N	(t,f,f,f)
6	light_melee	t	(1,3)	(1,4)	(20,2)	\N	(f,t,f,f)
7	one_handed_melee	f	(1,3)	(1,4)	(20,2)	\N	(t,f,f,f)
8	one_handed_melee	t	(1,4)	(1,6)	(20,2)	\N	(f,t,f,f)
\.


--
-- Name: shield_damage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.shield_damage_id_seq', 8, true);


--
-- Name: shields_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.shields_id_seq', 7, true);


--
-- Name: skill_constructors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.skill_constructors_id_seq', 4, true);


--
-- Name: skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.skills_id_seq', 22, true);


--
-- Name: sub_skills_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.sub_skills_id_seq', 16, true);


--
-- Name: weapon_instances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.weapon_instances_id_seq', 18, true);


--
-- Name: weapons_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.weapons_id_seq', 16, true);


--
-- Data for Name: wondrous_items; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.wondrous_items (id, name, caster_level, slot_id, price, weight, description, construction_requirements_text) FROM stdin;
1	boots of the winterlands	5	6	2500	1	This footgear bestows many powers upon the wearer. First, he is able to travel across snow at his normal speed, leaving no tracks. Second, the boots also enable him to travel at normal speed across the most slippery ice (horizontal surfaces only, not vertical or sharply slanted ones) without falling or slipping. Finally, boots of the winterlands warm the wearer, as if he were affected by an endure elements spell.	Requirements Craft Wondrous Item, cat's grace, endure elements, pass without trace; Cost 1,250 gp
\.


--
-- Data for Name: wondrous_item_auras; Type: TABLE DATA; Schema: public; Owner: pathfinder_user
--

COPY public.wondrous_item_auras (id, wondrous_item_id, aura_magnitude_id, aura_school_id) FROM stdin;
1	1	1	1
2	1	1	8
\.


--
-- Name: wondrous_item_auras_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.wondrous_item_auras_id_seq', 2, true);


--
-- Name: wondrous_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: pathfinder_user
--

SELECT pg_catalog.setval('public.wondrous_items_id_seq', 1, true);


--
-- PostgreSQL database dump complete
--

