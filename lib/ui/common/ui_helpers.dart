import 'package:flutter/material.dart';

bool isPortraitOrientation(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}
