import 'package:flutter/material.dart';
class Customdropdown extends StatelessWidget {
  final String hint;
  final List item;
  const Customdropdown({Key? key,required this.hint,required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xffeeeeee),
          borderRadius: BorderRadius.circular(30)
      ),
      child: DropdownButtonFormField(
        itemHeight:50,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.all(8),
          border: InputBorder.none,

        ),
        isExpanded: true,
        hint:Text(
          hint,
          style: TextStyle(fontSize: 13,fontFamily: 'PoppinsLight',color: Color(0xff8f8f8f)),
        ),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xff8f8f8f),
        ),
        iconSize: 30,
        items:item.map((item) =>
            DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ))
            .toList(),
        validator: (value) {
          if (value == null) {
            return 'Please select gender.';
          }
        },
        onChanged: (value) {
          //Do something when changing the item if you want.
        },
        onSaved: (value) {
          // selectedValue = value.toString();
        },
      ),
    );

  }
}
