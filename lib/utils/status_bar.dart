import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBar {
  static void setStyle({required bool isDarkBackground}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkBackground ? Brightness.light : Brightness.dark, // Android
      statusBarBrightness: isDarkBackground ? Brightness.dark : Brightness.light,     // iOS
    ));
  }

  static void setModeByOrientation(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }
}