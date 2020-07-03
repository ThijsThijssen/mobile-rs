enum Items { coins }

extension ItemsExtension on Items {
  static const itemIds = {Items.coins: 0};

  static const itemNames = {Items.coins: 'Coins'};

  static const itemImages = {Items.coins: 'coins'};

  int get itemId => itemIds[this];
  String get itemName => itemNames[this];
  String get itemImage => itemImages[this];
}
