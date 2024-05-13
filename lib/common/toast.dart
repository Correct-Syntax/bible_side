import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Shows a toast message with [msg] as the contents
void showToastMsg(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.white,
    textColor: Colors.black87,
    fontSize: 14.0,
  );
}
