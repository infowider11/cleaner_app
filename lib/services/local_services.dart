// import 'dart:convert' as convert;
// import 'dart:developer';
//
// import 'package:cleanerapp/services/webservices.dart';
// import 'package:flutter/cupertino.dart';
//
// import 'package:http/http.dart' as http;
//
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// import '../modals/user_modal.dart';
// import '../widgets/showSnackbar.dart';
// import 'api_urls.dart';
//
//
// UserModal? userData;
// late SharedPreferences sharedPreference;
// class MyLocalServices{
//   static Future<UserModal> updateSharedPreferences(Map userMap) async{
//     String userDataString  = convert.jsonEncode(userMap);
//     print('updating sharedpreference : $userDataString');
//     sharedPreference.setString('userData', userDataString);
//     userData = UserModal.fromJson(userMap);
//     // String? token = await FirebasePushNotifications.getToken();
//     // if(token!=null)
//     //   await Webservices.updateDeviceToken(userId: userMap['id'], token: token);
//     return userData!;
//   }
//
//   static Future<UserModal> updateSharedPreferencesFromServer(String userId)async{
//     Map userMap = await Webservices.getMap(ApiUrls.getUserDetails + '$userId');
//     return updateSharedPreferences(userMap);
//     // retur
//   }
//
//   static void logout() async{
//     print('logout call---');
//     await Webservices.updateDeviceToken(userId: userData!.userId, token: '');
//     sharedPreference.clear();
//     userData = null;
//     // Navigator.popUntil(MyGlobalKeys.navigatorKey.currentContext!, (route) => route.isFirst);
//     // pushReplacement(context: MyGlobalKeys.navigatorKey.currentContext!, screen: WelcomePage(),);
//   }
//
// }