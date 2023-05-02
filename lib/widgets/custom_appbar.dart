import 'package:flutter/material.dart';
class Customappbar extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? action;

  const Customappbar({Key? key,required this.title,this.action,this.leading}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(60),
      child: AppBar(
        leading:leading,
        backgroundColor: Color(0xff332f2e),
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
      bottom: Radius.circular(20),
      ),
      ),
      title:Text(title,style: TextStyle(fontFamily: 'PoppinsRegular',fontSize: 15),),
      centerTitle: true, actions: action,
      ),
    );
  }
}
