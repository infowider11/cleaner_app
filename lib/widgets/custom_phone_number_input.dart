// import 'package:flutter/material.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
//
// import '../constants/colors.dart';
// import 'CustomTexts.dart';
//
//
// class CustomPhoneNumberInput extends StatelessWidget {
//   final TextEditingController controller;
//   // final String headingText;
//   final String hintText;
//   final PhoneNumber initialNumber;
//   final Function(PhoneNumber) onInputChanged;
//   final Function(bool) onInputValidated;
//
//   const CustomPhoneNumberInput({
//     Key? key,
//     required this.controller,
//     required this.hintText,
//     // required this.headingText,
//     required this.initialNumber,
//     required this.onInputChanged,
//     required this.onInputValidated
//   }) : super(key: key);
//
//   get bgColor => null;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 68,
//       margin: EdgeInsets.symmetric(
//           horizontal: 0, vertical: 8),
//       decoration: BoxDecoration(
//           color: MyColors.inputcolor,
//           // border: Border.all(color: MyColors.darkGreyColor),
//           // border: border,
//           borderRadius: BorderRadius.circular(15)),
//       // padding: EdgeInsets.only(left: 10),
//       child: InternationalPhoneNumberInput(
//         textAlign: TextAlign.start,
//         initialValue: initialNumber,
//         inputDecoration: const InputDecoration(
//
//             hintText: 'Phone Number',
//             hintStyle: TextStyle(color:Colors.white,fontSize: 14),
//             // icon: Icon(Icons.phone_outlined),
//
//
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.only(left: 0,top: 0,right: 0, bottom: 0)
//           // labelText: 'Label text',
//           // labelStyle: TextStyle(
//           // color: Color(0xFF6200EE),
//           // ),
//         ),
//         onInputChanged: onInputChanged,
//         onInputValidated: onInputValidated,
//         selectorConfig: SelectorConfig(
//             selectorType: PhoneInputSelectorType.DIALOG,
//             setSelectorButtonAsPrefixIcon: true,
//             showFlags: false,
//             trailingSpace: false
//         ),
//         ignoreBlank: false,
//         autoValidateMode: AutovalidateMode.disabled,
//         selectorTextStyle: TextStyle(color: Colors.white),
//         //initialValue: number,
//         textFieldController: controller,
//         formatInput: false,
//         keyboardType:
//         TextInputType.numberWithOptions(signed: true, decimal: true),
//         onSaved: (PhoneNumber number) {
//           print('On Saved: $number');
//         },
//         spaceBetweenSelectorAndTextField:0,
//
//       ),
//     );
//   }
// }
