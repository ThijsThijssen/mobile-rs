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

  final _formKey = GlobalKey<FormState>();
  String _activitySearch;
  final _activitySearchController = TextEditingController();

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
    widgetRequirements.add(Text(
      'Items required:',
      style: TextStyle(
        fontFamily: 'Runescape',
        fontSize: 22.0,
      ),
    ));

    widgetRequirements.add(
      SizedBox(
        height: 10.0,
      ),
    );

    for (Item item in itemRequirements) {
      widgetRequirements.add(Text(
        '${item.itemAmount} x ${item.itemName}',
        style: TextStyle(
          fontFamily: 'Runescape',
          fontSize: 20.0,
        ),
      ));
    }

    widgetRequirements.add(
      SizedBox(
        height: 10.0,
      ),
    );

    widgetRequirements.add(Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        SizedBox(
          width: 60.0,
          child: RaisedButton(
            onPressed: () {},
            child: Text('1'),
          ),
        ),
        SizedBox(
          width: 60.0,
          child: RaisedButton(
            onPressed: () {},
            child: Text('10'),
          ),
        ),
        SizedBox(
          width: 60.0,
          child: RaisedButton(
            onPressed: () {},
            child: Text('100'),
          ),
        ),
      ],
    ));

    return widgetRequirements;
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        showSpinner = true;
      });

      activities = [];
      activities = await _activityService.getActivitiesBySkillAndName(
          widget.skill, _activitySearch);

      setState(() {
        showSpinner = false;
      });

      _activitySearchController.clear();
    }
  }

  _clear() {
    _getActivities();
    _activitySearchController.clear();
  }

  Future<void> _showRequirementsDialog(Activity activity) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            activity.name,
            style: TextStyle(
              fontFamily: 'Runescape',
              fontSize: 28.0,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: _getItemRequirements(activity.itemRequirements),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Close',
                style: TextStyle(
                  fontFamily: 'Runescape',
                  fontSize: 20.0,
                ),
              ),
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
  void dispose() {
    _activitySearchController.dispose();
    super.dispose();
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
            Form(
              key: _formKey,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.0,
                    ),
                    child: IconButton(
                      onPressed: _clear,
                      icon: Icon(Icons.clear),
                      iconSize: 25.0,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                      child: TextFormField(
                        controller: _activitySearchController,
                        decoration:
                            InputDecoration(labelText: 'Search activity'),
                        validator: (input) => input.trim().isEmpty
                            ? 'Enter an activity to search'
                            : null,
                        onSaved: (input) => _activitySearch = input,
                        style: TextStyle(
                          fontFamily: 'Runescape',
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _submit,
                    icon: Icon(Icons.search),
                    iconSize: 35.0,
                  ),
                ],
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
                              width: 40.0,
                            ),
                            title: Text(
                              activity.name,
                              style: TextStyle(
                                fontFamily: 'Runescape',
                                fontSize: 20.0,
                              ),
                            ),
                            subtitle: Text(
                              'Level: ${activity.levelRequirement}',
                              style: TextStyle(
                                fontFamily: 'Runescape',
                                fontSize: 18.0,
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
