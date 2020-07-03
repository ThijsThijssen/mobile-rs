import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/domain/items.dart';
import 'package:mobile_rs/services/item_service.dart';
import 'package:mobile_rs/widgets/sign_in_up_button.dart';

import '../service_locator.dart';

class SkillsScreen extends StatefulWidget {
  static final String id = 'skills_screen';

  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  FirebaseUser loggedInUser;
  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  String _itemAmount;

  final _itemIdController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemAmountController = TextEditingController();
  final _itemImageController = TextEditingController();

  dynamic items;

  ItemService _itemService = locator<ItemService>();

  _addItem() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final item = Item(
          itemId: Items.coins.itemId,
          itemName: Items.coins.itemName,
          itemAmount: int.parse(_itemAmount),
          itemImage: Items.coins.itemImage);

      await _itemService.addItem(item);

      _itemIdController.clear();
      _itemNameController.clear();
      _itemAmountController.clear();
      _itemImageController.clear();
    }
  }

  _removeItem() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final item = Item(
          itemId: Items.coins.itemId,
          itemName: Items.coins.itemName,
          itemAmount: int.parse(_itemAmount),
          itemImage: Items.coins.itemImage);

      await _itemService.removeItem(item);

      _itemIdController.clear();
      _itemNameController.clear();
      _itemAmountController.clear();
      _itemImageController.clear();
    }
  }

  @override
  void dispose() {
    _itemIdController.dispose();
    _itemNameController.dispose();
    _itemAmountController.dispose();
    _itemImageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Add items to db',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _itemAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Item Amount'),
                    onSaved: (input) => _itemAmount = input,
                  ),
                ),
                SignInUpButton(
                  buttonText: 'Add item',
                  onPressed: _addItem,
                ),
                SignInUpButton(
                  buttonText: 'Remove item',
                  onPressed: _removeItem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
