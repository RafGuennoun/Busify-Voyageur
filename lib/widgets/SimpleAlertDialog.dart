
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SimpleAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  const SimpleAlertDialog({required this.title ,required this.content });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        CupertinoDialogAction(
            child: Text(
              "OK",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: ()
            {
              Navigator.of(context).pop();
            }
        ),
      ],
    );
  }
}