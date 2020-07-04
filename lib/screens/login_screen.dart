import 'package:flutter/material.dart';
import 'package:mobile_rs/screens/signup_screen.dart';
import 'package:mobile_rs/screens/welcome_screen.dart';
import 'package:mobile_rs/services/user_service.dart';
import 'package:mobile_rs/widgets/sign_in_up_button.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../service_locator.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  bool showSpinner = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final UserService _userService = locator<UserService>();

  _submit() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        setState(() {
          showSpinner = true;
        });

        if (await _userService.signIn(_email, _password)) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        }

        setState(() {
          showSpinner = false;
          _emailController.clear();
          _passwordController.clear();
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
                'Mobile RS',
                style: TextStyle(
                  fontFamily: 'Runescape',
                  fontSize: 55.0,
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
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                        style: TextStyle(
                          fontFamily: 'Runescape',
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(labelText: 'Password'),
                        validator: (input) => input.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                        style: TextStyle(
                          fontFamily: 'Runescape',
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SignInUpButton(
                      buttonText: 'Login',
                      onPressed: _submit,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SignInUpButton(
                      buttonText: 'Go to Signup',
                      onPressed: () =>
                          Navigator.pushNamed(context, SignupScreen.id),
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
