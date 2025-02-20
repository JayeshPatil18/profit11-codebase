
import 'package:flutter/material.dart';

import 'dialog_box.dart';

Future<bool> onWillPop(BuildContext context) async {
  final value = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CustomDialogBox(
            title: Text('Are you sure you want to exit?',
                style: TextStyle(fontSize: 16)),
            content: null,
            textButton1: TextButton(
              child: Text('Yes, exit', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            textButton2: TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ));
      });
  return value != null ? value : false;
}