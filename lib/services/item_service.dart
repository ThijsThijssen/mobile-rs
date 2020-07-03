import 'package:mobile_rs/dao/item_dao.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/service_locator.dart';

class ItemService {
  ItemDAO _itemDAO = locator<ItemDAO>();

  Future<List<Item>> getItems() async {
    return _itemDAO.getItems();
  }

  Future<List<Item>> getItemsByName(String itemName) async {
    return _itemDAO.getItemsByName(itemName);
  }

  Future<Item> addItem(Item item) async {
    return _itemDAO.addItem(item);
  }
}
