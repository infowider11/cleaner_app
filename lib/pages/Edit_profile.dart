import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleanerapp/Model/user_model.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/appbar.dart';
import 'package:cleanerapp/widgets/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/colors.dart';
import '../constants/global_data.dart';
import '../constants/images_url.dart';
import '../constants/sized_box.dart';
import '../constants/toast.dart';
import '../services/api_urls.dart';
import '../services/webservices.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/round_edged_button.dart';

class Edit_profile extends StatefulWidget {
  const Edit_profile({Key? key}) : super(key: key);

  @override
  State<Edit_profile> createState() => _Edit_profileState();
}

class _Edit_profileState extends State<Edit_profile> {
  TextEditingController fullName = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  bool load = false;
  bool load2 = false;
  var user_id;
  late File imgFile;
  final imgPicker = ImagePicker();
  var selectedimage;
  var stored_image_path;

  ///image upload code
  void _image_camera_dialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Select an Image',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
              onPressed: () {
                openGallery();
                Navigator.pop(context);
              },
              child: Text(
                'Select a photo from Gallery',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
          CupertinoActionSheetAction(
              onPressed: () {
                openCamera();
                Navigator.pop(context);
              },
              child: Text(
                'Take a photo with the camera',
                style: TextStyle(color: Colors.grey, fontSize: 15),
              )),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  void openCamera() async {
    var imgCamera = await imgPicker.getImage(source: ImageSource.camera);
    setState(() {
      imgFile = File(imgCamera!.path);
      selectedimage = imgFile;
      print('image upload$imgFile');
    });
  }

  void openGallery() async {
    var imgGallery = await imgPicker.getImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(imgGallery!.path);
      selectedimage = imgFile;
      print('image upload$imgFile');
    });
  }

  auto_fill() {
    // print("aaaaaaaaaa${userData!.phone!}");
    // email.text = userData!.email!;
    // fullName.text = userData!.name!;
    // phone.text = userData!.phone!;
    // stored_image_path = userData!.profileImage!;


    email.text = userDataNotifier.value!.email!;
    fullName.text = userDataNotifier.value!.name!;
    phone.text = userDataNotifier.value!.phone!;
    stored_image_path = userDataNotifier.value!.profileImage!;
  }

  @override
  void initState() {
    auto_fill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size_height = MediaQuery.of(context).size.height;
    var size_width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: MyColors.primaryColor,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.chevron_left,
              color: MyColors.whiteColor,
              size: 30,
            )),
        centerTitle: true,
        title: ParagraphText(
          'Edit Profile',
          color: MyColors.whiteColor,
          fontWeight: FontWeight.w500,
          fontSize: 18,
        ),
      ),
      body: stored_image_path == null
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 20,
                color: MyColors.whiteColor,
              ),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSizedBox4,
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _image_camera_dialog(context);
                      },
                      child: (selectedimage == null &&
                              stored_image_path == null)
                          ? Container(
                              height: size_height * 0.15,
                              width: size_height * 0.15,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  border:
                                      Border.all(color: MyColors.whiteColor)),
                              child: Icon(
                                Icons.camera_alt,
                                color: MyColors.whiteColor,
                                size: 30,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: stored_image_path == null ||
                                      stored_image_path == "" ||
                                      selectedimage != null
                                  ? Image.file(
                                      height: size_height * 0.15,
                                      width: size_height * 0.15,
                                      File(
                                        selectedimage?.path ?? "",
                                      ),
                                      fit: BoxFit.cover,
                                    )
                                  :
                              CachedNetworkImage(
                                fit: BoxFit.cover,
                                height: size_height * 0.15,
                                width: size_height * 0.15,
                                imageUrl:  stored_image_path,
                                placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                              // Image.network(
                              //         stored_image_path,
                              //         fit: BoxFit.cover,
                              //         height: size_height * 0.15,
                              //         width: size_height * 0.15,
                              //       )
                      ),
                    ),
                  ),
                  vSizedBox4,
                  CustomTextField(
                    controller: fullName,
                    hintText: 'Name',
                    hintcolor: Colors.white,
                    textColor: Colors.white,
                    bgColor: Colors.transparent,
                    borderRadius: 8,
                    keyboardType: TextInputType.name,
                  ),
                  vSizedBox,
                  CustomTextField(
                    controller: email,
                    hintText: 'Email Address',
                    hintcolor: Colors.white,
                    textColor: Colors.white,
                    enabled: false,
                    bgColor: Colors.transparent,
                    borderRadius: 8,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  vSizedBox,
                  CustomTextField(
                    controller: phone,
                    hintText: 'Phone Number',
                    hintcolor: Colors.white,
                    textColor: Colors.white,
                    bgColor: Colors.transparent,
                    borderRadius: 8,
                    keyboardType: TextInputType.number,
                  ),
                  vSizedBox,
                  RoundEdgedButton(
                    color: Colors.white,
                    text: 'Submit',
                    isLoad: load,
                    textColor: MyColors.primaryColor,
                    onTap: () async {
                      ///  edit profile validation & api integration
                      if (fullName.text.length == 0) {
                        toast('Please enter name');
                      } else if (email.text.length == 0) {
                        toast('Please enter email address');
                      } else if (email.text.length > 0 &&
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email.text)) {
                        toast('Please enter valid email address');
                      } else if (phone.text.length == 0) {
                        toast('Please enter phone number');
                      } else {
                        Map<String, dynamic> edit_profile_req = {
                          'user_id': userDataNotifier.value!.id ?? "",
                          'name': fullName.text,
                          'phone': phone.text,
                        };
                        Map<String, dynamic> image = {
                          'profile_image': selectedimage,
                        };

                        setState(() {
                          load = true;
                        });

                        final Response =
                            await Webservices.postDataWithImageFunction(
                                apiUrl: ApiUrls.edit_profile,
                                body: edit_profile_req,
                                files: image,
                                context: context);
                        log("edit_profile response---$Response");

                        setState(() {
                          load = false;
                        });

                        if (Response['status'].toString() == "1") {
                          ///updating user data after edit
                          // userData = User_data.fromJson(Response['data']);
                          userDataNotifier.value = User_data.fromJson(Response['data']);

                          // log("edit profile response updated---${jsonEncode(userData)}");
                          // log("user name---${userData!.name}");
                          toast("${Response['message']}");
                          Navigator.pop(context);
                        } else {
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
