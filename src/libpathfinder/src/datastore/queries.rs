
pub static CHARACTER_SUB_SKILLS_SQL: &'static str = r#"
SELECT
    cssc.id,
    cssc.count,
    scons.id as skill_constructor_id,
    scons.name,
    scons.ability,
    scons.trained_only,
    sub_skills.id as sub_skill_id,
    sub_skills.name as sub_name
FROM
    character_sub_skill_choices cssc
INNER JOIN
    sub_skills
ON
    sub_skills.id = cssc.sub_skill_id
INNER JOIN
    skill_constructors scons
ON
    sub_skills.skill_constructor_id = scons.id
WHERE
    cssc.character_id = $1
GROUP BY cssc.id, scons.trained_only, scons.name, scons.ability, scons.id, sub_skills.id, sub_name
"#;

pub static CHARACTER_ARMOR_PIECE_SQL: &'static str = r#"
SELECT
    a.*
FROM
    creature_armor_pieces cap
INNER JOIN
    armor_pieces a
ON
    cap.armor_piece_id = a.id
WHERE
    cap.creature_id = $1
"#;

pub static CHARACTER_SHIELD_SQL: &'static str = r#"
SELECT
    shields.*
FROM
    creature_shields cs
INNER JOIN
    shields
ON
    cs.shield_id = shields.id
WHERE
    cs.creature_id = $1
"#;

pub static BASE_SAVING_THROWS_SQL: &'static str = r#"
SELECT
    *
FROM
    class_saving_throws
WHERE
    class_id = $1
AND
    level = $2
"#;

pub static CREATURE_WEAPON_SQL: &'static str = r#"
SELECT
    weapons.*
FROM
    creature_weapons cws
INNER JOIN
    weapons
ON
    cws.weapon_id = weapons.id
WHERE
    cws.creature_id = $1
"#;

pub static CLASS_ARMOR_PROFICIENCY_SQL: &'static str = r#"
SELECT
    cap.*
FROM
    class_armor_proficiencies cap
WHERE
    cap.class_id = $1
AND
    cap.level = $2
"#;

pub static SHIELD_DAMAGE_SQL: &'static str = r#"
SELECT
    shields.name as shield_name,
    shields.weight,
    shield_damage.*
FROM
    creature_shields
INNER JOIN
    shields
ON
    creature_shields.shield_id = shields.id
INNER JOIN
    shield_damage
ON
    shield_damage.size_style = shields.size_style
WHERE
    creature_shields.creature_id = $1
AND
    creature_shields.has_spikes = shield_damage.spiked
"#;
