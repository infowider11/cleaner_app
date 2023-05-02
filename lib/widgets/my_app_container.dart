import 'package:flutter/material.dart';

import '../constants/global_constants.dart';

class MyContainer extends StatelessWidget {
  final double? width;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final double? height;
  final BoxDecoration? decoration;
  final Widget? child;
  const MyContainer({
    Key? key,
    this.width,
    this.child,
    this.decoration,
    this.height,
    this.margin,
    this.padding = const EdgeInsets.symmetric(horizontal: MyGlobalConstants.appHorizontalPaddingBig),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width:width?? MediaQuery.of(context).size.width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: decoration,
      child: child,
    );
  }
}
