import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/activity.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/domain/item_type.dart';
import 'package:mobile_rs/domain/items.dart';
import 'package:mobile_rs/domain/skills.dart';
import 'package:mobile_rs/services/activity_service.dart';
import 'package:mobile_rs/services/item_service.dart';
import 'package:mobile_rs/widgets/sign_in_up_button.dart';

import '../service_locator.dart';

class ShopScreen extends StatefulWidget {
  static final String id = 'shop_screen';

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  String _itemAmount;
  Items selectedItem;

  final _itemAmountController = TextEditingController();

  ItemService _itemService = locator<ItemService>();

  _addItem() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final item = Item(
          itemId: selectedItem.itemId,
          itemName: selectedItem.itemName,
          itemAmount: int.parse(_itemAmount),
          itemImage: selectedItem.itemImage);

      setState(() {
        showSpinner = true;
      });

      await _itemService.addItem(item);

      setState(() {
        showSpinner = false;
      });

      _itemAmountController.clear();
    }
  }

  _removeItem() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      final item = Item(
          itemId: selectedItem.itemId,
          itemName: selectedItem.itemName,
          itemAmount: int.parse(_itemAmount),
          itemImage: selectedItem.itemImage);

      setState(() {
        showSpinner = true;
      });

      await _itemService.removeItem(item);

      setState(() {
        showSpinner = false;
      });

      _itemAmountController.clear();
    }
  }

  @override
  void dispose() {
    _itemAmountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

//    _createActivity();
  }

  _createActivity() async {
    ActivityService _activityService = locator<ActivityService>();

    Activity activity = Activity(
        name: 'Bronze dagger',
        image: 'bronze_dagger',
        skill: Skills.Smithing.skillName,
        levelRequirement: 1,
        itemRequirements: [
          Item(
            itemId: Items.Hammer.itemId,
            itemName: Items.Hammer.itemName,
            itemAmount: 1,
            itemImage: Items.Hammer.itemImage,
            itemType: ItemType.Tool,
          ),
          Item(
            itemId: Items.Bronze_bar.itemId,
            itemName: Items.Bronze_bar.itemName,
            itemAmount: 1,
            itemImage: Items.Bronze_bar.itemImage,
            itemType: ItemType.Other,
          ),
        ],
        experienceReward: 1337,
        itemRewards: [
          Item(
            itemId: Items.Bronze_dagger.itemId,
            itemName: Items.Bronze_dagger.itemName,
            itemAmount: 1,
            itemImage: Items.Bronze_dagger.itemImage,
            itemType: ItemType.Armour,
          ),
        ]);

    await _activityService.createActivity(activity);
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
                  child: DropdownButton<Items>(
                    value: selectedItem,
                    onChanged: (Items newValue) {
                      setState(() {
                        selectedItem = newValue;
                      });
                    },
                    items: Items.values.map((Items items) {
                      return DropdownMenuItem<Items>(
                        value: items,
                        child: Text(
                          items.itemName.toString(),
                        ),
                      );
                    }).toList(),
                  ),
                ),
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
