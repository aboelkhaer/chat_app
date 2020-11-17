import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context) {
  return AppBar(
    title: Text('My Chate'),
  );
}

InputDecoration textFieldInputDecoration({String lableText, Icon icon}) {
  return InputDecoration(
    prefixIcon: icon,
    labelText: lableText,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(),
    ),
  );
}

TextStyle textStyle() {
  return TextStyle(color: Colors.grey[700], fontSize: 16);
}
