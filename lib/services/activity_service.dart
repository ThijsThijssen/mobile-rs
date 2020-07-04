import 'dart:convert';
import 'dart:io';

import 'package:mobile_rs/domain/activity.dart';
import 'package:mobile_rs/domain/skill.dart';
import 'package:path_provider/path_provider.dart';

class ActivityService {
  // getActivities
  Future<List<Activity>> getActivities() async {
    String json = await _loadJsonFile();

    if (json != null) {
      List<dynamic> data = jsonDecode(json);
      return data.map((data) => Activity.fromJson(data)).toList();
    }

    return List<Activity>();
  }

  Future<List<Activity>> getActivitiesBySkill(Skill skill) async {
    List<Activity> activities = await getActivities();

    List<Activity> activitiesBySkill = List<Activity>();

    for (Activity activity in activities) {
      if (activity.skill == skill.skillName) {
        activitiesBySkill.add(activity);
      }
    }

    return activitiesBySkill;
  }

  // createActivity
  Future<File> createActivity(Activity activity) async {
    List<Activity> activities = await getActivities();

    activities.add(activity);

    var json = jsonEncode(activities.map((e) => e.toJson()).toList());

    print(json);

    final file = await _localFile();

    return file.writeAsString(json.toString(), mode: FileMode.write);
  }

  // removeActivity

  Future<String> _loadJsonFile() async {
    try {
      final file = await _localFile();

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  Future<String> localPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile() async {
    final path = await localPath();
    return File('$path/activities.json');
  }
}
