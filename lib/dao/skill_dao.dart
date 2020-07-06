import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_rs/domain/skill.dart';

class SkillDAO {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _firestore = Firestore.instance;

  FirebaseUser user;

  Future<List<Skill>> createSkillsCollection(List<Skill> skills) async {
    if (_auth.currentUser() != null) {
      user = await _auth.currentUser();

      await updateSkills(skills);

      return skills;
    } else {
      return null;
    }
  }

  void updateSkills(List<Skill> skills) async {
    List<Map<String, dynamic>> dbSkills = List<Map<String, dynamic>>();

    for (Skill existingSkill in skills) {
      dbSkills.add(existingSkill.toMap());
    }

    await _firestore
        .collection('skills')
        .document(user.uid)
        .setData({'skills': dbSkills});
  }

  Future<List<Skill>> getSkills() async {
    if (_auth.currentUser() != null) {
      user = await _auth.currentUser();

      List<dynamic> mapSkills = [];

      await _firestore
          .collection('skills')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          mapSkills = ds.data['skills'];
        } else {
          mapSkills = null;
        }
      });

      List<Skill> skills = [];

      if (mapSkills != null) {
        for (Map<String, dynamic> mapSkill in mapSkills) {
          skills.add(_mapToSkill(mapSkill));
        }
      }

      return skills;
    } else {
      // user is not authenticated throw error
      return null;
    }
  }

  Skill _mapToSkill(Map<String, dynamic> mapSkill) {
    return Skill(
        skillId: mapSkill['skillId'],
        skillName: mapSkill['skillName'],
        skillExperience: mapSkill['skillExperience'],
        skillImage: mapSkill['skillImage']);
  }
}
