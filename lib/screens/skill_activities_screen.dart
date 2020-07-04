import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/activity.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/domain/skill.dart';
import 'package:mobile_rs/services/activity_service.dart';
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
  ActivityService _activityService = locator<ActivityService>();

  List<Activity> activities;

  _getActivities() async {
    setState(() {
      showSpinner = true;
    });

    activities = [];
    activities = await _activityService.getActivitiesBySkill(widget.skill);

    setState(() {
      showSpinner = false;
    });
  }

  List<Widget> _getItemRequirements(List<Item> itemRequirements) {
    List<Widget> widgetRequirements = List<Widget>();
    widgetRequirements.add(Text('Items required:'));

    for (Item item in itemRequirements) {
      widgetRequirements.add(Text('${item.itemAmount} x ${item.itemName}'));
    }

    return widgetRequirements;
  }

  Future<void> _showRequirementsDialog(Activity activity) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(activity.name),
          content: SingleChildScrollView(
            child: ListBody(
              children: _getItemRequirements(activity.itemRequirements),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();

    _getActivities();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Dialog(
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
              'Level: ${_skillService.currentLvlByExp(widget.skill.skillExperience)}',
              style: TextStyle(
                fontSize: 35.0,
                fontFamily: 'Runescape',
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: activities.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final activity = activities[index];

                    if (activity != null) {
                      return GestureDetector(
                        onTap: () {},
                        child: Card(
                          child: ListTile(
                            leading: Image(
                              image: AssetImage(
                                  'assets/img/items/${activity.image}.png'),
                              width: 50.0,
                            ),
                            title: Text(
                              activity.name,
                              style: TextStyle(
                                fontFamily: 'Runescape',
                                fontSize: 25.0,
                              ),
                            ),
                            subtitle: Text(
                              'Level: ${activity.levelRequirement}',
                              style: TextStyle(
                                fontFamily: 'Runescape',
                                fontSize: 20.0,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                print(activity.itemRequirements);
                                _showRequirementsDialog(activity);
                              },
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
      ),
    );
  }
}
