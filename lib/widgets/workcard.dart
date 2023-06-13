import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleanerapp/constants/box_shadow.dart';
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/global_data.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/constants/sized_box.dart';
import 'package:cleanerapp/constants/toast.dart';
import 'package:cleanerapp/services/api_urls.dart';
import 'package:cleanerapp/services/webservices.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/custom_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'round_edged_button.dart';

class WorkCard extends StatelessWidget {
  final VoidCallback onTap;
  final UserType usertype;
  final Map ListData;
  final bool isMaintenance;
  final String workStatus;
  final Function()? mark_as_supervisor_Tap;

  const WorkCard({
    Key? key,
    required this.onTap,
    this.mark_as_supervisor_Tap,
    required this.usertype,
    required this.ListData,
    required this.workStatus,
    required this.isMaintenance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: usertype == UserType.Logistics ? 2 : usertype == UserType.Supervisor ? 2 : 5),

        margin: EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            boxShadow: [shadow],
            color:
            ListData['color_status'].toString() == "1" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance || isMaintenance == false)? MyColors.arrivalColor :
            ListData['color_status'].toString() == "2" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance || isMaintenance == false) ? MyColors.inHouseColor :
            ListData['color_status'].toString() == "3" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance || isMaintenance == false) ? MyColors.black54Color.withOpacity(0.2) :
            ListData['color_status'].toString() == "4" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance || isMaintenance == false) ? MyColors.checkOutColor.withOpacity(0.2) :
            MyColors.whiteColor,
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Stack(
                children: [
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: usertype == UserType.Logistics ? 3 : usertype == UserType.Supervisor ? 3 : 4,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      left: 6,
                                      top: 3,
                                      bottom: 3,
                                      right: 0,
                                    ),
                                    child: ListData['apartment']['image'].length != 0
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: CachedNetworkImage(
                                              placeholder: (context, url) =>
                                                  const CupertinoActivityIndicator(
                                                radius: 5,
                                                color: MyColors.primaryColor,
                                              ),
                                              imageUrl:
                                                  // '${ListData['apartment']['image'][0]['image']}',
                                                  '${ListData['apartment']['image']}',
                                              fit: BoxFit.cover,
                                              width: usertype == UserType.Logistics ? 100 : usertype == UserType.Maintenance ? 100 : usertype == UserType.Supervisor ? 100 : 120,
                                              height: usertype == UserType.Logistics? 90 : usertype == UserType.Maintenance ? 100 : usertype == UserType.Supervisor ? 100 : 120,
                                            ),
                                          )
                                        : Container(
                                      width: usertype == UserType.Logistics ? 100 : usertype == UserType.Supervisor ? 100 : 120,
                                      height: usertype == UserType.Logistics? 90 : usertype == UserType.Supervisor ? 100 : 120,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: MyColors.greyColor)),
                                            child: Icon(
                                              Icons.camera_alt,
                                              color: MyColors.whiteColor,
                                              size: 30,
                                            ),
                                          ),
                                  ),

                                  if(userDataNotifier.value?.userType != UserType.Maintenance)
                                  Positioned(
                                    bottom: 10,
                                    right: 5,
                                    child: Container(
                                      width: 34,
                                      height: 16,
                                      decoration: BoxDecoration(
                                          color: Color(0xff000000)
                                              .withOpacity(0.7),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Image.asset(
                                            MyImages.gallery,
                                            height: 8,
                                            width: 9,
                                          ),

                                          if(isMaintenance != true)
                                          ParagraphText(
                                            '${ListData['apartment']['images'].length ?? "0"}',
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),

                                          if(isMaintenance == true)
                                            ParagraphText(
                                              '${ListData['images'].length ?? "0"}',
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // vSizedBox05,
                            ],
                          ),
                        ),
                        Expanded(
                            flex: usertype == UserType.Logistics
                                ? 8
                                : usertype == UserType.Supervisor
                                    ? 8
                                    : 7,
                            child: Column(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ParagraphText(
                                          '${ListData['apartment']['name']}',
                                          color: MyColors.primaryColor,
                                          fontWeight: FontWeight.w600,
                                          fontSize:
                                              usertype == UserType.Logistics
                                                  ? 14
                                                  : 16,
                                        ),
                                        ParagraphText(
                                          '#${ListData['apartment']['apartment_no']}',
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ],
                                    )),
                                vSizedBox05,
                                if (usertype != UserType.Logistics)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.location_on_rounded,
                                          color: Color(0xffB49877),
                                          size: 12,
                                        ),
                                        hSizedBox05,
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.1,
                                          child: Wrap(
                                            children: [
                                              ParagraphText(
                                                '${ListData['apartment']['location']}',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (usertype != UserType.Logistics &&
                                    usertype != UserType.Supervisor)
                                  vSizedBox02,
                                if (usertype != UserType.Logistics )
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              MyImages.apartmenttype,
                                              height: 12,
                                              width: 12,
                                            ),
                                            hSizedBox05,
                                            // if(ListData['apartment_type'] != [])
                                            ParagraphText(
                                              '${ListData['apartment_type']['name']}',
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                        if (usertype == UserType.Cleaners || usertype == UserType.Maintenance )
                                          RichText(
                                              text: TextSpan(
                                                  text: 'Priority: ',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontFamily: 'Regular',
                                                      fontSize: 12),
                                                  children: [
                                                    ListData['work_priority'].runtimeType.toString() == 'List<dynamic>' ?
                                                      TextSpan(text: ''):
                                                    TextSpan(
                                                  text: '${ListData['work_priority']['title']}',
                                                  style: TextStyle(
                                                      color: Color(0xffFFCA0D),
                                                      fontFamily: 'Regular',
                                                      fontSize: 12),
                                                )
                                              ])),
                                      ],
                                    ),
                                  ),



                                if (usertype != UserType.Logistics &&
                                    usertype != UserType.Supervisor)
                                  vSizedBox02,
                                Container(
                                  color: Color(0xffD9D9D9),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.calendar_month,
                                              color: Color(0xffB49877),
                                              size: 12,
                                            ),
                                            hSizedBox05,
                                            if(ListData['date'] !=null || ListData['time'] != null)
                                            ParagraphText(
                                              '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(ListData['date']))}  ${ListData['time']}',
                                              color: Colors.black,
                                              fontSize: 12,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                if(isMaintenance == true)
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.work,
                                                size: 12,
                                                color: Color(0xffB49877),
                                              ),
                                              hSizedBox05,
                                              ParagraphText(
                                                '${ListData['title']}',
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),


                                if(isMaintenance == false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.cleaning_services_rounded,
                                        color: Color(0xffB49877),
                                        size: 12,
                                      ),
                                      hSizedBox05,
                                      SizedBox(
                                        width: 180,
                                        child: Wrap(
                                          children: [
                                            GestureDetector(
                                                onTap: isMaintenance == true
                                                    ? onTap
                                                    : null,
                                                child: ParagraphText(
                                                  '${ListData['apartment']['check_list']}',
                                                  color: Color(0xff0F3750),
                                                  underlined:
                                                      isMaintenance == true
                                                          ? true
                                                          : false,
                                                  fontSize: 12,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                vSizedBox02,
                                // Padding(
                                //   padding: const EdgeInsets.symmetric(horizontal: 10),
                                //   child: Row(
                                //     children: [
                                //
                                //
                                //       Icon(Icons.person,color: Color(0xffB49877),size:12,),
                                //       hSizedBox05,
                                //       ParagraphText('${ListData['staff_data']['name']} (${
                                //           userDataNotifier.value!.userType == UserType.Cleaners ? "Cleaner" :
                                //           userDataNotifier.value!.userType == UserType.Maintenance ? "Maintenance" :
                                //           userDataNotifier.value!.userType == UserType.Logistics ? "Logistics" :
                                //           userDataNotifier.value!.userType == UserType.Supervisor ? "Supervisor" :
                                //           userDataNotifier.value!.userType == UserType.Secratary ? "Secratary" :
                                //           ""
                                //       })',color: Colors.black,fontSize: 12,fontWeight:FontWeight.w600,),
                                //                                        ],
                                //   ),
                                // ),
                                // vSizedBox02,

                                if(usertype != UserType.Maintenance || isMaintenance == false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.person,
                                        color: Color(0xffB49877),
                                        size: 12,
                                      ),
                                      hSizedBox05,
                                      ParagraphText(
                                        '${ListData['staff_data']['name']} (Cleaner)'  ,
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),

                                if(userDataNotifier.value?.userType != UserType.Maintenance && userDataNotifier.value?.userType != UserType.Logistics || isMaintenance == false)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Row(
                                    children: [
                                      ListData['supervisior']==null? Container():
                                      Icon(
                                        Icons.person,
                                        color: Color(0xffB49877),
                                        size: 12,
                                      ),
                                      hSizedBox05,
                                      ParagraphText(
                                        ListData['supervisior']!=null?
                                        '${ListData['supervisior']['name']} (Supervisor)' : "",
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: usertype == UserType.Supervisor ? 10 : usertype == UserType.Maintenance ? 25 :
                    usertype == UserType.Logistics ? 10 : 15),
                    child: RoundEdgedButton(
                      text: '${workStatus}',
                      textColor: workStatus == 'NOT STARTED'
                          ? Colors.black
                          : Colors.white,
                      height:  18,
                      width:  68,
                      verticalPadding: 0,
                      fontSize:  8,
                      fontWeight: FontWeight.w600,
                      color: workStatus == 'IN PROGRESS'
                          ? Color(0xffF9C50F)
                          : workStatus == 'COMPLETED'
                              ? Color(0xff14A300)
                              : workStatus == 'CHECKED'
                                  ? Color(0xffB009FF)
                                  : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            // if (usertype != UserType.Logistics&&usertype != UserType.Supervisor)
            if (usertype != UserType.Logistics && usertype != UserType.Supervisor)
              vSizedBox05,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
              height: 35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText(
                    usertype == UserType.Maintenance ? "Task #${ListData['id']}" :
                    'Task #${ListData['id']}',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  if(ListData['assinged_by'] != null)
                  ParagraphText(
                    'Assign By: ${ListData['assinged_by']['name']}',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                  if (workStatus == 'CHECKED')
                    ParagraphText(
                      'Checked By: Supervised',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  if (usertype == UserType.Supervisor)
                    InkWell(
                      onTap: mark_as_supervisor_Tap,
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                          decoration: BoxDecoration(
                            color: ListData['supervisior_task_status']
                                            .toString() ==
                                        "0" &&
                                    ListData['status'].toString() != "0"
                                ? Color(0xffF85900)
                                : ListData['supervisior_task_status']
                                                .toString() ==
                                            "0" &&
                                        ListData['status'].toString() == "0"
                                    ? Colors.grey
                                    : Colors.green,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              ListData['supervisior_task_status'].toString() ==
                                          "0" &&
                                      ListData['status'].toString() != "0"
                                  ? ParagraphText(
                                      'Mark as supervised',
                                      color: MyColors.whiteColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    )
                                  : ListData['supervisior_task_status']
                                                  .toString() ==
                                              "0" &&
                                          ListData['status'].toString() == "0"
                                      ? ParagraphText(
                                          'Not Started',
                                          color: MyColors.blackColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        )
                                      : ParagraphText(
                                          'Checked by supervisor',
                                          color: MyColors.whiteColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        )),
                    ),
                ],
              ),
            )
          ],
        ));
  }
}

class ReportCard extends StatefulWidget {
  final String current_location;
  final Map? taskDetail;

  ReportCard({Key? key, required this.current_location, this.taskDetail})
      : super(key: key);

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  TextEditingController title = TextEditingController();
  TextEditingController location = TextEditingController();
  late File imgFile;
  final imgPicker = ImagePicker();
  var selectedimage;
  List data = [];
  bool load=false;

  ///image upload code
  void _image_camera_dialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Select an Image',
          style: GoogleFonts.openSans(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
              onPressed: () async {
                var imgGallery =
                    await imgPicker.pickImage(source: ImageSource.gallery);
                setState(() {
                  imgFile = File(imgGallery!.path);
                  selectedimage = imgFile;
                });
                Navigator.pop(context);
              },
              child: Text(
                'Select a photo from Gallery',
                style: GoogleFonts.openSans(color: Colors.grey, fontSize: 15),
              )),
          CupertinoActionSheetAction(
              onPressed: () async {
                var imgCamera =
                    await imgPicker.pickImage(source: ImageSource.camera);
                setState(() {
                  imgFile = File(imgCamera!.path);
                  selectedimage = imgFile;
                });
                Navigator.pop(context);
              },
              child: Text(
                'Take a photo with the camera',
                style: GoogleFonts.openSans(color: Colors.grey, fontSize: 15),
              )),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel',
              style: GoogleFonts.openSans(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }

  @override
  void initState() {
    location.text = widget.current_location;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: 324,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
                child: ParagraphText(
              "Report Maintenance",
              fontWeight: FontWeight.w500,
              fontSize: 18,
            )),
            vSizedBox,
            data.length != 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 15,
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        children: [
                          for (int i = 0; i < data.length; i++)
                            Container(
                              width: size_width / 4.4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Image.file(
                                                File(
                                                  data![i]['image'].path,
                                                ),
                                                fit: BoxFit.cover,
                                                height: size_width / 4.4,
                                                width: size_width / 4.4,
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5),
                                            child: RoundEdgedButton(
                                              text: 'Delete',
                                              height: 19,
                                              width: size_width * 0.13,
                                              verticalPadding: 0,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              borderRadius: 5,
                                              onTap: () {
                                                print(data![i]['image'].path);
                                                data.removeAt(i);
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  // vSizedBox05,
                                  // ParagraphText(
                                  //   data[i]['title'] ?? '',
                                  //   fontSize: 11,
                                  //   fontWeight: FontWeight.w600,
                                  // ),
                                  // ParagraphText(
                                  //   data[i]['address'],
                                  //   fontSize: 10,
                                  // ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            vSizedBox2,
            Center(
              child: GestureDetector(
                onTap: () {
                  _image_camera_dialog(context);

                },
                child: Container(
                    height: 116,
                    width: 116,
                    decoration: BoxDecoration(
                        color: Color(0xffDBDBDB),
                        borderRadius: BorderRadius.circular(10)),
                    child: selectedimage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(
                                selectedimage!.path,
                              ),
                              fit: BoxFit.cover,
                            ))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                MyImages.uploadreport,
                                height: 40,
                                width: 40,
                              ),
                              ParagraphText('Upload image')
                            ],
                          )),
              ),
            ),
            vSizedBox05,
            CustomTextField(
              controller: title,
              hintText: 'TITLE',
              bgColor: Colors.white,
              borderRadius: 0,
            ),
            vSizedBox,
            CustomTextField(
              controller: location,
              enabled: false,
              hintText: 'LOCATION',
              bgColor: Colors.white,
              borderRadius: 0,
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundEdgedButton(
                        text: 'UPLOAD',
                        height: 39,
                        width: 140,
                        verticalPadding: 0,
                        borderRadius: 5,
                        color: Color(0xff0F3750),
                        onTap: () {
                          if (title.text != "" && location.text != "" && selectedimage != null) {
                            Map temp = {
                              'image': selectedimage,
                            };

                            data.add(temp);

                            this.setState(() {});
                            selectedimage = null;

                          } else {
                            toast('Please enter all fields.');
                          }
                        },
                      ),
                      RoundEdgedButton(
                        text: 'CANCEL',
                        height: 39,
                        width: 140,
                        verticalPadding: 0,
                        borderRadius: 5,
                        color: Color(0xffB49877),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  RoundEdgedButton(
                    text: 'SEND',
                    height: 39,
                    verticalPadding: 0,
                    verticalMargin: 0,
                    borderRadius: 5,
                    isLoad: load,
                    loaderColor: MyColors.whiteColor,
                    color: Color(0xff0F3750),
                    onTap: () async {
                      ///report maintenance api



                      this.setState(() {
                          load = true;
                        });

                        Map<String, dynamic> request ={};
                        Map<String, dynamic> img ={};

                        for(int i=0; i<data.length; i++) {
                          request['task_id'] =  widget.taskDetail?['id']??'';
                          request['apartment_id'] = widget.taskDetail?['apartment']['id']??'';
                          request['staff_id'] = widget.taskDetail?['staff_data']['id']??'';
                          request['title'] = title.text;
                          request['location'] = location.text;
                          img['images[$i]'] = data[i]['image'];
                        }

                        print("report maintenance== ${request}");
                        print("image_is== ${img}");
                        final response = await Webservices.postDataWithImageFunction(body: request, files: img, context: context, apiUrl: ApiUrls.report_maintenance);

                      this.setState(() {
                          load = false;
                        });

                        if (response['status'].toString() == '1') {
                          Navigator.pop(context);
                          toast("Thank you! Your request has been submitted successfully. We will let you know");
                        } else {
                          toast(response['message']);
                        }
                      }

                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MaintenanceCrad extends StatefulWidget {
  String? task_id;
  String currentAddress;
  MaintenanceCrad({Key? key, required this.task_id, required this.currentAddress, }) : super(key: key);

  @override
  State<MaintenanceCrad> createState() => _MaintenanceCradState();
}

class _MaintenanceCradState extends State<MaintenanceCrad> {
  DateTime dateStart = DateTime.now();
  DateTime dateEnd = DateTime.now();
  bool isStartdateselected = false;
  bool isEnddateselected = false;
  bool finish_load = false;
  var size_width;
  var size_height;

  @override
  Widget build(BuildContext context) {
    size_width = MediaQuery.of(context).size.width;
    size_height = MediaQuery.of(context).size.height;

    return Container(
      width: 324,
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
              child: ParagraphText(
            "Maintenance",
            fontWeight: FontWeight.w500,
            fontSize: 18,
          )),
          vSizedBox,
          ParagraphText('Maintenance Start Date'),
          vSizedBox05,
          GestureDetector(
            onTap: () {
              pick_date1();
            },
            child: Container(
              alignment: Alignment.centerLeft,
              width: size_width,
              height: size_height * 0.06,
              decoration: BoxDecoration(
                color: MyColors.whiteColor,
                border: Border.all(color: Color(0xffE1E1E1), width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: isStartdateselected == false
                      ? Text(
                          "Date",
                          style: TextStyle(
                              color: MyColors.hintcolor,
                              fontSize: 14,
                              fontFamily: 'Regular'),
                        )
                      : ParagraphText(
                          DateFormat("dd-MMM-yyyy").format(this.dateStart),
                        )),
            ),
          ),
          vSizedBox,
          ParagraphText('Maintenance End Date'),
          vSizedBox05,
          GestureDetector(
            onTap: () {
              pick_date2();
            },
            child: Container(
              alignment: Alignment.centerLeft,
              width: size_width,
              height: size_height * 0.06,
              decoration: BoxDecoration(
                color: MyColors.whiteColor,
                border: Border.all(color: Color(0xffE1E1E1), width: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: isEnddateselected == false
                    ? Text(
                        "Date",
                        style: TextStyle(
                            color: MyColors.hintcolor,
                            fontSize: 14,
                            fontFamily: 'Regular'),
                      )
                    : ParagraphText(
                        DateFormat("dd-MMM-yyyy").format(this.dateEnd),
                      ),
              ),
            ),
          ),
          vSizedBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RoundEdgedButton(
                text: 'SEND',
                height: 39,
                width: 140,
                verticalPadding: 0,
                borderRadius: 5,
                isLoad: finish_load,
                loaderColor: Colors.white,
                color: Color(0xff0F3750),
                onTap: () async{
                  ///Date validation
                  // bool isValidDate = dateStart.isBefore(dateEnd);
                  // if (isValidDate == false &&
                  //     isEnddateselected == true &&
                  //     isStartdateselected == true) {
                  //   toast('End date should be after start date');
                  // } else
                    if (isEnddateselected == false ||
                      isStartdateselected == false) {
                    toast('Date should not be empty');
                  } else {

                        Map<String, dynamic> request ={
                          'task_id' : widget.task_id,
                          'user_id' : userDataNotifier.value!.id ?? "",
                          'end_location' : widget.currentAddress,
                          'start_date' : DateFormat("yyyy-MM-dd").format(dateStart),
                          'end_date' : DateFormat("yyyy-MM-dd").format(dateEnd),
                        };

                        setState(() {
                          finish_load=true;
                        });

                        final Response = await Webservices.postData(apiUrl: ApiUrls.maintenance_complete_task, request: request);
                        log("finish task api response----${Response}");


                        if(Response['status'].toString() == '1'){
                          Navigator.pop(context);
                          Navigator.pop(context);

                        }else{
                          toast("Something went wrong");
                        }

                        setState(() {
                          finish_load=false;
                        });

                  }
                },
              ),
              RoundEdgedButton(
                text: 'CANCEL',
                height: 39,
                width: 140,
                verticalPadding: 0,
                borderRadius: 5,
                color: Color(0xffB49877),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  pick_date1() {
    return showDatePicker(
        context: context,
        initialDate: dateStart,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 100000)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: MyColors.primaryColor,
                onPrimary: Color(0xffE2E2E2),
                onSurface: Color(0xff1C1F24),
              ),
            ),
            child: child!,
          );
        }).then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : dateStart.year,
          value != null ? value.month : dateStart.month,
          value != null ? value.day : dateStart.day,
          dateStart.hour,
          dateStart.minute);
      setState(() {
        dateStart = newDate;
        isStartdateselected = true;
      });
    });
  }

  pick_date2() {
    return showDatePicker(
        context: context,
        initialDate: dateEnd,
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 100000)),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: MyColors.primaryColor,
                onPrimary: Color(0xffE2E2E2),
                onSurface: Color(0xff1C1F24),
              ),
            ),
            child: child!,
          );
        }).then((value) {
      DateTime newDate = DateTime(
          value != null ? value.year : dateEnd.year,
          value != null ? value.month : dateEnd.month,
          value != null ? value.day : dateEnd.day,
          dateEnd.hour,
          dateEnd.minute);
      setState(() {
        dateEnd = newDate;
        isEnddateselected = true;
      });
    });
  }
}
