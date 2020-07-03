class Skill {
  Skill({this.skillId, this.skillName, this.skillExperience, this.skillImage});

  int skillId;
  String skillName;
  int skillExperience;
  String skillImage;

  Map<String, dynamic> toMap() {
    return {
      'skillId': skillId,
      'skillName': skillName,
      'skillExperience': skillExperience,
      'skillImage': skillImage
    };
  }
}
