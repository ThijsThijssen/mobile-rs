import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_rs/domain/item.dart';
import 'package:mobile_rs/widgets/sign_in_up_button.dart';

class SkillsScreen extends StatefulWidget {
  static final String id = 'skills_screen';

  @override
  _SkillsScreenState createState() => _SkillsScreenState();
}

class _SkillsScreenState extends State<SkillsScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  FirebaseUser loggedInUser;
  bool showSpinner = false;

  final _formKey = GlobalKey<FormState>();

  String _itemId, _itemName, _itemAmount, _itemImage;

  final _itemIdController = TextEditingController();
  final _itemNameController = TextEditingController();
  final _itemAmountController = TextEditingController();
  final _itemImageController = TextEditingController();

  dynamic items;

  _getCurrentItems() async {
    DocumentSnapshot ds =
        await _firestore.collection('items').document(loggedInUser.uid).get();

    if (ds.exists) {
      items = ds.data['items'];
    } else {
      items = List<Map<String, dynamic>>();
    }
  }

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      await _getCurrentItems();

      final item = Item(
          itemId: int.parse(_itemId),
          itemName: _itemName,
          itemAmount: int.parse(_itemAmount),
          itemImage: _itemImage);

      bool addItem = true;

      for (Map<String, dynamic> map in items) {
        if (map['itemId'] == item.itemId) {
          print(
              'item already exists, updating amount from ${map['itemAmount']}');
          map['itemAmount'] += item.itemAmount;
          print('to ${map['itemAmount']}');

          addItem = false;
        }
      }

      if (addItem) {
        print('added item to list');
        items.add(item.toMap());
      }

      if (loggedInUser != null) {
        await _firestore
            .collection('items')
            .document(loggedInUser.uid)
            .setData({'items': items});
      } else {
        print('Nobody is logged in...');
      }

      _itemIdController.clear();
      _itemNameController.clear();
      _itemAmountController.clear();
      _itemImageController.clear();
    }
  }

  void getCurrentUser() async {
    try {
      setState(() {
        showSpinner = true;
      });

      final user = await _auth.currentUser();

      if (user != null) {
        loggedInUser = user;
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

  @override
  void initState() {
    super.initState();

    getCurrentUser();
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
                    controller: _itemIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Item ID'),
                    onSaved: (input) => _itemId = input,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _itemNameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                    onSaved: (input) => _itemName = input,
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
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    controller: _itemImageController,
                    decoration: InputDecoration(labelText: 'Item Image'),
                    onSaved: (input) => _itemImage = input,
                  ),
                ),
                SignInUpButton(
                  buttonText: 'Add item',
                  onPressed: _submit,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
