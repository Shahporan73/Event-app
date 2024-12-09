import 'package:flutter/material.dart';

class ResponsiveHelper {
  static const double baseWidth = 360.0;  // Figma design width
  static const double baseHeight = 800.0; // Figma design height
  static double w(BuildContext context, double width) {
    final screenWidth = MediaQuery.of(context).size.width;
    return (screenWidth / baseWidth) * width;
  }

  static double h(BuildContext context, double height) {
    final screenHeight = MediaQuery.of(context).size.height;
    return (screenHeight / baseHeight) * height;
  }
}