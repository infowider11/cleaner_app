import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  const CustomDivider({Key? key, this.thickness = 1, this.color = MyColors.black54Color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        indent: 0,
        endIndent: 0,
        height: thickness,
        color: color,
        thickness: thickness,
      ),
    );
  }
}
