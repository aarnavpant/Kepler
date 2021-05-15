import 'package:flutter/material.dart';
Widget appBarMain(BuildContext context)
{
  return AppBar(
    title: Text(
      'Kepler',
      style: TextStyle(
        fontSize: 25,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    ),
  );
}

InputDecoration inpdec(String hintText)
{
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
  );
}

TextStyle simpleTextStyle()
{
  return TextStyle(
    color: Colors.white,
    fontSize: 16,
  );
}