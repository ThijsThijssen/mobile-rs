import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ItemsScreen extends StatefulWidget {
  static final String id = 'items_screen';

  @override
  _ItemsScreenState createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();

  String _itemSearch;
  final _itemSearchController = TextEditingController();

  FirebaseUser loggedInUser;
  bool showSpinner = false;

  dynamic items = [{}];

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await _getItems(loggedInUser);

      // search for items containing search term in name
      List<Map<String, dynamic>> searchedItems = [{}];

      for (Map<String, dynamic> mapItem in items) {
        Item item = _mapToItem(mapItem);

        if (item.itemName.contains(_itemSearch)) {
          searchedItems.add(mapItem);
          print(mapItem);
        }
      }

      if (searchedItems.length == 0) {
        searchedItems.add({
          'itemId': 404,
          'itemName': 'Not Found',
          'itemAmount': '',
          'itemImage': 'not_found'
        });
      }

      setState(() {
        items = searchedItems;
      });

      _itemSearchController.clear();
    }
  }

  Item _mapToItem(Map<String, dynamic> map) {
    return Item(
        itemId: map['itemId'],
        itemName: map['itemName'],
        itemAmount: map['itemAmount'],
        itemImage: map['itemImage']);
  }

  _clear() {
    // remove search filter from stream
    _getItems(loggedInUser);

    _itemSearchController.clear();
  }

  _getCurrentUser() async {
    try {
      setState(() {
        showSpinner = true;
      });

      final user = await _auth.currentUser();

      if (user != null) {
        loggedInUser = user;
        print('${user.uid} logged in');

        await _getItems(user);
      }

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      setState(() {
        showSpinner = false;
      });
      print(e);
    }
  }

  Future _getItems(FirebaseUser user) async {
    setState(() {
      showSpinner = true;
    });

    await _firestore
        .collection('items')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot ds) {
      if (ds.exists) {
        items = ds.data['items'];
      } else {
        items = [{}];
      }
    });

    setState(() {
      showSpinner = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _getCurrentUser();
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
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 15.0,
                    vertical: 15.0,
                  ),
                  child: IconButton(
                    onPressed: _submit,
                    icon: Icon(Icons.search),
                    iconSize: 50.0,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];

                  return Card(
                    child: ListTile(
                      leading: Image(
                        image: AssetImage(showSpinner == false
                            ? 'assets/img/items/${item['itemImage']}.png'
                            : ''),
                        width: 50.0,
                      ),
                      title: Text(
                          showSpinner == false ? item['itemName'] ?? '' : ''),
                      subtitle: Text(showSpinner == false
                          ? 'Amount: ${item['itemAmount']}'
                          : ''),
                      trailing: IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {},
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
