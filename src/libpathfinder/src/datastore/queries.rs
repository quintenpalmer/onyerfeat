
pub static CHARACTER_SUB_SKILLS_QUERY: &'static str = r#"
SELECT
    cssc.id,
    cssc.count,
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
GROUP BY cssc.id, scons.trained_only, scons.name, scons.ability, sub_skills.id, sub_name
"#;
