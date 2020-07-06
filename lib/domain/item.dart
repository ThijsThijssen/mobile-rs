import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_rs/domain/item_type.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  Item(
      {this.itemId,
      this.itemName,
      this.itemAmount,
      this.itemImage,
      this.itemType});

  int itemId;
  String itemName;
  int itemAmount;
  String itemImage;
  ItemType itemType;

  @override
  String toString() {
    return "{ 'itemId': $itemId, "
        "'itemName': $itemName, "
        "'itemAmount': $itemAmount, "
        "'itemImage': $itemImage }";
  }

  Map<String, dynamic> toMap() {
    return {
      'itemId': itemId,
      'itemName': itemName,
      'itemAmount': itemAmount,
      'itemImage': itemImage
    };
  }

  factory Item.fromJson(Map<String, dynamic> data) => _$ItemFromJson(data);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
