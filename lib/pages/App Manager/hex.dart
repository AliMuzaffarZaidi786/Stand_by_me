
import 'package:flutter/material.dart';

Color hexToColor(String hexColor) {
  hexColor = hexColor.replaceAll("#", "");
  int parsedColor = int.parse(hexColor, radix: 16) + 0xFF000000;
  return Color(parsedColor);
}




