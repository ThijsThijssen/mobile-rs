import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/activity.dart';
import 'package:mobile_rs/domain/item.dart';
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

    _createActivity();
  }

  _createActivity() async {
    ActivityService _activityService = locator<ActivityService>();

    Activity activity = Activity(
        name: 'Dragon claws',
        image: 'dragon_claws',
        skill: Skills.Smithing.skillName,
        levelRequirement: 80,
        itemRequirements: [
          Item(
              itemId: Items.Bronze_dagger.itemId,
              itemName: Items.Bronze_dagger.itemName,
              itemAmount: 1,
              itemImage: Items.Bronze_dagger.itemImage),
          Item(
              itemId: Items.Dragon_claws.itemId,
              itemName: Items.Dragon_claws.itemName,
              itemAmount: 1,
              itemImage: Items.Dragon_claws.itemImage),
        ],
        experienceReward: 1337,
        itemRewards: [
          Item(
              itemId: Items.Coins.itemId,
              itemName: Items.Coins.itemName,
              itemAmount: 15000,
              itemImage: Items.Coins.itemImage),
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
