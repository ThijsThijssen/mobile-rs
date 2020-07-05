// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) {
  return Item(
    itemId: json['itemId'] as int,
    itemName: json['itemName'] as String,
    itemAmount: json['itemAmount'] as int,
    itemImage: json['itemImage'] as String,
  );
}

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
      'itemId': instance.itemId,
      'itemName': instance.itemName,
      'itemAmount': instance.itemAmount,
      'itemImage': instance.itemImage,
    };
