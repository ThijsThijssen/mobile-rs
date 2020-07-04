import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/skill.dart';
import 'package:mobile_rs/screens/skill_activities_screen.dart';
import 'package:mobile_rs/services/skill_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../service_locator.dart';

class SkillsScreen extends StatefulWidget {
  static final String id = 'skills_screen';

  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  bool showSpinner = false;

  SkillService _skillService = locator<SkillService>();

  List<Skill> skills;

  _getSkills() async {
    setState(() {
      showSpinner = true;
    });

    skills = [];
    skills = await _skillService.getSkills();

    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _getSkills();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'Skills',
              style: TextStyle(
                fontSize: 55.0,
                fontFamily: 'Runescape',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: skills.length,
                itemBuilder: (BuildContext context, int index) {
                  final skill = skills[index];

                  if (skill != null) {
                    return GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SkillActivitiesScreen(
                            skill: skill,
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: Image(
                            image: AssetImage(
                                'assets/img/skills/${skill.skillImage}.png'),
                            width: 50.0,
                          ),
                          title: Text(
                            skill.skillName,
                            style: TextStyle(
                              fontFamily: 'Runescape',
                              fontSize: 25.0,
                            ),
                          ),
                          subtitle: Text(
                            'Level: ${_skillService.currentLvlByExp(skill.skillExperience)}'
                            ' (${skill.skillExperience} Exp)',
                            style: TextStyle(
                              fontFamily: 'Runescape',
                              fontSize: 20.0,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    );
                  } else {
                    return null;
                  }
                }),
          ),
        ],
      ),
    );
  }
}
