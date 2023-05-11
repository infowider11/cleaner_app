import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/constants/sized_box.dart';
import 'package:cleanerapp/constants/toast.dart';
import 'package:cleanerapp/functions/navigation_functions.dart';
import 'package:cleanerapp/pages/LastInventoryscreen.dart';
import 'package:cleanerapp/pages/OriginalInventoryscreen.dart';
import 'package:cleanerapp/pages/finishscreen.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/custom_text_field.dart';
import 'package:cleanerapp/widgets/round_edged_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../constants/global_data.dart';
import '../services/api_urls.dart';
import '../services/webservices.dart';
import '../widgets/workcard.dart';
import 'notification.dart';

class TaskDetailsScreen extends StatefulWidget {
  String? task_id;
  bool isCleaner_task;
  TaskDetailsScreen({Key? key, required this.task_id, this.isCleaner_task=false}) : super(key: key);

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}


class _TaskDetailsScreenState extends State<TaskDetailsScreen> with SingleTickerProviderStateMixin{

  bool redoLoad =false;
  bool Microwave=true;
  bool Glasses=true;
  bool Mirror=true;
  bool Bathroom=true;
  bool clean=true;
  bool showaddmore = false;
  bool load = false;
  bool finish_load = false;
  bool load2 = false;
  bool load4 = false;
  int _current = 0;
  Map? taskDetail;
  Map? maintenanceTaskDetail;
  String task_name="";
  TextEditingController title=TextEditingController();
  TextEditingController location=TextEditingController();
  TextEditingController add =TextEditingController();
  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;
  String Checked_values='';
  final double minScale = 1;
  final double maxScale = 4;
  List task_list=[];
  var task_list1= [];
  var task_list2=[];
  var selected_checklist =  [];
  var final_check_list = [];

  task_detail() async{
    setState(() {load=true;});
    final Response= await Webservices.getMap(ApiUrls.task_detail+"?task_id=${widget.task_id}");
    log("task detail response---$Response");

      taskDetail = Response;
      log("task detail response---$taskDetail");
      print("task_detail---${taskDetail!['apartment']['name']}");

      taskDetail!['task_type'].toString() == "3" ? task_name = "Logistics" :
      taskDetail!['task_type'].toString() == "4" ? task_name = "Maintenance" :
      taskDetail!['task_type'].toString() == "5" ? task_name = "Cleaner" :
      task_name = "";

      if(taskDetail!['admin_checklist'] != "") {
        task_list1 = taskDetail!['admin_checklist'].split(",");
      }
    if(taskDetail!['staff_checklist'] != "") {
      task_list2 = taskDetail!['staff_checklist'].split(",");
    }
    if(taskDetail!['complete_checklist'] != "") {
      final_check_list = taskDetail!['complete_checklist'].split(",");
    }
    print("admin_checlist11 ${task_list1.length}");
    print("admin_checlist11 ${task_list2.length}");
      task_list=[];

      print("completed_checklist$final_check_list");
      for(int j=0 ; j<task_list1.length; j++){
        if( taskDetail!['status'].toString() == '1'){
          if(final_check_list.contains(task_list1[j])){
            task_list.add({'check':true,'title':task_list1[j]});
          }
          else {
            task_list.add({'check': false, 'title': task_list1[j]});
          }
        } else {
          task_list.add({'check': false, 'title': task_list1[j]});
        }
      }
      setState(() {});
      for(int j=0 ; j<task_list2.length; j++){
        if( taskDetail!['status'].toString() == '1'){
          if(final_check_list.contains(task_list2[j])){
            task_list.add({'check':true,'title':task_list2[j]});
          }
          else {
            task_list.add({'check': false, 'title': task_list2[j]});
          }
        } else {
          task_list.add({'check': false, 'title': task_list2[j]});
        }
      }
    setState(() {load=false;});
  }

  addchecklistapi() async{
    setState(() {load2=true;});

    Map<String, dynamic> request= {
      "task_id" : taskDetail?['id'],
      "check_list" : add.text,
      "staff_id" : userDataNotifier.value?.id,
    };

    final Response= await Webservices.postData(apiUrl: ApiUrls.add_checkList, request: request);
    print("add check list response $Response");

    if(Response['status'].toString() =="1"){
      toast('Checklist has been added successfully.');
      task_detail();
    }
    setState(() {load2=false;});
  }

  maintenance_task_detail() async{
    setState(() {load=true;});

    final Response= await Webservices.getMap(ApiUrls.maintenance_task_detail+"?task_id=${widget.task_id}");
    log("maintenance_task_detail_response---$Response");

    maintenanceTaskDetail = Response;
    setState(() {load=false;});
  }

  @override
  void initState() {
    if(userDataNotifier.value?.userType != UserType.Maintenance || widget.isCleaner_task==true) {
      task_detail();
    } else{
      maintenance_task_detail();
    }

    _getCurrentPosition();
    controller = TransformationController();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200))..addListener(() {
      controller.value = animation!.value;
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  String? _currentAddress;
  Position? _currentPosition;
  bool load3 = false;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    print('LAT: ${_currentPosition?.latitude ?? ""}');
    print('LNG: ${_currentPosition?.longitude ?? ""}');
    print('ADDRESS: ${_currentAddress ?? ""}');
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
        _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
      location.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        leading: GestureDetector(
          onTap: (){
            Navigator.pop(context);
          },
            child: Icon(Icons.arrow_back_ios)),
        title:ParagraphText('Task Detail #${widget.task_id}',fontWeight: FontWeight.w500,fontSize:18,),
        toolbarHeight: 73,
        titleSpacing:-10,


      ),

      body:
      load==true  || load2==true ? Center(child: CupertinoActivityIndicator(radius: 20, color: MyColors.primaryColor,),):

      userDataNotifier.value?.userType != UserType.Maintenance ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [


            taskDetail!['apartment']['image'].length != 0 ?
                  CarouselSlider(
                  options: CarouselOptions(
                      height: 170,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }
                  ),
                  items : [
                    ListView.builder(itemBuilder: (context ,index){
                      return  taskDetail!['apartment']['image'][index]['image'];})].map((i){
                    return Builder(
                        builder:(BuildContext context) {
                          return    ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: taskDetail!['apartment']['image'].length,
                              itemBuilder: (context, index) {
                                return  CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(radius: 10, color: MyColors.primaryColor,),
                                  imageUrl: taskDetail!['apartment']['image'][index]['image'],
                                );
                              });});}).toList(),


                ):

                 Container(
                        alignment: Alignment.center,
                        height: 170,
                        width: double.infinity,
                        child: ParagraphText("No Image", color: Colors.black,),
                     ),

                    // :
                // Container(
                //   alignment: Alignment.center,
                //   height: 170,
                //   width: double.infinity,
                //   child: Text("No Image"),
                // ),

                if(userDataNotifier.value?.userType != UserType.Logistics)
                Positioned(
                  right: 5,
                  child: RoundEdgedButton(
                    icon:MyImages.flag ,
                    text: taskDetail!['is_report'].toString() == '0' ? 'REPORT MAINTENANCE' : 'REPORTED',
                     fontSize: 10,
                     width: taskDetail!['is_report'].toString() == '0' ? size_width*0.39 : size_width*0.24,
                     height: 24,
                     verticalMargin:5,
                     verticalPadding: 0,
                    borderRadius: 5,
                    onTap:() async{

                      if(taskDetail!['is_report'].toString() == '0') {
                      await showDialog(
                          context: context,
                          builder: (ctx) =>
                              Dialog(
                                  insetPadding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: ReportCard(
                                    current_location: _currentAddress ?? "",
                                    taskDetail: taskDetail,)

                              ),
                        );

                         task_detail();

                      }else{
                        toast('This task already been reported');
                      }
                    },

                  ),
                )
              ],
            ),

            vSizedBox2,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText('${taskDetail!['apartment']['name']}',color: MyColors.primaryColor,fontWeight: FontWeight.w600,fontSize: 16,),
                  ParagraphText('#${taskDetail!['apartment']['apartment_no']}',color:Colors.black,fontWeight: FontWeight.w600,fontSize: 16,),
                ],
              ),
            ),
            vSizedBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: size_width/1.1,
                child: Wrap(
                  children: [
                    Icon(Icons.location_on_rounded,color: Color(0xffB49877),size:12,),
                    hSizedBox05,
                    ParagraphText('${taskDetail!['apartment']['location']}',color: Colors.black,fontSize: 12,),

                  ],
                ),
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(MyImages.apartmenttype,height:12,width:12,),
                      hSizedBox05,
                      ParagraphText('${taskDetail!['apartment_type']['name']}',color: Colors.black,fontSize: 12,),

                    ],
                  ),

                ],
              ),
            ),
            vSizedBox05,
            Container(
              color: Color(0xffD9D9D9),
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical:5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month,color: Color(0xffB49877),size:12,),
                        hSizedBox05,
                        ParagraphText('Started on ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(taskDetail!['date']))}  ${taskDetail!['time']}',color: Colors.black,fontSize: 12,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.cleaning_services_rounded,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  SizedBox(
                    width: 330,
                    child: Wrap(
                      children: [
                        ParagraphText('${taskDetail!['apartment']['check_list']}',color:Color(0xff0F3750),underlined: true,fontSize: 12,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(Icons.person,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  ParagraphText('${taskDetail!['staff_data']['name']} (${taskDetail!['task_for']['role']})',color: Colors.black,fontSize: 12,fontWeight:FontWeight.w600,),

                ],
              ),
            ),

              vSizedBox05,


            if(userDataNotifier.value?.userType != UserType.Maintenance || widget.isCleaner_task==true)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  if(taskDetail?['supervisior']!=null)
                  Icon(Icons.person,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  if(taskDetail?['supervisior']!=null)
                  ParagraphText('${taskDetail!['supervisior']['name']} (Supervisor)',color: Colors.black,fontSize: 12,fontWeight:FontWeight.w600,),

                ],
              ),
            ),
            if(taskDetail!['color_status'].toString() != "0")
              vSizedBox05,

            if(userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics )
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    taskDetail!['color_status'].toString() == "0" ? Container(height: 0,):
                    Icon(Icons.circle,color: Color(0xffB49877),size:12,),
                    hSizedBox05,
                    ParagraphText(taskDetail!['color_status'].toString() == "1" ? "Arrival" :
                    taskDetail!['color_status'].toString() == "2" ? "In House" : "" ,color: Colors.black,fontSize: 12,fontWeight:FontWeight.w600,),

                  ],
                ),
              ),
            if(taskDetail!['color_status'].toString() != "0")
            vSizedBox05,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(8),
                  //     bottomRight: Radius.circular(8)
                  // )
              ),
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText('Assign By: ${taskDetail?['assinged_by']['name']}',fontSize:12,fontWeight: FontWeight.w500,color: Colors.white,),
                  // RoundEdgedButton(text: 'Start ', width: 53, height:22, verticalPadding: 0, verticalMargin: 0,)
                ],
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row
                (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundEdgedButton(onTap: (){
                    push(context: context, screen: OriginalInventoryScreen(image: taskDetail!['apartment']['image']));
                  },text: 'ORIGINAL INVENTORY',height: 33,width: 171,verticalPadding: 0,borderRadius: 5,color: MyColors.primaryColor,),
                  RoundEdgedButton(onTap: (){
                    push(context: context, screen: LastInventoryScreen(cleanerName: taskDetail!['staff_data']['name'], image: taskDetail!['apartment']['last_inventroy_image'], date: taskDetail!['date'], time: taskDetail!['time'],));
                  },text: 'LAST INVENTORY',height: 33,width: 171,verticalPadding: 0,borderRadius: 5,color: Color(0xffB49877),),
                ],
              ),
            ),
            // vSizedBox2,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ParagraphText('Checklist',fontSize: 16,fontWeight: FontWeight.w600,),
                ),
                if(userDataNotifier.value?.userType  == UserType.Cleaners && taskDetail!['status'].toString() != '1'  )//cleaners
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                  child: RoundEdgedButton(
                    text: 'Add More Checklist',
                    color: MyColors.primaryColor,
                    width: 140,
                    fontSize: 12,
                    horizontalMargin: 0,
                    verticalPadding: 0,
                    borderRadius: 12,
                    height: 40,
                    verticalMargin: 0,
                    onTap: (){
                      setState(() {
                        add.text = '';

                        showaddmore = !showaddmore;
                      });
                    },
                  ),
                ),
              ],
            ),
            vSizedBox05,
            if(showaddmore)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomTextField(
                      controller: add,
                      hintText: 'Add checklist',
                      bgColor: Colors.white,
                  ),
                  Positioned(
                    right: 5,
                    child: RoundEdgedButton(
                      text: 'Done',
                      color: MyColors.primaryColor,
                      width: 57,
                      horizontalMargin: 0,
                      verticalPadding: 0,
                      borderRadius: 12,
                      height: 40,
                      onTap: (){


                        ///calling add check list api
                        if(add.text == ''){
                          toast('Please enter checklist name');
                        }else {
                          setState(() {
                            showaddmore = !showaddmore;
                          });
                          addchecklistapi();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            vSizedBox05,

          if(userDataNotifier.value?.userType != UserType.Logistics)
            for(int i=0;i<task_list.length;i++)
            Row(
              children: [

                if(task_list[i]['check'] == false && taskDetail!['status'].toString() == '1')
                  Row(
                    children: [
                      SizedBox(width: 12),
                      Icon(CupertinoIcons.multiply_square_fill, color: Colors.red,),
                      SizedBox(width: 12),
                    ],
                  ),///not completed task

                if(task_list[i]['check'] == true || task_list[i]['check'] == false && taskDetail!['status'].toString() != '1')
                  SizedBox(
                    height:32,
                    child: Checkbox(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        side:BorderSide(color:MyColors.primaryColor,),
                        checkColor: Colors.white,
                        activeColor: Color(0xff000000),
                        fillColor: MaterialStateProperty.all<Color>((MyColors.primaryColor)),
                        value: task_list[i]['check']??null,
                        // value:  taskDetail!['status'].toString() == '1' && selected_checklist.contains(task_list) ? true : null,
                        onChanged: (bool? value) {
                          if(taskDetail!['status'].toString() == '1' || userDataNotifier.value?.userType  != UserType.Cleaners){
                            print("Onchanged disable");
                          }else{
                            setState(() {
                              task_list[i]['check']  =!  task_list[i]['check'];
                            });


                            selected_checklist = [];
                            for(int index=0; index<task_list.length; index++) {
                              if (task_list[index]['check'] == true && !selected_checklist.contains(task_list[index]['title']))
                                selected_checklist.add(task_list[index]['title']);
                            }

                            print("checking_chcklist ${task_list[i]['check']}");
                            print("adding_chcklist ${selected_checklist}");
                            Checked_values = selected_checklist.join(',');
                            print("string_format_checklist ${Checked_values}");
                          }

                        }
                    ),
                  ),///before start & after complte task

                ParagraphText('${task_list[i]['title']}')
              ],
            ),

            if(userDataNotifier.value?.userType == UserType.Logistics)
              for(int i=0;i<task_list.length;i++)
              ParagraphText('   \u2022   ${task_list[i]['title']}')

          ],
        ),
      ):
      widget.isCleaner_task==true ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [


            taskDetail!['apartment']['image'].length != 0 ?
                  CarouselSlider(
                  options: CarouselOptions(
                      height: 170,
                      viewportFraction: 1,
                      enableInfiniteScroll: false,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }
                  ),
                  items : [
                    ListView.builder(itemBuilder: (context ,index){
                      return  taskDetail!['apartment']['image'][index]['image'];})].map((i){
                    return Builder(
                        builder:(BuildContext context) {
                          return    ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: taskDetail!['apartment']['image'].length,
                              itemBuilder: (context, index) {
                                return  CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(radius: 10, color: MyColors.primaryColor,),
                                  imageUrl: taskDetail!['apartment']['image'][index]['image'],
                                );
                              });});}).toList(),


                ):

                 Container(
                        alignment: Alignment.center,
                        height: 170,
                        width: double.infinity,
                        child: ParagraphText("No Image", color: Colors.black,),
                     ),



                if(userDataNotifier.value?.userType != UserType.Logistics)
                Positioned(
                  right: 5,
                  child: RoundEdgedButton(
                    icon:MyImages.flag ,
                    text: taskDetail!['is_report'].toString() == '0' ? 'REPORT MAINTENANCE' : 'REPORTED',
                     fontSize: 10,
                     width: taskDetail!['is_report'].toString() == '0' ? size_width*0.39 : size_width*0.24,
                     height: 24,
                     verticalMargin:5,
                     verticalPadding: 0,
                    borderRadius: 5,
                    onTap:() async{

                      if(taskDetail!['is_report'].toString() == '0') {
                      await showDialog(
                          context: context,
                          builder: (ctx) =>
                              Dialog(
                                  insetPadding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: ReportCard(
                                    current_location: _currentAddress ?? "",
                                    taskDetail: taskDetail,)

                              ),
                        );

                         task_detail();

                      }else{
                        toast('This task already been reported');
                      }
                    },

                  ),
                )
              ],
            ),

            vSizedBox2,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText('${taskDetail!['apartment']['name']}',color: MyColors.primaryColor,fontWeight: FontWeight.w600,fontSize: 16,),
                  ParagraphText('#${taskDetail!['apartment']['apartment_no']}',color:Colors.black,fontWeight: FontWeight.w600,fontSize: 16,),
                ],
              ),
            ),
            vSizedBox,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: SizedBox(
                width: size_width/1.1,
                child: Wrap(
                  children: [
                    Icon(Icons.location_on_rounded,color: Color(0xffB49877),size:12,),
                    hSizedBox05,
                    ParagraphText('${taskDetail!['apartment']['location']}',color: Colors.black,fontSize: 12,),

                  ],
                ),
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(MyImages.apartmenttype,height:12,width:12,),
                      hSizedBox05,
                      ParagraphText('${taskDetail!['apartment_type']['name']}',color: Colors.black,fontSize: 12,),

                    ],
                  ),

                ],
              ),
            ),
            vSizedBox05,
            Container(
              color: Color(0xffD9D9D9),
              child:Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10,vertical:5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_month,color: Color(0xffB49877),size:12,),
                        hSizedBox05,
                        ParagraphText('Assigned on ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(taskDetail!['date']))}  ${taskDetail!['time']}',color: Colors.black,fontSize: 12,),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.cleaning_services_rounded,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  SizedBox(
                    width: 330,
                    child: Wrap(
                      children: [
                        ParagraphText('${taskDetail!['apartment']['check_list']}',color:Color(0xff0F3750),underlined: true,fontSize: 12,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(Icons.person,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  ParagraphText('${taskDetail!['staff_data']['name']} (${taskDetail!['task_for']['role']})',color: Colors.black,fontSize: 12,fontWeight:FontWeight.w600,),

                ],
              ),
            ),
            if(taskDetail!['color_status'].toString() != "0")
            vSizedBox05,

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  taskDetail!['color_status'].toString() == "0" ? SizedBox(height: 0,):
                  Icon(Icons.circle,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  ParagraphText(taskDetail!['color_status'].toString() == "1" ? "Arrival" :
                  taskDetail!['color_status'].toString() == "2" ? "In House" : "" ,color: Colors.black,fontSize: 12,fontWeight:FontWeight.w600,),

                ],
              ),
            ),
            if(taskDetail!['color_status'].toString() != "0")
              vSizedBox05,

            if(userDataNotifier.value?.userType != UserType.Maintenance &&  taskDetail?['supervisior']!=null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(Icons.person,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  ParagraphText('${taskDetail!['supervisior']['name']} (Supervisor)',color: Colors.black,fontSize: 12,fontWeight:FontWeight.w600,),

                ],
              ),
            ),

            vSizedBox05,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  // borderRadius: BorderRadius.only(
                  //     bottomLeft: Radius.circular(8),
                  //     bottomRight: Radius.circular(8)
                  // )
              ),
              height: 28,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ParagraphText('Assign By: ${taskDetail?['assinged_by']['name']}',fontSize:12,fontWeight: FontWeight.w500,color: Colors.white,),
                  // RoundEdgedButton(text: 'Start ', width: 53, height:22, verticalPadding: 0, verticalMargin: 0,)
                ],
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row
                (
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RoundEdgedButton(onTap: (){
                    push(context: context, screen: OriginalInventoryScreen(image: taskDetail!['apartment']['image']));
                  },text: 'ORIGINAL INVENTORY',height: 33,width: 171,verticalPadding: 0,borderRadius: 5,color: MyColors.primaryColor,),
                  RoundEdgedButton(onTap: (){
                    push(context: context, screen: LastInventoryScreen(cleanerName: taskDetail!['staff_data']['name'], image: taskDetail!['apartment']['last_inventroy_image'], date: taskDetail!['date'], time: taskDetail!['time'],));
                  },text: 'LAST INVENTORY',height: 33,width: 171,verticalPadding: 0,borderRadius: 5,color: Color(0xffB49877),),
                ],
              ),
            ),
            // vSizedBox2,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ParagraphText('Checklist',fontSize: 16,fontWeight: FontWeight.w600,),
                ),
                if(userDataNotifier.value?.userType  == UserType.Cleaners && taskDetail!['status'].toString() != '1'  )//cleaners
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0,),
                  child: RoundEdgedButton(
                    text: 'Add More Checklist',
                    color: MyColors.primaryColor,
                    width: 140,
                    fontSize: 12,
                    horizontalMargin: 0,
                    verticalPadding: 0,
                    borderRadius: 12,
                    height: 40,
                    verticalMargin: 0,
                    onTap: (){
                      setState(() {
                        add.text = '';

                        showaddmore = !showaddmore;
                      });
                    },
                  ),
                ),
              ],
            ),
            vSizedBox05,
            if(showaddmore)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  CustomTextField(
                      controller: add,
                      hintText: 'Add checklist',
                      bgColor: Colors.white,
                  ),
                  Positioned(
                    right: 5,
                    child: RoundEdgedButton(
                      text: 'Done',
                      color: MyColors.primaryColor,
                      width: 57,
                      horizontalMargin: 0,
                      verticalPadding: 0,
                      borderRadius: 12,
                      height: 40,
                      onTap: (){


                        ///calling add check list api
                        if(add.text == ''){
                          toast('Please enter checklist name');
                        }else {
                          setState(() {
                            showaddmore = !showaddmore;
                          });
                          addchecklistapi();
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            vSizedBox05,

          if(userDataNotifier.value?.userType != UserType.Logistics)
            for(int i=0;i<task_list.length;i++)
            Row(
              children: [

                if(task_list[i]['check'] == false && taskDetail!['status'].toString() == '1')
                  Row(
                    children: [
                      SizedBox(width: 12),
                      Icon(CupertinoIcons.multiply_square_fill, color: Colors.red,),
                      SizedBox(width: 12),
                    ],
                  ),///not completed task

                if(task_list[i]['check'] == true || task_list[i]['check'] == false && taskDetail!['status'].toString() != '1')
                  SizedBox(
                    height:32,
                    child: Checkbox(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                        side:BorderSide(color:MyColors.primaryColor,),
                        checkColor: Colors.white,
                        activeColor: Color(0xff000000),
                        fillColor: MaterialStateProperty.all<Color>((MyColors.primaryColor)),
                        value: task_list[i]['check']??null,
                        // value:  taskDetail!['status'].toString() == '1' && selected_checklist.contains(task_list) ? true : null,
                        onChanged: (bool? value) {
                          if(taskDetail!['status'].toString() == '1' || userDataNotifier.value?.userType  != UserType.Cleaners){
                            print("Onchanged disable");
                          }else{
                            setState(() {
                              task_list[i]['check']  =!  task_list[i]['check'];
                            });


                            selected_checklist = [];
                            for(int index=0; index<task_list.length; index++) {
                              if (task_list[index]['check'] == true && !selected_checklist.contains(task_list[index]['title']))
                                selected_checklist.add(task_list[index]['title']);
                            }

                            print("checking_chcklist ${task_list[i]['check']}");
                            print("adding_chcklist ${selected_checklist}");
                            Checked_values = selected_checklist.join(',');
                            print("string_format_checklist ${Checked_values}");
                          }

                        }
                    ),
                  ),///before start & after complte task

                ParagraphText('${task_list[i]['title']}')
              ],
            ),

            if(userDataNotifier.value?.userType == UserType.Logistics)
              for(int i=0;i<task_list.length;i++)
              ParagraphText('   \u2022   ${task_list[i]['title']}')

          ],
        ),
      ):
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(maintenanceTaskDetail?['task_image'] != "")
            CachedNetworkImage(
                fit: BoxFit.cover,
                height: 170,
                width: MediaQuery.of(context).size.width,
                placeholder: (context, url) =>
                const CupertinoActivityIndicator(radius: 10, color: MyColors.primaryColor,),
                imageUrl: maintenanceTaskDetail?['task_image']
            ),

          maintenanceTaskDetail?['images'].length != 0 && maintenanceTaskDetail?['task_image'] == ""?
          CarouselSlider(
            options: CarouselOptions(
                height: 170,
                viewportFraction: 1,
                enableInfiniteScroll: false,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }
            ),
            items : [
              ListView.builder(itemBuilder: (context ,index){
                return  maintenanceTaskDetail!['images'][index]['image'];})].map((i){
              return Builder(
                  builder:(BuildContext context) {
                    return    ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: maintenanceTaskDetail!['images'].length,
                        itemBuilder: (context, index) {
                          return  CachedNetworkImage(
                            fit: BoxFit.cover,
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            placeholder: (context, url) =>
                            const CupertinoActivityIndicator(radius: 10, color: MyColors.primaryColor,),
                            imageUrl: maintenanceTaskDetail!['images'][index]['image']
                          );
                        });});}).toList(),


          ):
          maintenanceTaskDetail?['task_image'] == "" ?
            Container(
            alignment: Alignment.center,
            height: 170,
            width: double.infinity,
            child: ParagraphText("No Image", color: Colors.black,),
          ): Container(),

          vSizedBox2,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ParagraphText('${maintenanceTaskDetail!['apartment']['name']}',color: MyColors.primaryColor,fontWeight: FontWeight.w600,fontSize: 16,),
                ParagraphText('#${maintenanceTaskDetail!['apartment']['apartment_no']}',color:Colors.black,fontWeight: FontWeight.w600,fontSize: 16,),
              ],
            ),
          ),
          vSizedBox,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SizedBox(
              width: size_width/1.1,
              child: Wrap(
                children: [
                  Icon(Icons.location_on_rounded,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  ParagraphText('${maintenanceTaskDetail!['apartment']['location']}',color: Colors.black,fontSize: 12,),

                ],
              ),
            ),
          ),
          vSizedBox05,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                    Image.asset(MyImages.apartmenttype,height:12,width:12,),
                    hSizedBox05,
                    ParagraphText('${maintenanceTaskDetail!['apartment_type']['name']}',color: Colors.black,fontSize: 12,),
              ],
            ),
          ),
          vSizedBox05,
          Container(
            color: Color(0xffD9D9D9),
            child:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical:5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_month,color: Color(0xffB49877),size:12,),
                      hSizedBox05,
                      ParagraphText('Assigned on ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(maintenanceTaskDetail!['date']))}  ${maintenanceTaskDetail!['time']}',color: Colors.black,fontSize: 12,),
                    ],
                  ),
                ],
              ),
            ),
          ),
          vSizedBox05,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.work, size: 12, color: Color(0xffB49877),),
                hSizedBox05,
                ParagraphText('${maintenanceTaskDetail!['title']}',color: Colors.black,fontSize: 12,),
              ],
            ),
          ),
          vSizedBox05,



          if(maintenanceTaskDetail?['started_by'] != null && maintenanceTaskDetail?['started_by']['id'] != userDataNotifier.value?.id)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.person, size: 12, color: Color(0xffB49877),),
                    hSizedBox05,
                    ParagraphText('Started by ${maintenanceTaskDetail?['started_by']['name']}',color: Colors.black,fontSize: 12,),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.timelapse, size: 12, color: Color(0xffB49877),),
                    hSizedBox05,
                    ParagraphText('Started on ${(maintenanceTaskDetail?['start_date'])}',color: Colors.black,fontSize: 12,),
                  ],
                ),

                if(maintenanceTaskDetail?['status'].toString() == '1')
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.person, size: 12, color: Color(0xffB49877),),
                        hSizedBox05,
                        ParagraphText('Completed by ${maintenanceTaskDetail?['started_by']['name']}',color: Colors.black,fontSize: 12,),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.timelapse, size: 12, color: Color(0xffB49877),),
                        hSizedBox05,
                        ParagraphText('Completed at ${maintenanceTaskDetail?['end_date']}',color: Colors.black,fontSize: 12,),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          vSizedBox05,
          if(maintenanceTaskDetail?['assinged_by']!= null)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
            ),
            height: 28,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ParagraphText('Assign By: ${maintenanceTaskDetail?['assinged_by']['name']}',fontSize:12,fontWeight: FontWeight.w500,color: Colors.white,),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar:
      taskDetail?['status'] == null && userDataNotifier.value?.userType == UserType.Cleaners ? Container(height: 10,):
      ///for cleaner
      userDataNotifier.value?.userType == UserType.Cleaners ? Padding(
        padding: const EdgeInsets.all(8.0),
        child:  taskDetail!['status'].toString() == '0' ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RoundEdgedButton(text: 'START',isLoad: load3, height:49,verticalPadding: 0,borderRadius: 5,color:Color(0xff14A300),
            onTap: () async{
              Map<String, dynamic> request ={
                'task_id' : widget.task_id,
                'user_id' : userDataNotifier.value!.id ?? "",
                'lat' : _currentPosition?.latitude.toString() ?? "",
                'lng' : _currentPosition?.longitude.toString() ?? "",
                'start_location' : _currentAddress.toString() ?? "",
              };

              setState(() {
                load3=true;
              });
              final Response = await Webservices.postData(apiUrl: ApiUrls.start_task, request: request);
              log("start task api response----${Response['status']}");

              Navigator.pop(context);

              setState(() {
                load3=false;
              });
            },),
        ):
        taskDetail!['status'].toString() == '1' ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RoundEdgedButton(text: 'COMPLETED',height: 49,verticalPadding: 0,borderRadius: 5,color: Color(0xff14A300),
            onTap: (){

            },),
        ):
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RoundEdgedButton(text: 'FINISH',height: 49,verticalPadding: 0,borderRadius: 5,color: Color(0xffFB0404),onTap: () async{

            if(Checked_values == "" || Checked_values == null) {
              toast('Please select atleast one checklist');
            }else{
              bool? result = await push(context: context, screen: FinishScreen(taskDetail: taskDetail, completed_checklist: Checked_values,));
              if(result ==true){
                Navigator.pop(context);
                setState(() {});
              }
              task_detail();
              setState(() {});
            }
          },),
        ),
      ) :

      ///for maintenance
      maintenanceTaskDetail?['status'] != null && userDataNotifier.value?.userType == UserType.Maintenance ? Padding(
        padding: const EdgeInsets.all(8.0),
        child:
        maintenanceTaskDetail?['started_by'] != null && maintenanceTaskDetail?['started_by']['id'] != userDataNotifier.value?.id ? Container(height: 0,) :
        maintenanceTaskDetail?['status'].toString() == '0' || maintenanceTaskDetail?['status'].toString() == '4' ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RoundEdgedButton(text: 'START',isLoad: load3, loaderColor: MyColors.whiteColor, height:49,verticalPadding: 0,
            borderRadius: 5,color:Color(0xff14A300),
            onTap: () async{
              Map<String, dynamic> request ={
                'task_id' : widget.task_id,
                'user_id' : userDataNotifier.value!.id ?? "",
                'start_location' : _currentAddress.toString() ?? "",
              };

              setState(() {
                load3=true;
              });

              final Response = await Webservices.postData(apiUrl: ApiUrls.maintenance_start_task, request: request);
              log("start task api response----${Response['status']}");

              Navigator.pop(context);

              setState(() {
                load3=false;
              });
            },

          ),
        ):
        maintenanceTaskDetail?['status'].toString() == '1' ?
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RoundEdgedButton(text: 'COMPLETED',height: 49,verticalPadding: 0,borderRadius: 5,color: Color(0xff14A300),
            onTap: (){
              toast("Task has been completed");
            },
           ),
        ):
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: RoundEdgedButton(text: 'FINISH',height: 49,verticalPadding: 0,borderRadius: 5,color: Color(0xffFB0404),
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
                                  'Are you Sure! Do you want to finish the task?',
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
                                      text: "Yes",
                                      width: size_width/3,
                                      color: MyColors.primaryColor,
                                      isLoad: finish_load,
                                      loaderColor: MyColors.whiteColor,
                                      onTap: () async{
                                        await showDialog(
                                          context: context,
                                          builder: (ctx) =>
                                              Dialog(
                                                  insetPadding: EdgeInsets.all(10),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.all(
                                                          Radius.circular(20.0))),
                                                  child: MaintenanceCrad(task_id: widget.task_id, currentAddress: _currentAddress.toString(),)
                                              ),
                                        );

                                        Navigator.pop(context);
                                        maintenance_task_detail();
                                        toast("Thank you ! Task has been finish successfully");
                                      },

                                    ),
                                    RoundEdgedButton(
                                      text: "No",
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
        ),
      ) :

          ///for supervisor
      userDataNotifier.value?.userType == UserType.Supervisor && taskDetail?['supervisior_task_status'] != null ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundEdgedButton(
                text: taskDetail?['supervisior_task_status'].toString() == '0' ? 'Mark as supervised' : 'Checked by supervisor',
                isLoad: load4,
                height:49,
                verticalPadding: 0,
                borderRadius: 5,
                color:  taskDetail?['supervisior_task_status'].toString() == '0' ? Color(0xffF85900) :  Colors.green,
               onTap: () async{
                 if(taskDetail?['supervisior_task_status'].toString() == '1') {
                   toast('You have already supervised this task.');
                 }
                 // else if( taskDetail?['status'].toString() == '0' || taskDetail!['status'].toString() == '2' ){
                 //   toast('This task has not been completed yet.');
                 // }
                 else if(taskDetail?['supervisior_task_status'].toString() == '0'){
                   {

                     ///checked by supervisor api
                     Map<String,dynamic> request={
                       'task_id': taskDetail?['id'],
                       'check_status': "1",
                     };

                     setState(() {
                       load4=true;
                     });
                     final Response= await Webservices.postData(apiUrl: ApiUrls.supervisior_check_task , request: request, showErrorMessage: false, showSuccessMessage: false);
                     log("checked by supervisor api response---$Response");

                     setState(() {
                       load4=false;
                     });

                     if(Response['status'].toString() =="1"){
                       toast("Task has been supervised");
                       task_detail();
                     }else{
                       toast("${Response['message']}");
                     }
                   }
                 }

               },
              ),

              // if(taskDetail!['status'].toString() =="1" )
                if(taskDetail!['supervisior_task_status'].toString() == '1')
              RoundEdgedButton(
                text: 'Re Do (Not Done Properly)',
                height:49,
                verticalPadding: 0,
                isLoad: redoLoad,
                verticalMargin: 0,
                borderRadius: 5,
                loaderColor: MyColors.whiteColor,
                color: Color(0xffB49877),
               onTap: () {
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
                                     'Are you Sure! you want to re-do this task?',
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
                                         text: "Yes",
                                         width: size_width/3,
                                         color: MyColors.primaryColor,
                                         isLoad: redoLoad,
                                         loaderColor: MyColors.whiteColor,
                                         onTap: () async{
                                           ///REDO api itegration

                                           setState(() {
                                             redoLoad = true;
                                           });

                                           Map<String, dynamic> request = {
                                             'task_id' : taskDetail?['id']??'',
                                             'supervisior_id' : userDataNotifier.value?.id??'',
                                           };

                                           final response = await Webservices.postData(apiUrl: ApiUrls.supervisior_redo_task, request: request);

                                           setState(() {
                                             redoLoad = false;
                                           });

                                           if(response['status'].toString() == '1'){
                                             Navigator.pop(context);
                                             Navigator.pop(context);
                                             toast("Thank you ! Task has been re open again and cleaner notify");
                                           }else{
                                             toast("Something went wrong");
                                           }
                                         },
                                       ),
                                       RoundEdgedButton(
                                         text: "No",
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

               }
              ),
            ],
          ),
        ),
      ) :
      null,
      
     );
  }

  void resetAnimation() {
    animation = Matrix4Tween(
      begin: controller.value,
      end: Matrix4.identity(),
    ).animate(
      CurvedAnimation(parent: animationController, curve:Curves.ease, ),
    );
    animationController.forward(from: 0);
  }
}
