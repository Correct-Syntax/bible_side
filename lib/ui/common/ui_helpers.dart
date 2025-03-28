import 'package:flutter/material.dart';

bool isPortraitOrientation(BuildContext context) {
  return MediaQuery.of(context).orientation == Orientation.portrait;
}

bool shouldSwitchToWideLayout(BuildContext context) {
  // Over 500px width, switch to the wide layout.
  return MediaQuery.of(context).size.width > 500;
}
