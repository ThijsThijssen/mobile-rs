import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_rs/dao/user_dao.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/domain/items.dart';
import 'package:mobile_rs/services/item_service.dart';
import 'package:mobile_rs/services/skill_service.dart';

import '../service_locator.dart';

class UserService {
  final _auth = FirebaseAuth.instance;

  FirebaseUser user;

  final ItemService _itemService = locator<ItemService>();
  final UserDAO _userDAO = locator<UserDAO>();
  final SkillService _skillService = locator<SkillService>();

  // create account
  Future<bool> createUser(
      String username, String email, String password) async {
    final newUser = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    if (newUser != null) {
      try {
        await _createUserCollection(username, email);
        await _createItemsCollection();
        await _createSkillsCollection();

        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  void _createUserCollection(String username, String email) async {
    await _userDAO.createUserCollection(username, email);
  }

  void _createItemsCollection() async {
    final Item item = Item(
        itemId: Items.Coins.itemId,
        itemName: Items.Coins.itemName,
        itemAmount: 10000,
        itemImage: Items.Coins.itemImage);

    await _itemService.addItem(item);
  }

  void _createSkillsCollection() async {
    await _skillService.createSkillsCollection();
  }

  Future<bool> signIn(String email, String password) async {
    final user = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (user != null) {
      return true;
    }

    return false;
  }

  Future<bool> signOut() async {
    if (_auth.currentUser() != null) {
      _auth.signOut();
      return true;
    } else {
      return false;
    }
  }

  Future<String> getUsername() async {
    return await _userDAO.getUsername();
  }
}
