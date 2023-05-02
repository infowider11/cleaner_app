// import 'package:flutter/material.dart';
// import 'package:valetapp/constants/colors.dart';
// import 'package:valetapp/constants/images_url.dart';
// import 'package:valetapp/constants/sized_box.dart';
// import 'package:valetapp/pages/tabscreen.dart';
// import 'package:valetapp/widgets/CustomTexts.dart';
//
// import '../functions/navigation_functions.dart';
// import '../widgets/custom_text_field.dart';
// import '../widgets/round_edged_button.dart';
// import 'loginscreen.dart';
// class SignupScreen extends StatefulWidget {
//   const SignupScreen({Key? key}) : super(key: key);
//
//   @override
//   State<SignupScreen> createState() => _SignupScreenState();
// }
//
// class _SignupScreenState extends State<SignupScreen> {
//   TextEditingController email=TextEditingController();
//   bool check=false;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body:Stack(
//           children: [
//             Stack(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   height: MediaQuery.of(context).size.height,
//                   decoration: BoxDecoration(gradient: MyGradients.linearGradient),
//                   padding: const EdgeInsets.all(16.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         vSizedBox8,
//                         ParagraphText('Sign Up',fontSize: 26,),
//                         ParagraphText('Please enter your details for sign up.',fontSize: 14,color: Color(0xff575757),),
//                         vSizedBox2,
//                         ParagraphText('Full Name',fontSize: 14,),
//                         CustomTextField(
//                           controller: email,
//                           hintText: 'Full Name',
//                           bgColor: Color(0xffffffff),
//                           borderRadius:8,
//                         ),
//                         vSizedBox2,
//                         ParagraphText('Email Address',fontSize: 14,),
//                         CustomTextField(
//                           controller: email,
//                           hintText: 'Email Address',
//                           bgColor: Color(0xffffffff),
//                           borderRadius:8,
//                         ),
//                         vSizedBox2,
//                         ParagraphText('Mobile No.',fontSize: 14,),
//                         CustomTextField(
//                           controller: email,
//                           hintText: 'Mobile No.',
//                           bgColor: Color(0xffffffff),
//                           borderRadius:8,
//                         ),
//                         vSizedBox2,
//                         ParagraphText('Password',fontSize: 14,),
//                         CustomTextField(
//                           controller: email,
//                           hintText: '***********',
//                           bgColor: Color(0xffffffff),
//                           borderRadius:8,
//                         ),
//                         vSizedBox2,
//                         ParagraphText('Confirm Password',fontSize: 14,),
//                         CustomTextField(
//                           controller: email,
//                           hintText: '*********',
//                           bgColor: Color(0xffffffff),
//                           borderRadius:8,
//                         ),
//                         Row(
//                           children: [
//                             Checkbox(
//                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//                                 side:BorderSide(color:MyColors.primaryColor,),
//                                 checkColor: Colors.white,
//                                 activeColor: Color(0xff000000),
//                                 fillColor: MaterialStateProperty.all<Color>((MyColors.primaryColor)),
//                                 value: check, //unchecked
//                                 onChanged: (bool? value){
//                                   setState(() {
//                                     check=!check;
//                                   });
//                                 }
//                             ),
//                             Row(
//                               children: [
//                                 ParagraphText('I agree to the',fontSize: 14,fontWeight: FontWeight.w600,),
//                                 ParagraphText(' terms of service ',color: MyColors.primaryColor,fontSize: 14,),
//                                 ParagraphText('and ',fontSize: 14,fontWeight: FontWeight.w600,),
//                                 ParagraphText(' privacy policy.',color: MyColors.primaryColor,fontSize: 14,),
//
//                               ],
//                             )
//                           ],
//                         ),
//                         RoundEdgedButton(
//                             text: 'Sign Up',
//                             textColor: MyColors.whiteColor,
//                             color: MyColors.primaryColor,
//                             fontSize: 16,
//                             verticalMargin: 0,
//                             isSolid:true,
//                             borderRadius: 8,
//                             onTap: () {
//                               push(context: context, screen: TabScreen());
//                             }),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned(
//                   bottom:300,right:250,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Image.asset(MyImages.login1,height:165,width: 165,),
//                   ),
//                 ),
//               ],
//             ),
//             Align(
//               alignment: Alignment.topRight,
//               child: Image.asset(MyImages.splash1,height:200,width: 200,),
//             ),
//
//           ],
//         )
//
//     );
//
//   }
// }
