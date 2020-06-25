import 'package:flutter/material.dart';

class SkillButton extends StatelessWidget {
  SkillButton({@required this.skillName, @required this.skillCallback});
  final String skillName;
  final Function skillCallback;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      margin: EdgeInsets.all(10.0),
      child: OutlineButton(
        onPressed: skillCallback,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage("assets/img/skills/${skillName}_icon.png"),
                height: 35.0,
              ),
              Text(
                '$skillName',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
