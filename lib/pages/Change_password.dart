import 'dart:developer';

import 'package:cleanerapp/services/webservices.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/appbar.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/global_data.dart';
import '../constants/images_url.dart';
import '../constants/sized_box.dart';
import '../constants/toast.dart';
import '../services/api_urls.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/round_edged_button.dart';

class Change_password extends StatefulWidget {
  const Change_password({Key? key}) : super(key: key);

  @override
  State<Change_password> createState() => _Change_passwordState();
}

class _Change_passwordState extends State<Change_password> {

  TextEditingController oldPassword  =TextEditingController();
  TextEditingController confirmPassword  =TextEditingController();
  TextEditingController newPassword  =TextEditingController();
  bool load=false;
  var user_id;


  @override
  Widget build(BuildContext context) {
    var size_height = MediaQuery.of(context).size.height;
    var size_width = MediaQuery.of(context).size.width;

    return  Scaffold(
      backgroundColor:MyColors.primaryColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.chevron_left, color: MyColors.whiteColor, size: 30,)),
        centerTitle: true,
        title: ParagraphText('Change Password',color: MyColors.whiteColor,fontWeight: FontWeight.w500,fontSize: 18,),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextField(
              controller: oldPassword,
              hintText: 'Old Password',
              hintcolor: Colors.white,
              textColor: Colors.white,
              obscureText: true,
              bgColor:Colors.transparent,
              borderRadius: 8,
            ),
            vSizedBox,

            CustomTextField(
              controller: newPassword,
              hintText: 'New Password',
              hintcolor: Colors.white,
              obscureText: true,
              textColor: Colors.white,
              bgColor:Colors.transparent,
              borderRadius: 8,
            ),
            vSizedBox,
            CustomTextField(
              controller: confirmPassword,
              hintText: 'Confirm Password',
              hintcolor: Colors.white,
              obscureText: true,
              textColor: Colors.white,
              bgColor:Colors.transparent,
              borderRadius: 8,
            ),
            vSizedBox,
            RoundEdgedButton(
              color: Colors.white,
              text: 'Submit',
              textColor: MyColors.primaryColor,
              isLoad: load,
              onTap: () async{

                ///  change_password validation & api integration
                if (oldPassword.text.length == 0 || newPassword.text.length == 0 || confirmPassword.text.length == 0 ){
                  toast('Please enter all fields');
                }else if(newPassword.text != confirmPassword.text){
                  toast('New password and confirm password should be same');
                }
                else{
                  user_id = prefs.getString("userId");

                  Map<String,dynamic> change_pass_request={
                    'user_id': user_id??"",
                    'user_password': oldPassword.text,
                    'new_password': newPassword.text,
                    'confirm_password': confirmPassword.text,
                  };

                  setState(() {
                    load=true;
                  });
                  final Response= await Webservices.postData(apiUrl: ApiUrls.change_password , request: change_pass_request, showErrorMessage: false, showSuccessMessage: false);
                  log("change password response---$Response");
                  log("status---${Response['status']}");

                  setState(() {
                    load=false;
                  });
                  if(Response['status'].toString() =="1"){
                    toast("${Response['message']}");
                    Navigator.pop(context);
                  }else{
                    toast("${Response['message']}");
                  }

                }
              },
            ),

          ],
        ),
      ),
    );
  }
}
