import 'dart:developer';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/constants/sized_box.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../constants/toast.dart';
import '../services/api_urls.dart';
import '../services/webservices.dart';
import '../widgets/round_edged_button.dart';
class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController email=TextEditingController();
  bool load=false;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor:MyColors.primaryColor,
        body:Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSizedBox6,
                Center(child: Image.asset(MyImages.splash,height: 162,width: 162,),),
                vSizedBox,
                ParagraphText('Forgot Password',color: Color(0xffffffff),fontWeight: FontWeight.w600,fontSize: 22,),
                vSizedBox2,
                CustomTextField(
                  controller: email,
                  hintText: 'Email Address',
                  hintcolor: Colors.white,
                  textColor: Colors.white,
                  bgColor:Colors.transparent,
                  borderRadius: 8,
                  keyboardType: TextInputType.emailAddress,
                ),
                vSizedBox2,
                RoundEdgedButton(text: 'Submit', isLoad:load, fontSize: 18,borderRadius: 8,color: Color(0xffffffff),textColor: MyColors.primaryColor,
                  onTap: () async{
                  ///  forget_password validation & api integration
                    if (email.text.length == 0){
                      toast('Please enter email');
                    } else  if(email.text.length > 0 && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email.text)){
                      toast('Please enter valid email');
                    }else{
                      Map<String,dynamic> forget_pass_request={
                        'email':email.text,
                      };

                      setState(() {
                        load=true;
                      });

                      final Response = await http.post(Uri.parse(ApiUrls.forget_password), body: forget_pass_request);
                      var jsonResponse = convert.jsonDecode(Response.body);
                      // final Response= await Webservices.postData(apiUrl: ApiUrls.forget_password , request: forget_pass_request);
                      // log("forget password response---$jsonResponse");
                      // log("status---${jsonResponse['status']}");

                      setState(() {
                        load=false;
                      });

                      if(jsonResponse['status'].toString() =="1"){
                        toast("${jsonResponse['message']}");
                        Navigator.pop(context);
                      }else{
                        toast("${jsonResponse['message']}");
                      }
                    }
                  },
                ),
                vSizedBox,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                        child: ParagraphText('Back to Login',color: Colors.white,underlined: true,)),
                  ],
                ),

              ],

            ),
          ),
        )

    );
  }
}
