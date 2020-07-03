import 'package:flutter/material.dart';
import 'package:mobile_rs/screens/login_screen.dart';
import 'package:mobile_rs/screens/signup_screen.dart';
import 'package:mobile_rs/screens/welcome_screen.dart';
import 'package:mobile_rs/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile RS',
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      routes: {
        LoginScreen.id: (context) => LoginScreen(),
        SignupScreen.id: (context) => SignupScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
      },
    );
  }
}
