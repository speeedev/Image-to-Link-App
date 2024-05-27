// alert util
import 'package:flutter/material.dart';

class Alert {
  static void showErrorDialog(BuildContext context, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Error"),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }

  static void showSuccessDialog(BuildContext context, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text("Success"),
      content: Text(message),
      actions: <Widget>[
        TextButton(
          child: Text("Ok"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
    showDialog(
        context: context, builder: (BuildContext context) => alertDialog);
  }
}
