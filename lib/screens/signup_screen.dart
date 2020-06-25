import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_rs/screens/welcome_screen.dart';
import 'package:mobile_rs/widgets/sign_in_up_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignupScreen extends StatefulWidget {
  static String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = Firestore.instance;

  final _formKey = GlobalKey<FormState>();
  String _username, _email, _password;

  bool showSpinner = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

//      _firestore
//          .collection('account')
//          .where('username', isEqualTo: _username)
//          .snapshots()
//          .listen((data) => data.documents.forEach((doc) => print(doc['username'])));

      try {
        setState(() {
          showSpinner = true;
        });

        final newUser = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        if (newUser != null) {
          print(newUser.user.uid);
          print(_username);

          _firestore.collection('account').document(newUser.user.uid).setData({
            'uid': newUser.user.uid,
            'username': _username,
            'email': _email,
          });

          Navigator.pushNamed(context, WelcomeScreen.id);
        }

        setState(() {
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
          showSpinner = false;
        });
      } catch (e) {
        setState(() {
          showSpinner = false;
        });
        print(e);
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Registration',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 50.0,
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a valid username'
                            : null,
                        onSaved: (input) => _username = input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (input) => input.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SignInUpButton(
                      buttonText: 'Sign Up',
                      onPressed: _submit,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SignInUpButton(
                      buttonText: 'Back to Login',
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
