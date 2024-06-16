// import 'package:flutter/material.dart';
//
// class Config {
//   static MediaQueryData? mediaQueryData;
//   static late double screenWidth;
//   static const double screenHeight = 0.05;
//
//   void init(BuildContext context) {
//     mediaQueryData = MediaQuery.of(context);
//     screenWidth = mediaQueryData!.size.width;
//     screenWidth = mediaQueryData!.size.height;
//   }
//
//   static get widthSize {
//     return screenWidth;
//   }
//
//   static get heightSize {
//     return screenHeight;
//   }
//
//   // define spacing height
//   static const spaceSmall = SizedBox(
//     height: 25,
//   );
//
//   static Widget spaceMedium(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return SizedBox(height: screenHeight * 0.05);
//   }
//   static Widget spaceBig(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     return SizedBox(height: screenHeight * 0.08);
//   }
//
//   //textforn field border
//   static const outlinedBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(8)),
//     borderSide: BorderSide(
//       color: Colors.black38,
//     ),
//   );
//   static const errorBorder = OutlineInputBorder(
//     borderRadius: BorderRadius.all(Radius.circular(8)),
//     borderSide: BorderSide(
//       color: Colors.red,
//     ),
//   );
//
//   static const primaryColor = Colors.greenAccent;
// }

import 'package:flutter/material.dart';

class Config {
  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth;
  static late double _screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
  }

  static double get widthSize {
    return _screenWidth;
  }

  static double get heightSize {
    return _screenHeight;
  }

  // Define spacing heights (using proportions of screen height)
  static Widget spaceSmall(BuildContext context) {
    return SizedBox(height: Config.heightSize * 0.03);
  }

  static Widget spaceMedium(BuildContext context) {
    return SizedBox(height: Config.heightSize * 0.05);
  }

  static Widget spaceBig(BuildContext context) {
    return SizedBox(height: Config.heightSize * 0.08);
  }

  // Text form field borders
  static const outlinedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.black38,
    ),
  );

  static const errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.red,
    ),
  );

  static const primaryColor = Colors.greenAccent;
}