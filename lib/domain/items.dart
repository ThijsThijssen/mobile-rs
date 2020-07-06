import 'package:mobile_rs/domain/item_type.dart';

enum Items { Coins, Bronze_dagger, Dragon_claws, Hammer, Bronze_bar }

extension ItemsExtension on Items {
  static const itemIds = {
    Items.Coins: 0,
    Items.Bronze_dagger: 1,
    Items.Dragon_claws: 2,
    Items.Hammer: 3,
    Items.Bronze_bar: 4,
  };

  static const itemNames = {
    Items.Coins: 'Coins',
    Items.Bronze_dagger: 'Bronze dagger',
    Items.Dragon_claws: 'Dragon claws',
    Items.Hammer: 'Hammer',
    Items.Bronze_bar: 'Bronze bar'
  };

  static const itemImages = {
    Items.Coins: 'coins',
    Items.Bronze_dagger: 'bronze_dagger',
    Items.Dragon_claws: 'dragon_claws',
    Items.Hammer: 'hammer',
    Items.Bronze_bar: 'bronze_bar',
  };

  static const itemTypes = {
    Items.Coins: ItemType.Other,
    Items.Bronze_dagger: ItemType.Armour,
    Items.Dragon_claws: ItemType.Armour,
    Items.Hammer: ItemType.Tool,
    Items.Bronze_bar: ItemType.Other,
  };

  int get itemId => itemIds[this];
  String get itemName => itemNames[this];
  String get itemImage => itemImages[this];
  ItemType get itemType => itemTypes[this];
}
