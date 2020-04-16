import 'package:flutter/material.dart';

class Components {
  static snackBar(context, text, color) {
    return Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: color,
    ));
  }
}
