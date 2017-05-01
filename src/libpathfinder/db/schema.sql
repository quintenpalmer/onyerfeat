CREATE TABLE characters ( id INTEGER PRIMARY KEY, name TEXT NOT NULL , ability_score_set_id integer NOT NULL, alignment_order text not null, alignment_morality text not null, FOREIGN KEY(ability_score_set_id) references ability_score_sets(id));
CREATE TABLE ability_score_sets (id integer primary key, str integer not null, dex integer not null, con integer not null, int integer not null, wis integer not null, cha integer not null);
