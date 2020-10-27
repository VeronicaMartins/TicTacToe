import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String image;
  final Function onPressed;

  const CustomDialog({
    this.title,
    this.message,
    this.image,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Container(
        constraints: BoxConstraints.expand(height: 300),
        alignment: Alignment.center,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
        ),
      ),
      actions: [
        FlatButton(
          child: Text(RESET_BUTTON_LABEL),
          onPressed: () {
            Navigator.pop(context);
            onPressed();
          },
        ),
      ],
    );
  }
}
