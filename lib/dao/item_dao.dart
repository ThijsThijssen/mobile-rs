import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_rs/domain/item.dart';

class ItemDAO {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser user;

  Future<List<Item>> getItems() async {
    if (_auth.currentUser() != null) {
      user = await _auth.currentUser();

      List<dynamic> mapItems = [];

      await _firestore
          .collection('items')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot ds) {
        if (ds.exists) {
          mapItems = ds.data['items'];
        } else {
          mapItems = null;
        }
      });

      List<Item> items = [];

      if (mapItems != null) {
        for (Map<String, dynamic> mapItem in mapItems) {
          items.add(mapToItem(mapItem));
        }
      }

      return items;
    } else {
      // user is not authenticated throw error
      return null;
    }
  }

  Future<List<Item>> getItemsByName(String itemName) async {
    List<Item> allItems = await getItems();
    List<Item> itemsByName = [];

    for (Item item in allItems) {
      if (item.itemImage.contains(itemName)) {
        itemsByName.add(item);
      }
    }

    return itemsByName;
  }

  Item mapToItem(Map<String, dynamic> mapItem) {
    return Item(
        itemId: mapItem['itemId'],
        itemName: mapItem['itemName'],
        itemAmount: mapItem['itemAmount'],
        itemImage: mapItem['itemImage']);
  }

  Future<Item> addItem(Item newItem) async {
    if (_auth.currentUser() != null) {
      user = await _auth.currentUser();

      List<Item> items = await getItems();

      bool itemExists = false;

      for (Item existingItem in items) {
        if (existingItem.itemId == newItem.itemId) {
          // item exists
          itemExists = true;

          // update amount
          existingItem.itemAmount += newItem.itemAmount;
        }
      }

      if (!itemExists) {
        items.add(newItem);
      }

      _updateItems(items);

      return newItem;
    } else {
      return null;
    }
  }

  Future<Item> removeItem(Item itemToRemove) async {
    List<Item> items = await getItems();

    Item removeItem;

    for (Item existingItem in items) {
      if (existingItem.itemId == itemToRemove.itemId) {
        if (itemToRemove.itemAmount >= existingItem.itemAmount) {
          removeItem = existingItem;
        }

        existingItem.itemAmount -= itemToRemove.itemAmount;
      }
    }

    if (removeItem != null) {
      items.remove(removeItem);
    }

    await _updateItems(items);

    return itemToRemove;
  }

  void _updateItems(List<Item> items) async {
    // convert normal items to firestore format
    List<Map<String, dynamic>> dbItems = List<Map<String, dynamic>>();

    for (Item existingItem in items) {
      dbItems.add(existingItem.toMap());
    }

    // update item list
    await _firestore
        .collection('items')
        .document(user.uid)
        .setData({'items': dbItems});
  }
}
