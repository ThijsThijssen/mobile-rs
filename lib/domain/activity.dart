import 'package:json_annotation/json_annotation.dart';

import 'item.dart';

part 'activity.g.dart';

@JsonSerializable(explicitToJson: true)
class Activity {
  Activity(
      {this.name,
      this.image,
      this.skill,
      this.levelRequirement,
      this.itemRequirements,
      this.experienceReward,
      this.itemRewards});

  String name;
  String image;
  String skill;
  int levelRequirement;
  List<Item> itemRequirements;
  int experienceReward;
  List<Item> itemRewards;

  factory Activity.fromJson(Map<String, dynamic> data) =>
      _$ActivityFromJson(data);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}
