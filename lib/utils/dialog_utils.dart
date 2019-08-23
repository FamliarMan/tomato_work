import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showInfoDialog(BuildContext context, String msg) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(child: Text("提示")),
            content: Text(msg, textAlign: TextAlign.center),
            actions: <Widget>[
              FlatButton(
                child: Text("确认"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
