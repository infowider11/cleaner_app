import 'dart:async';
import 'dart:developer';
import 'package:cleanerapp/Model/user_model.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/pages/homescreen.dart';
import 'package:cleanerapp/pages/loginscreen.dart';
import 'package:cleanerapp/services/onesignal.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/global_data.dart';
import '../constants/global_keys.dart';
import '../services/api_urls.dart';
import '../services/webservices.dart';
import 'Maintenance_home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool load2=false;
  var user_id;

  Future<void> CheckLogin() async {

    var type_= prefs.getString("userType");
    var userName= prefs.getString("userName");
    print("userName__ ${userName.toString()}");

    setState(() {
        if(type_.toString().contains("1")){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(key:MyGlobalKeys.homeScreenKey,userType: UserType.Secratary, title: "Welcome ! $userName",)), (Route<dynamic> route) => false);
        }else if(type_.toString().contains("2")){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(key:MyGlobalKeys.homeScreenKey,userType: UserType.Supervisor, title: "Welcome ! $userName",)), (Route<dynamic> route) => false);
        }else if(type_.toString().contains("3")){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(key:MyGlobalKeys.homeScreenKey,userType: UserType.Logistics, title: "Welcome ! $userName",)), (Route<dynamic> route) => false);
        }else if(type_.toString().contains("4")){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Maintenance_home_screen(key: MyGlobalKeys.maintenanceHomeKey)), (Route<dynamic> route) => false);
        }else if(type_.toString().contains("5")){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => HomeScreen(key:MyGlobalKeys.homeScreenKey,userType: UserType.Cleaners, title: "Welcome ! $userName",)), (Route<dynamic> route) => false);
        }
        else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
        }
      },);
  }


  Future<void> UserDetails() async {
    initOneSignal(One_Signal_appid);

    prefs=await SharedPreferences.getInstance();

    user_id = prefs.getString("userId");
    setState(() {load2=true;});
    final Response= await Webservices.getMap(ApiUrls.getUserDetails+"?user_id=$user_id");
    log("user detail response---$Response");

    setState(() {load2=false;});

    if(user_id != null){
      userDataNotifier.value = User_data.fromJson(Response);

      /// update device id
      String? device_id = await get_device_id();
      print("Device_id_is======$device_id");///device id

      Map<String, dynamic> request = {
        'user_id' : user_id,
        'device_id'  : device_id,
      };

      final deviceId_response =  await Webservices.postData(apiUrl: ApiUrls.update_deviceId, request: request,showSuccessMessage: false,isGetMethod: true);

      print("deviceId_response=======================$deviceId_response");

      CheckLogin();
    }
    else{
      CheckLogin();
    }
  }


  @override
  void initState() {
      UserDetails();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    size_height= MediaQuery.of(context).size.height;
    size_width= MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xff0F3750),
     body:Center(
       child: Container(
         child: Image.asset(MyImages.splash,height: 260,width: 260,),
       ),
     )

    );
  }

}
