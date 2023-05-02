import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future showCustomDialog( BuildContext context, {required Widget child,}){
  return showDialog(context: context, builder: (context){
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(30.0)), //this right here
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: child,
      ),
    );
  });
}


// return Dialog(
// shape: RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(30.0)), //this right here
// child: Container(
// height: 200,
// child: Padding(
// padding: const EdgeInsets.all(16.0),
// child: Column(
// children: [
// Row(
// mainAxisAlignment:MainAxisAlignment.spaceBetween,
// children: [
// Container(),
// Text('Add Ingredients',style: TextStyle(fontSize:20 ,fontFamily: 'PlayfairDisplayMedium'),),
// GestureDetector(
// behavior: HitTestBehavior.opaque,
// onTap: (){
// Navigator.pop(context);
// },
// child: CustomCircularImage(imageUrl:MyImages.cancle,height:20,width: 20,),
// ),
// Row(
// children: [
// Image.asset(MyImages.sms,height:15,),
// hSizedBox05,
// ParagraphText('Ingredient Name',color: Color(0xff737988),fontSize:12,fontFamily: 'OpenSansSemiBold',),
// ],
// ),
// CustomTextField(
// controller: code,
// hintText: 'Tomato',
// bgColor: Color(0xffffffff),
// hintcolor: Color(0xff1D1F21),
// keyboardType: TextInputType.emailAddress,
// ),
//
// ],
// )
//
// ],
// ),
// ),
// ),
// );