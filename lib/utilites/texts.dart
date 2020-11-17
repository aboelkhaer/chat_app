import 'package:flutter/material.dart';

TextSpan textSpanTitle(String title) {
  return TextSpan(
    text: title,
    style: TextStyle(
        color: Color(0xFF7ca7e2),
        fontWeight: FontWeight.bold,
        fontSize: 25,
        fontFamily: 'Courgette'),
  );
}

TextSpan textSpanMarkTitle(String mark) {
  return TextSpan(
      text: mark, style: TextStyle(color: Colors.black, fontSize: 26));
}
