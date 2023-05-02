import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleanerapp/pages/loginscreen.dart';
import 'package:cleanerapp/widgets/round_edged_button.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/global_data.dart';
import '../constants/global_keys.dart';
import '../functions/navigation_functions.dart';
import '../pages/Change_password.dart';
import '../pages/Edit_profile.dart';
import '../pages/My_created_task_list.dart';
import 'customLoader.dart';



Drawer get_drawer(BuildContext context,){

  TextEditingController  emailcontroller = TextEditingController();
  String? choosenValue;
  bool load=false;
  var stored_image_path = userDataNotifier.value!.profileImage;
  // var stored_image_path = prefs.getString('profile_image');

  return Drawer(
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    backgroundColor: Color(0xff0F3750),
    child: StatefulBuilder(
        builder: (context, setState) {
          var size_height = MediaQuery.of(context).size.height;
          var size_width = MediaQuery.of(context).size.width;

          return Container(
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 10,right: 10,),
                  child: Row(
                    children: [
                      // stored_image_path == null?
                      // ClipRRect(
                      //   borderRadius: BorderRadius.circular(100),
                      //   child: Image.asset(MyImages.profile, fit: BoxFit.cover, height: size_height*0.12,),
                      // ):
                      // ClipRRect(
                      //     borderRadius: BorderRadius.circular(100),
                      //     child: Image.network(stored_image_path, fit: BoxFit.cover,height: size_height*0.12, width: size_height*0.12,)
                      // ),

                      ValueListenableBuilder(
                          valueListenable: userDataNotifier,
                          builder: (context, userData, child) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                height: 90,
                                width: 90,
                                fit: BoxFit.cover,
                                imageUrl: "${userData!.profileImage}",
                                placeholder: (context, url) => CustomLoader(color: MyColors.whiteColor,),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            );
                          }
                      ),
                      SizedBox(width: size_width*0.02,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${userDataNotifier.value?.name}", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400, color: MyColors.scafoldcolor),),
                          Wrap(
                            children: [
                              SizedBox(
                                  width: size_width*0.45,
                                  child: Text("${userDataNotifier.value?.email}",   style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400, color: MyColors.scafoldcolor),)),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      InkWell(
                        onTap: (){
                          Scaffold.of(context).closeEndDrawer();
                          Navigator.pop(context);

                          if(userDataNotifier.value?.userType != UserType.Maintenance)
                          MyGlobalKeys.homeScreenKey.currentState!.taskList();

                          if(userDataNotifier.value?.userType == UserType.Maintenance)
                            MyGlobalKeys.maintenanceHomeKey.currentState!.maintenance_taskList();

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Home", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                                color: MyColors.scafoldcolor),),
                            Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                          ],
                        ),
                      ),

                      SizedBox(height: size_height*0.02,),
                      InkWell(
                        onTap: (){
                          Scaffold.of(context).closeEndDrawer();
                          push(context: context, screen: Edit_profile());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Edit Profile", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                                color: MyColors.scafoldcolor),),
                            Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                          ],
                        ),
                      ),
                      SizedBox(height: size_height*0.02,),

                      InkWell(
                        onTap: (){
                          Scaffold.of(context).closeEndDrawer();
                          push(context: context, screen: Change_password());
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Change Password", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                                color: MyColors.scafoldcolor),),
                            Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                          ],
                        ),
                      ),

                      SizedBox(height: size_height*0.02,),

                      ///My Created Task only for supervisor
                      userDataNotifier.value?.userType != UserType.Supervisor ? Container() :
                      InkWell(
                        onTap: (){
                          Scaffold.of(context).closeEndDrawer();
                          push(context: context, screen: My_created_task_list());
                        },
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("My Created Task", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                                    color: MyColors.scafoldcolor),),
                                Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                              ],
                            ),
                            SizedBox(height: size_height*0.02,),
                          ],
                        ),
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Privacy Policy", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                              color: MyColors.scafoldcolor),),
                          Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                        ],
                      ),
                      SizedBox(height: size_height*0.02,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Terms & Condition", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                              color: MyColors.scafoldcolor),),
                          Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                        ],
                      ),
                      SizedBox(height: size_height*0.02,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("About Us", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                              color: MyColors.scafoldcolor),),
                          Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                        ],
                      ),
                      SizedBox(height: size_height*0.02,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("History", style: TextStyle(fontSize: 15, fontFamily: "Regular", fontWeight: FontWeight.w400,
                              color: MyColors.scafoldcolor),),
                          Icon(Icons.chevron_right, color: MyColors.scafoldcolor)
                        ],
                      ),
                      SizedBox(height: size_height*0.02,),

                      RoundEdgedButton(
                        color: Colors.white,
                        text: 'Logout',
                        textColor: MyColors.primaryColor,
                        onTap: () async{
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 1,
                                sigmaY: 1,
                              ),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: size_width * 0.085,
                                      right: size_width * 0.085,
                                    ),
                                    child: AlertDialog(
                                      alignment: Alignment.center,
                                      actionsAlignment: MainAxisAlignment.center,
                                      insetPadding: EdgeInsets.zero,
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(26)),
                                      content: SizedBox(
                                        width: double.maxFinite,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [

                                            SizedBox(height: size_height * 0.02,),
                                            Text(
                                              'Are you Sure!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontFamily: "Regular",
                                                color: MyColors.primaryColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: size_height * 0.04,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                RoundEdgedButton(
                                                  text: "Logout",
                                                  width: size_width/3,
                                                  color: MyColors.primaryColor,
                                                  isLoad: load,
                                                  onTap: () async{
                                                  setState(() {
                                                    load=true;
                                                  });
                                                  prefs.clear();
                                                   userDataNotifier.value=null;
                                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
                                                },),
                                                RoundEdgedButton(
                                                  text: "Cancel",
                                                  width: size_width/3,
                                                  color: MyColors.starInActiveColor,
                                                  onTap: (){Navigator.pop(context);},)
                                              ],
                                            )
                                          ],
                                        ),
                                      ),

                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
    ),
  );

}