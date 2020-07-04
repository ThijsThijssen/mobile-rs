import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/services/item_service.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../service_locator.dart';

class ItemsScreen extends StatefulWidget {
  static final String id = 'items_screen';

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _formKey = GlobalKey<FormState>();

  String _itemSearch;
  final _itemSearchController = TextEditingController();

  FirebaseUser loggedInUser;
  bool showSpinner = false;

  List<Item> items = [];

  ItemService _itemService = locator<ItemService>();

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      setState(() {
        showSpinner = true;
      });

      items = [];
      items = await _itemService.getItemsByName(_itemSearch);

      setState(() {
        showSpinner = false;
      });

      _itemSearchController.clear();
    }
  }

  _clear() {
    _getItems();
    _itemSearchController.clear();
  }

  void _getItems() async {
    setState(() {
      showSpinner = true;
    });

    items = [];
    items = await _itemService.getItems();

    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getItems();
  }

  @override
  void dispose() {
    _itemSearchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              'Items',
              style: TextStyle(
                fontSize: 55.0,
                fontFamily: 'Runescape',
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 0.0,
                  ),
                  child: IconButton(
                    onPressed: _clear,
                    icon: Icon(Icons.clear),
                    iconSize: 25.0,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                    child: TextFormField(
                      controller: _itemSearchController,
                      decoration: InputDecoration(labelText: 'Search item'),
                      validator: (input) => input.trim().isEmpty
                          ? 'Enter an item to search'
                          : null,
                      onSaved: (input) => _itemSearch = input,
                      style: TextStyle(
                        fontFamily: 'Runescape',
                        fontSize: 25.0,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _submit,
                  icon: Icon(Icons.search),
                  iconSize: 50.0,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  if (item != null) {
                    return Card(
                      child: ListTile(
                        leading: Image(
                          image: AssetImage(
                              'assets/img/items/${item.itemImage}.png'),
                          width: 50.0,
                        ),
                        title: Text(
                          item.itemName,
                          style: TextStyle(
                            fontFamily: 'Runescape',
                            fontSize: 25.0,
                          ),
                        ),
                        subtitle: Text(
                          'Amount: ${item.itemAmount}',
                          style: TextStyle(
                            fontFamily: 'Runescape',
                            fontSize: 20.0,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.more_vert),
                          onPressed: () {},
                        ),
                      ),
                    );
                  } else {
                    return null;
                  }
                }),
          ),
        ],
      ),
    );
  }
}
