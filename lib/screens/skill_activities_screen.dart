import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/skill.dart';
import 'package:mobile_rs/services/skill_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../service_locator.dart';

class SkillActivitiesScreen extends StatefulWidget {
  static final String id = 'skill_activities_screen';

  SkillActivitiesScreen({this.skill});

  final Skill skill;

  @override
  _SkillActivitiesScreenState createState() => _SkillActivitiesScreenState();
}

class _SkillActivitiesScreenState extends State<SkillActivitiesScreen> {
  bool showSpinner = false;

  SkillService _skillService = locator<SkillService>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        children: <Widget>[
          Text(
            widget.skill.skillName,
            style: TextStyle(
              fontSize: 55.0,
              fontFamily: 'Runescape',
            ),
          ),
          Text(
            'Level: ${_skillService.currentLvlByExp(widget.skill.skillExperience)} (${widget.skill.skillExperience} Exp)',
            style: TextStyle(
              fontSize: 35.0,
              fontFamily: 'Runescape',
            ),
          ),
        ],
      ),
    );
  }
}
