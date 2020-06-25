import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_rs/screens/skills_screen.dart';

import '../constants.dart';
import 'items_screen.dart';
import 'login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static final String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedInUser;
  String username;

  final _firestore = Firestore.instance;

  bool showSpinner = false;

  int _selectedIndex = 0;

  List<Widget> kBottomNavigationOptions = <Widget>[
    ItemsScreen(),
    SkillsScreen(),
    Center(
      child: Text('Combat'),
    ),
    Center(
      child: Text('Gear'),
    ),
    Center(
      child: Text('Shop'),
    ),
  ];

  @override
  void initState() {
    super.initState();

    getCurrentUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void getCurrentUser() async {
    try {
      setState(() {
        showSpinner = true;
      });

      final user = await _auth.currentUser();

      if (user != null) {
        loggedInUser = user;

        await _firestore
            .collection('account')
            .document(loggedInUser.uid)
            .get()
            .then((DocumentSnapshot ds) {
          username = ds.data['username'];
        });
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

  _choiceAction(String choice) {
    if (choice == kSignOutPopup) {
      _auth.signOut();
      Navigator.pushReplacementNamed(context, LoginScreen.id);
    }

    if (choice == kAccountPopup) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(username != null ? username : ''),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _choiceAction,
            itemBuilder: (BuildContext context) {
              return kPopupChoices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Row(
                    children: <Widget>[
                      Text(choice),
                      Icon(
                        Icons.clear,
                        color: Colors.black,
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          )
        ],
      ),
      body: kBottomNavigationOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.briefcase),
            title: Text('Items'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.chartBar),
            title: Text('Skills'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.fistRaised),
            title: Text('Combat'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.personBooth),
            title: Text('Gear'),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.dollarSign),
            title: Text('Shop'),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
