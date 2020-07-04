import 'package:flutter/material.dart';

class SignInUpButton extends StatelessWidget {
  SignInUpButton({@required this.buttonText, @required this.onPressed});
  final String buttonText;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250.0,
      child: OutlineButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        color: Colors.blue,
        padding: EdgeInsets.all(10.0),
        child: Text(
          '$buttonText',
          style: TextStyle(
            fontFamily: 'Runescape',
            color: Colors.black,
            fontSize: 25.0,
          ),
        ),
      ),
    );
  }
}
