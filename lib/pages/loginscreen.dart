import 'dart:developer';
import 'dart:convert' as convert;
import 'package:cleanerapp/constants/global_keys.dart';
import 'package:http/http.dart' as http;
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/pages/forgotpassword.dart';
import 'package:cleanerapp/pages/homescreen.dart';
import 'package:cleanerapp/services/local_services.dart';
import 'package:cleanerapp/services/webservices.dart';
import 'package:cleanerapp/widgets/custom_text_field.dart';
import 'package:cleanerapp/widgets/showSnackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/user_model.dart';
import '../constants/global_data.dart';
import '../constants/sized_box.dart';
import '../constants/toast.dart';
import '../functions/navigation_functions.dart';
import '../services/api_urls.dart';
import '../services/onesignal.dart';
import '../widgets/CustomTexts.dart';
import '../widgets/round_edged_button.dart';
import '../constants/global_data.dart';
import 'Maintenance_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool check = true;
  bool load = false;
  bool isshow = false;
  final textFieldFocusNode = FocusNode();
  bool _obscured = true;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus)
        return; // If focus is on text field, dont unfocus
      textFieldFocusNode.canRequestFocus =
          false; // Prevents focus if tap on eye
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: MyColors.primaryColor,
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox6,
                  Center(
                    child: Image.asset(
                      MyImages.splash,
                      height: 162,
                      width: 162,
                    ),
                  ),
                  ParagraphText(
                    'Login',
                    color: Color(0xffffffff),
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                  vSizedBox2,
                  CustomTextField(
                    controller: email,
                    hintText: 'Email Address',
                    hintcolor: Colors.white,
                    textColor: Colors.white,
                    bgColor: Colors.transparent,
                    borderRadius: 8,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (val) {
                      email.selection = TextSelection.fromPosition(
                        TextPosition(offset: email.text.length),
                      );
                    },
                  ),
                  vSizedBox2,
                  // TextField(
                  //   keyboardType: TextInputType.visiblePassword,
                  //   obscureText: _obscured,
                  //   focusNode: textFieldFocusNode,
                  //   decoration: InputDecoration(
                  //     floatingLabelBehavior: FloatingLabelBehavior.never, //Hides label on focus or if filled
                  //     labelText: "Password",
                  //     filled: true, // Needed for adding a fill color
                  //     fillColor: Colors.transparent,
                  //     isDense: true,  // Reduces height a bit
                  //     border: OutlineInputBorder(
                  //       borderSide: B,              // No border
                  //       borderRadius: BorderRadius.circular(8),  // Apply corner radius
                  //     ),
                  //     suffixIcon: GestureDetector(
                  //         onTap: _toggleObscured,
                  //         child: Icon(_obscured==false? CupertinoIcons.eye_fill : CupertinoIcons.eye_slash_fill, color: MyColors.whiteColor,)),
                  //   ),
                  // ),
                  CustomTextField(
                    controller: password,
                    keyboardType: TextInputType.visiblePassword,
                    hintcolor: Colors.white,
                    textColor: Colors.white,
                    hintText: 'Password',
                    obscureText: _obscured,
                    focusNode: textFieldFocusNode,
                    bgColor: Colors.transparent,
                    borderRadius: 8,
                    suffix2: GestureDetector(
                        onTap: _toggleObscured,
                        child: Icon(
                          _obscured == false
                              ? CupertinoIcons.eye_slash_fill
                              : CupertinoIcons.eye_fill,
                          color: MyColors.whiteColor,
                        )),
                  ),

                  ///forgot password
                  // vSizedBox2,
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.end,
                  //   children: [
                  //     GestureDetector(
                  //       onTap: (){
                  //         push(context: context, screen: ForgotPassword());
                  //       },
                  //         child: ParagraphText('Forgot Password?',color: Color(0xffffffff),fontSize: 12,))
                  //   ],
                  // ),
                  vSizedBox2,
                  RoundEdgedButton(
                    text: 'Login',
                    fontSize: 18,
                    borderRadius: 8,
                    isLoad: load,
                    color: Color(0xffffffff),
                    textColor: MyColors.primaryColor,
                    onTap: () async {
                      // users.forEach((element) {
                      //   userData = element;
                      // print(userData!.emailId);
                      // if (email.text == 'Admin@gmail.com') {
                      //   xyz = UserType.Admin;
                      //   pushReplacement(context: context, screen: HomeScreen(userType: UserType.Admin, title: 'Welcome ! Admin',));
                      // } else if (email.text == 'Maintenance@gmail.com') {
                      //   xyz = UserType.Maintenance;
                      //   pushReplacement(
                      //       context: context,
                      //       screen: HomeScreen(
                      //         userType: UserType.Maintenance,
                      //         title: 'Welcome ! Maintenance',
                      //       ));
                      // } else if (email.text == 'Logistics@gmail.com') {
                      //   xyz = UserType.Logistics;
                      //   pushReplacement(
                      //       context: context,
                      //       screen: HomeScreen(
                      //         userType: UserType.Logistics,
                      //         title: 'Welcome ! Logistics',
                      //       ));
                      // } else if (email.text == 'Supervisor@gmail.com') {
                      //   xyz = UserType.Supervisor;
                      //   pushReplacement(
                      //       context: context,
                      //       screen: HomeScreen(
                      //         userType: UserType.Supervisor,
                      //         title: 'Welcome ! Supervisor',
                      //       ));
                      // } else if (email.text == 'Cleaners@gmail.com') {
                      //   xyz = UserType.Cleaners;
                      //   pushReplacement(
                      //       context: context,
                      //       screen: HomeScreen(
                      //         userType: UserType.Cleaners,
                      //         title: 'Welcome ! Cleaners',
                      //       ));
                      // }else

                      if (email.text.length == 0) {
                        toast('Please enter email');
                      } else if (email.text.length > 0 &&
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email.text)) {
                        toast('Please enter valid email');
                      } else if (password.text.length == 0) {
                        toast('Please enter password');
                      } else if (password.text.length > 0 &&
                          password.text.length < 6) {
                        toast('Password should not be less than 6 characters');

                        ///strong password validation
                        // }else  if(password.text.length > 0 && !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$').hasMatch(password.text)){
                        //   toast('Please enter strong password (It should contain block letter, special character & number)');
                      } else {
                        ///api integration
                        Map<String, dynamic> login_request = {
                          'email': email.text,
                          'password': password.text,
                        };

                        setState(() {
                          load = true;
                        });
                        // final Response= await Webservices.postData(apiUrl: ApiUrls.login , request: login_request);
                        final Response = await http.post(
                            Uri.parse(ApiUrls.login),
                            body: login_request);
                        var jsonResponse = convert.jsonDecode(Response.body);
                        log("Login response---$jsonResponse");
                        log("status---${jsonResponse['status']}");

                        if (jsonResponse['status'].toString() == "1") {
                          log('userdata---------${jsonResponse['data']}');
                          print("user type${jsonResponse['data']['type']}");

                          if (jsonResponse['data']['type'] != null ||
                              jsonResponse['data']['type'] != "") {
                            await prefs.setString(
                                "userType", jsonResponse['data']['type']);
                            await prefs.setString(
                                "userName", jsonResponse['data']['name']);
                            await prefs.setString(
                                "userId", jsonResponse['data']['id']);
                            await prefs.setString(
                                "email", jsonResponse['data']['email']);
                            await prefs.setString("profile_image",
                                jsonResponse['data']['profile_image']);

                            // userData = await User_data.fromJson(jsonResponse['data']) ;
                            userDataNotifier.value =
                                User_data.fromJson(jsonResponse['data']);

                            /// update device id
                            String? device_id = await get_device_id();
                            print("Device_id_is======$device_id");

                            ///device id

                            Map<String, dynamic> request = {
                              'user_id': userDataNotifier.value?.id,
                              'device_id': device_id,
                            };
                            final deviceId_response =
                                await Webservices.postData(
                                    apiUrl: ApiUrls.update_deviceId,
                                    request: request,
                                    showSuccessMessage: false,
                                    isGetMethod: true);

                            print(
                                "deviceId_response=======================$deviceId_response");

                            ///-------------------------------------------------------

                            if (jsonResponse['data']['type'].toString() ==
                                "1") {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            key: MyGlobalKeys.homeScreenKey,
                                            userType: UserType.Secratary,
                                            title:
                                                "Welcome ! ${jsonResponse['data']['name']}",
                                          )),
                                  (Route<dynamic> route) => false);
                              toast("${jsonResponse['message']}");
                            } else if (jsonResponse['data']['type']
                                    .toString() ==
                                "2") {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            key: MyGlobalKeys.homeScreenKey,
                                            userType: UserType.Supervisor,
                                            title:
                                                "Welcome ! ${jsonResponse['data']['name']}",
                                          )),
                                  (Route<dynamic> route) => false);
                              toast("${jsonResponse['message']}");
                            } else if (jsonResponse['data']['type']
                                    .toString() ==
                                "3") {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            key: MyGlobalKeys.homeScreenKey,
                                            userType: UserType.Logistics,
                                            title:
                                                "Welcome ! ${jsonResponse['data']['name']}",
                                          )),
                                  (Route<dynamic> route) => false);
                              toast("${jsonResponse['message']}");
                            } else if (jsonResponse['data']['type']
                                    .toString() ==
                                "4") {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Maintenance_home_screen(
                                            key:
                                                MyGlobalKeys.maintenanceHomeKey,
                                          )),
                                  (Route<dynamic> route) => false);
                              toast("${jsonResponse['message']}");
                            } else if (jsonResponse['data']['type']
                                    .toString() ==
                                "5") {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => HomeScreen(
                                            key: MyGlobalKeys.homeScreenKey,
                                            userType: UserType.Cleaners,
                                            title:
                                                "Welcome ! ${jsonResponse['data']['name']}",
                                          )),
                                  (Route<dynamic> route) => false);
                              toast("${jsonResponse['message']}");
                            } else {
                              toast("${jsonResponse['message']}");
                            }
                          } else {
                            toast("${jsonResponse['message']}");
                          }
                        } else {
                          setState(() {
                            load = false;
                          });
                          toast("${jsonResponse['message']}");
                        }
                      }
                      // });
                    },
                  )
                ],
              ),
            ),
          )),
    );
  }
}
