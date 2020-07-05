// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return Activity(
    name: json['name'] as String,
    image: json['image'] as String,
    skill: json['skill'] as String,
    levelRequirement: json['levelRequirement'] as int,
    itemRequirements: (json['itemRequirements'] as List)
        ?.map(
            (e) => e == null ? null : Item.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    experienceReward: json['experienceReward'] as int,
    itemRewards: (json['itemRewards'] as List)
        ?.map(
            (e) => e == null ? null : Item.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'name': instance.name,
      'image': instance.image,
      'skill': instance.skill,
      'levelRequirement': instance.levelRequirement,
      'itemRequirements':
          instance.itemRequirements?.map((e) => e?.toJson())?.toList(),
      'experienceReward': instance.experienceReward,
      'itemRewards': instance.itemRewards?.map((e) => e?.toJson())?.toList(),
    };
