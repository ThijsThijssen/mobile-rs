import 'dart:math';

import 'package:mobile_rs/dao/skill_dao.dart';
import 'package:mobile_rs/domain/skill.dart';
import 'package:mobile_rs/domain/skills.dart';
import 'package:mobile_rs/service_locator.dart';

class SkillService {
  final SkillDAO _skillDAO = locator<SkillDAO>();

  Future<List<Skill>> createSkillsCollection() async {
    List<Skill> skills = List<Skill>();

    for (int skillId = 0; skillId < Skills.values.length; skillId++) {
      skills.add(Skill(
          skillId: Skills.values[skillId].skillId,
          skillName: Skills.values[skillId].skillName,
          skillExperience: 0,
          skillImage: Skills.values[skillId].skillImage));
    }

    return await _skillDAO.createSkillsCollection(skills);
  }

  Future<List<Skill>> getSkills() async {
    return await _skillDAO.getSkills();
  }

  Future<Skill> getSkillByName(String skillName) async {
    List<Skill> skills = await getSkills();

    for (Skill skill in skills) {
      if (skill.skillName == skillName) {
        return skill;
      }
    }

    return null;
  }

  int _experienceNeededForLevel(int level) {
    double total = 0;

    for (int i = 1; i < level; i++) {
      total += (i + 300 * pow(2, i / 7.0)).floor();
    }

    return (total / 4).floor();
  }

  int currentLvlByExp(int experience) {
    int currentLevel = 1;

    for (int level = 1; level <= 99; level++) {
      if (level == 99 && experience >= _experienceNeededForLevel(level)) {
        currentLevel = level;
      } else {
        if (experience >= _experienceNeededForLevel(level) &&
            experience <= _experienceNeededForLevel(level + 1)) {
          currentLevel = level;
        }
      }
    }

    return currentLevel;
  }

  Future<void> addExperienceToSkill(String skillName, int experience) async {
    List<Skill> skills = await _skillDAO.getSkills();

    for (Skill skill in skills) {
      if (skill.skillName == skillName) {
        skill.skillExperience += experience;
      }
    }

    await _skillDAO.updateSkills(skills);
  }
}
