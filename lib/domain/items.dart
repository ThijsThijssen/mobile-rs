enum Items { Coins, Bronze_dagger, Dragon_claws }

extension ItemsExtension on Items {
  static const itemIds = {
    Items.Coins: 0,
    Items.Bronze_dagger: 1,
    Items.Dragon_claws: 2,
  };

  static const itemNames = {
    Items.Coins: 'Coins',
    Items.Bronze_dagger: 'Bronze dagger',
    Items.Dragon_claws: 'Dragon claws',
  };

  static const itemImages = {
    Items.Coins: 'coins',
    Items.Bronze_dagger: 'bronze_dagger',
    Items.Dragon_claws: 'dragon_claws',
  };

  int get itemId => itemIds[this];
  String get itemName => itemNames[this];
  String get itemImage => itemImages[this];
}
