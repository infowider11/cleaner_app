import 'package:cleanerapp/constants/box_shadow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../constants/colors.dart';
import '../constants/sized_box.dart';
import 'CustomTexts.dart';

class DropDown extends StatefulWidget {
  final String label;
  final Color? labelcolor;
  final double? fontsize;
  final double? width;
  final double? height;
  final double? dropdownwidth;
  final List<String> items;
  final bool islabel;
  late final String? selectedValue;
  final Function(String?)? onChange;


   DropDown({
    Key? key,
    this.width=100,
    this.height=26,
    this.dropdownwidth=100,
    this.selectedValue,
    this.label = 'laokjkbel',
    this.labelcolor = MyColors.bordercolor,
    this.fontsize = 14,
    this.items = const [
      'All',
      'Option 1',
      'Option 2',
      'Option 3',
      'Option 4',
    ],
    this.islabel = true,
    this.onChange,

  }) : super(key: key);

  @override
  State<DropDown> createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  // final List<String> items = [
  //   'All',
  //   'Option 1',
  //   'Option 2',
  //   'Option 3',
  //   'Option 4',
  // ];


  @override
  Widget build(BuildContext context) {

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton2(
              isExpanded: true,
              hint: Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
                overflow: TextOverflow.ellipsis,
              ),
              items: widget.items
                  .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ))
                  .toList(),
              value: widget.selectedValue,
              onChanged:widget.onChange ??
                  (value) {
                setState(() {
                  widget.selectedValue = value as String?;
                });
              },
              icon: const Icon(
                Icons.expand_more_outlined,
              ),
              iconSize:14,
              iconEnabledColor: MyColors.bordercolor,
              iconDisabledColor: Colors.grey,
              buttonHeight:widget.height,
              buttonWidth: widget.width,
              // MediaQuery.of(context).size.width,
              buttonPadding: const EdgeInsets.only(left:10, right:10),
              buttonDecoration: BoxDecoration(
                boxShadow: [shadow],
                borderRadius: BorderRadius.circular(5),
                // border: Border.all(
                //   color: MyColors.primaryColor,
                // ),
                // color: MyColors.primaryColor,
                color: Colors.white,
              ),
              buttonElevation: 0,
              itemHeight: 30,
              itemPadding: const EdgeInsets.only(left: 14, right: 14),
              dropdownMaxHeight: 200,
              dropdownWidth:widget.dropdownwidth,
              // MediaQuery.of(context).size.width - 32,
              dropdownPadding: null,
              dropdownDecoration: BoxDecoration(
                boxShadow: [shadow],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
                // border: Border.all(
                //   color: MyColors.primaryColor,
                // ),

              ),
              dropdownElevation: 0,
              scrollbarRadius: const Radius.circular(40),
              scrollbarThickness: 6,
              scrollbarAlwaysShow: true,
              offset: const Offset(0, 0),
            ),
          ),
        ],
      ),
    );
  }
}
