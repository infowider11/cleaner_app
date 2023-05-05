import 'package:flutter/material.dart';

class MyColors{
  // Color(0xfff02321),
  // Color(0xff781211),
  static const Color primaryColor = Color(0xff0F3750);
  static const Color arrivalColor = Color(0xfff7f2b2);
  static const Color inHouseColor = Color(0xffc2f7b2);
  static const Color scafoldcolor = Color(0xfff5f5f5);
  static const Color appBgColor = Color(0xff332f2e);
  static const Color lightGreyColor = Color(0xFFe8e9e9);
  static const Color greyColor = Color(0xFFF1F1F1);
  static const Color darkGreyColor = Colors.white24;
  static const Color darkBlueColor = Color(0xFF05445E);
  static const Color seaBlueColor = Color(0xFF189AB4);
  static const Color bgColor = Color(0xFFf2f6ff);
  static const Color amberColor = Colors.amber;
  static const Color redColor = Color(0xFFFF0000);
  static const Color greenColor = Colors.green;
  static const Color borderColor = Color(0xFFf1f1f1);
  static const Color starInActiveColor = Colors.grey;
  static const Color starActiveColor = Color(0xFFFBBC04);
  static const Color hintcolor = Color(0xFF939493);
  static const Color inputcolor = Color(0xFF343333);
  static const Color pink = Color(0xFFFF0160);
  static const Color orange = Color(0xFFFF4600);
  static const Color lightBlackColor = Color(0xFF343333);
  static const Color whiteColor = Colors.white;
  static const Color blackColor = Colors.black;
  static const Color black54Color = Colors.black54;
  static const Color bordercolor = Colors.black;
}

class MyGradients{
  static  LinearGradient linearGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment(0.1, 3),
    colors: [
      Color(0xFFffffff),
      Color(0xFF72BD74).withOpacity(0.5),
    ],
  );
}
// class MyGradients{
//   static const LinearGradient linearGradient = LinearGradient(
//     begin: Alignment.topRight,
//     end: Alignment.bottomLeft,
//     colors: [
//       Color(0xfff02321),
//       Color(0xff781211),
//     ],
//   );
// }