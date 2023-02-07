import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UtilToast {
  static showToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        fontSize: 15,
        gravity: ToastGravity.TOP,
        textColor: Colors.white,
        backgroundColor: Colors.deepPurple.withOpacity(0.8));
  }
}
