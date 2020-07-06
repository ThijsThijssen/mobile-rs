import 'dart:convert';
import 'dart:io';

import 'package:mobile_rs/domain/activity.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/domain/item_type.dart';
import 'package:mobile_rs/domain/skill.dart';
import 'package:mobile_rs/service_locator.dart';
import 'package:mobile_rs/services/item_service.dart';
import 'package:mobile_rs/services/skill_service.dart';
import 'package:path_provider/path_provider.dart';

class ActivityService {
  ItemService _itemService = locator<ItemService>();
  SkillService _skillService = locator<SkillService>();

  Future<List<Activity>> getActivities() async {
    String json = await _loadJsonActivityFile();

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

  Future<File> createActivity(Activity activity) async {
    List<Activity> activities = await getActivities();

    activities.add(activity);

    var json = jsonEncode(activities.map((e) => e.toJson()).toList());

    print(json);

    final file = await _getLocalActivityFile();

    return file.writeAsString(json.toString(), mode: FileMode.write);
  }

  Future<String> _loadJsonActivityFile() async {
    try {
      final file = await _getLocalActivityFile();

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return null;
    }
  }

  Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _getLocalActivityFile() async {
    final path = await _getLocalPath();
    print(path);
    return File('$path/activities.json');
  }

  Future<List<Activity>> getActivitiesBySkillAndName(
      Skill skill, String activitySearch) async {
    List<Activity> activities = await getActivitiesBySkill(skill);

    List<Activity> activitiesByName = List<Activity>();

    for (Activity activity in activities) {
      if (activity.name.toLowerCase().contains(activitySearch.toLowerCase())) {
        activitiesByName.add(activity);
      }
    }

    return activitiesByName;
  }

  Future<bool> canExecuteActivity(Activity activity, int nTimes) async {
    List<Item> items = await _itemService.getItems();
    Skill skill = await _skillService.getSkillByName(activity.skill);

    bool levelRequirement = false;
    bool itemRequirements = false;

    if (_skillService.currentLvlByExp(skill.skillExperience) >=
        activity.levelRequirement) {
      levelRequirement = true;
    }

    List<bool> metItemRequirements = List<bool>();

    for (Item itemRequirement in activity.itemRequirements) {
      for (Item item in items) {
        if (itemRequirement.itemName == item.itemName) {
          if (itemRequirement.itemType == ItemType.Tool) {
            if (itemRequirement.itemAmount <= item.itemAmount) {
              print(
                  '${itemRequirement.itemType}, ${itemRequirement.itemName}, ${itemRequirement.itemAmount}:${item.itemType}, ${item.itemName}, ${item.itemAmount}');
              metItemRequirements.add(true);
            }
          } else {
            if (itemRequirement.itemAmount * nTimes <= item.itemAmount) {
              print(
                  '${itemRequirement.itemType}, ${itemRequirement.itemName}, ${itemRequirement.itemAmount}:${item.itemType}, ${item.itemName}, ${item.itemAmount}');
              metItemRequirements.add(true);
            }
          }
        }
      }
    }

    if (activity.itemRequirements.length == metItemRequirements.length) {
      itemRequirements = true;
    }

    return itemRequirements && levelRequirement;
  }

  Future<Activity> executeActivity(Activity activity, int nTimes) async {
    // check itemReqs for tools
    // remove (items * nTimes) which are not tools
    for (Item item in activity.itemRequirements) {
      if (item.itemType != ItemType.Tool) {
        item.itemAmount *= nTimes;
        await _itemService.removeItem(item);
      }
    }

    // add experienceReward * nTimes to skill
    await _skillService.addExperienceToSkill(
        activity.skill, activity.experienceReward * nTimes);

    // add itemReward * nTimes to items
    for (Item item in activity.itemRewards) {
      item.itemAmount *= nTimes;
      await _itemService.addItem(item);
    }

    return activity;
  }
}
