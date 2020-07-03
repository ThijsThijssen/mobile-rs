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

      await _updateSkills(skills);

      return skills;
    } else {
      return null;
    }
  }

  void _updateSkills(List<Skill> skills) async {
    List<Map<String, dynamic>> dbSkills = List<Map<String, dynamic>>();

    for (Skill existingSkill in skills) {
      dbSkills.add(existingSkill.toMap());
    }

    await _firestore
        .collection('skills')
        .document(user.uid)
        .setData({'skills': dbSkills});
  }
}
