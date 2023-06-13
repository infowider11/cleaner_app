import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/global_data.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/pages/taskdetailsscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../constants/sized_box.dart';
import '../constants/toast.dart';
import '../functions/addTaskpopup.dart';
import '../functions/navigation_functions.dart';
import '../services/api_urls.dart';
import '../services/webservices.dart';
import '../widgets/CustomTexts.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/round_edged_button.dart';

class My_created_task_list extends StatefulWidget {
  const My_created_task_list({Key? key}) : super(key: key);

  @override
  State<My_created_task_list> createState() => _My_created_task_listState();
}

class _My_created_task_listState extends State<My_created_task_list> {

  PopupMenuItem _buildPopupMenuItem( String title, int position) {
    return PopupMenuItem(
      height: 0,
      value: position,
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size_height*0.005,),
          Text(title, style: TextStyle(color:  position == Options.Delete.index? Colors.red : Colors.black),),
          SizedBox(height: size_height*0.005,),
          position == Options.Delete.index ? Container(height: 0,) :
          Divider()
        ],
      ),
    );
  }

  bool load=false;
  bool loadAddTask=false;
  bool deleteTask=false;
  List task_list_data=[];
  List checkList=[];
  List checkList_final=[];
  Map? selected_apt;
  Map? selected_priority;
  Map? apt_priority_data;
  Map? selected_cleaner;
  List cleaner_list = [];
  DateTime selectedDate1 = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  TextEditingController datepicker = TextEditingController();
  TextEditingController timepicker = TextEditingController();
  bool isEnable=false;

  pick_date1() {
    return showDatePicker(
        context: context,
        initialDate: selectedDate1,
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
          value != null ? value.year : selectedDate1.year,
          value != null ? value.month : selectedDate1.month,
          value != null ? value.day : selectedDate1.day,
          selectedDate1.hour,
          selectedDate1.minute);
      setState(() {
        selectedDate1 = newDate;
        print("selectedDate1${DateFormat("yyyy-MM-dd").format(selectedDate1)}");
        datepicker.text = DateFormat("dd-MMM-yyyy").format(selectedDate1);
      });

    });
  }

  _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
        context: context,
        initialTime: _time,
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
        }
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        print("_time$_time");
        timepicker.text = _time.format(context);
      });
    }
  }

  Future<void> taskList() async {

    setState(() {load=true;});
    final Response= await Webservices.getList(ApiUrls.task_list+"?user_id=${userDataNotifier.value?.id}&type=2");



    if(Response.length>0){
      task_list_data = Response ;
      log("task_list response---${task_list_data[0]['id']}");

      checkList =[];
      for(int i=0 ; i<task_list_data.length;i++){

        ///storing start work status
        task_list_data[i]['status'].toString() == '0' ? task_list_data[i]['workStatus'] = "NOT STARTED" :
        task_list_data[i]['status'].toString() == '2' ? task_list_data[i]['workStatus'] = "IN PROGRESS" :
        task_list_data[i]['status'].toString() == '1' ? task_list_data[i]['workStatus'] = "COMPLETED" :
        task_list_data[i]['workStatus'] = "";
        print("vvvvvv ${task_list_data[i]['status']}.....$i......${task_list_data[i]['workStatus']}");
      }
      setState(() {});
    }
    else{
      task_list_data=[];
    }
    supervisorDropdownData();



  }

  supervisorDropdownData() async{
    ///apartment & priority list------------------

    final Response= await Webservices.getMap(ApiUrls.apartment_priority_list);

    if(Response.length>0){
      apt_priority_data = Response ;
      log("apartment_&_priority_list_response---${apt_priority_data}");
    }

    ///staff list---------------------------------

    final staffRes = await Webservices.getList(ApiUrls.supervisior_cleaner_list+"?supervisior_id=${userDataNotifier.value?.id}");

    if(Response.length>0){
      cleaner_list = staffRes ;
      log("Cleaner_list: $cleaner_list");
    }
    setState(() {load=false;});

  }

  @override
  void initState() {
    taskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:MyColors.scafoldcolor,

      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        elevation: 0.0,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.chevron_left, color: MyColors.whiteColor, size: 30,)),
        centerTitle: true,
        title: ParagraphText('Created Tasks',color: MyColors.whiteColor,fontWeight: FontWeight.w500,fontSize: 18,),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,  ),
                child: StatefulBuilder(
                    builder: (context, dialog_setState) {

                      return AlertDialog(
                        backgroundColor:   MyColors.scafoldcolor,
                        insetPadding: EdgeInsets.zero,
                        contentPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        content: Padding(
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                          child: Container(
                            width: MediaQuery.of(context).size.width / 1.1,

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ///heading
                                    Text("Add Task",
                                      style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                                    ),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: InkWell(
                                          onTap: ()=> Navigator.pop(context),
                                          child: Icon(CupertinoIcons.multiply)),
                                    ),
                                  ],
                                ),
                                Divider(),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.02),


                                CustomDropdownButton(
                                  text: 'Apartment',
                                  items: (apt_priority_data?['apartment_list'] as List<dynamic>),
                                  selectedItem: selected_apt,
                                  hint: 'Select Apartment',
                                  onChanged: (value){
                                    selected_apt = value! ;
                                    print('selected_apt${selected_apt?['id']}');
                                  },
                                ),


                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Text("Date",
                                  style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                CustomTextField(
                                  controller: datepicker,
                                  hintText: 'Pick Date',
                                  enabled: isEnable,
                                  borderRadius: 5,
                                  bgColor: Colors.white,
                                  suffix2: GestureDetector(
                                      onTap: (){
                                        pick_date1();
                                      },
                                      child: Icon(Icons.calendar_month)),
                                ),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                Text("Time",
                                  style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                CustomTextField(
                                  controller: timepicker,
                                  hintText: 'Pick Time',
                                  enabled: isEnable,
                                  borderRadius: 5,
                                  bgColor: Colors.white,
                                  suffix2: GestureDetector(
                                      onTap: (){
                                        _selectTime();
                                      },
                                      child: Icon(Icons.access_time)),
                                ),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                CustomDropdownButton(
                                  text: 'Work Priority',
                                  items: (apt_priority_data?['priority_list'] as List<dynamic>),
                                  selectedItem: selected_priority,
                                  itemMapKey: 'title',
                                  hint: 'Select Work Priority',
                                  onChanged: (value){
                                    selected_priority = value! ;
                                    print('selected_apt${selected_priority?['id']}');
                                  },
                                ),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                CustomDropdownButton(
                                  text: 'Staff',
                                  items: (cleaner_list as List<dynamic>),
                                  selectedItem: selected_cleaner,
                                  hint: 'Select Staff Name',
                                  onChanged: (value){
                                    selected_cleaner = value! ;
                                    print('cleaner_list${selected_cleaner?['id']}');
                                  },
                                ),

                                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                                RoundEdgedButton(
                                  text: 'Add Task',
                                  color: MyColors.primaryColor,
                                  isLoad: loadAddTask,
                                  loaderColor: MyColors.whiteColor,
                                  borderRadius: 10,
                                  onTap: () async{
                                    ///supervisor add task validation & api integration
                                    dialog_setState(() {loadAddTask = true;});

                                    if(selected_apt?['id'].toString() == '' || datepicker.text == '' || timepicker.text == '' ||
                                        selected_cleaner?['id'].toString() == '' || selected_priority?['id'].toString() == ''){
                                      toast('All fields are required.');
                                    }else{
                                      Map<String, dynamic> request = {
                                        'apartment_id' : selected_apt?['id'],
                                        'date' : DateFormat("yyyy-MM-dd").format(selectedDate1),
                                        'time' : timepicker.text,
                                        'task_type' : '5', /// for cleaner always 5
                                        'staff_id' : selected_cleaner?['id'],
                                        'assinged_by' : userDataNotifier.value?.id,
                                        'work_priority' : selected_priority?['id']
                                      };


                                      final Response = await Webservices.postData(apiUrl: ApiUrls.supervisor_add_task, request: request);

                                      dialog_setState(() {loadAddTask = false;});

                                      if(Response['status'].toString() == "1"){
                                        Navigator.pop(context);

                                        taskList();

                                        toast('Task has been added successfully');
                                      }else{
                                        Navigator.pop(context);
                                        toast(Response['message']);
                                      }
                                    }
                                  },
                                ),


                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              );
            },
          );
        },
        backgroundColor: MyColors.primaryColor,
        child: const Icon(Icons.add),
      ),

      body:
      load==true || deleteTask==true || loadAddTask==true ? Center(child: CupertinoActivityIndicator(radius: 20, color: MyColors.primaryColor,),):
      task_list_data.length == 0 ? Center(child: Lottie.asset(MyImages.no_data)) :

      ListView.builder(
          itemCount: task_list_data.length,
          itemBuilder: (context, index){
        return GestureDetector(
          onTap: () async{
          await push(context: context, screen: TaskDetailsScreen(task_id: task_list_data[index]['id'], ));
          taskList();
          },
          child: Padding(
            padding: EdgeInsets.only(left: size_width*0.04, right: size_width*0.04,  top: size_height*0.02, bottom: index==task_list_data.length-1 ? size_height*0.1: 0 ),
            child: Material(
              borderRadius: BorderRadius.circular(10),
              elevation: 3,
              child: Container(
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                  color:
                  task_list_data[index]['color_status'].toString() == "1" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance )? MyColors.arrivalColor :
                  task_list_data[index]['color_status'].toString() == "2" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance ) ? MyColors.inHouseColor :
                  task_list_data[index]['color_status'].toString() == "3" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance ) ? MyColors.black54Color.withOpacity(0.2) :
                  task_list_data[index]['color_status'].toString() == "4" && (userDataNotifier.value?.userType == UserType.Supervisor || userDataNotifier.value?.userType == UserType.Logistics || userDataNotifier.value?.userType == UserType.Maintenance ) ? MyColors.checkOutColor.withOpacity(0.2) :
                  MyColors.whiteColor,
                ),
                child:


                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: size_width*0.04,right: size_width*0.04, top: size_height*0.02),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          task_list_data[index]['apartment']['image'].length != 0 ?
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(radius: 5, color: MyColors.primaryColor,),
                                  imageUrl: '${task_list_data[index]['apartment']['image']}',
                                  fit: BoxFit.cover,
                                  width:  size_width*0.24,
                                  height:   size_width*0.24,
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 5,
                                child: Container(
                                  width: 34,
                                  height: 16,
                                  decoration: BoxDecoration(
                                      color: Color(0xff000000).withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Image.asset(
                                        MyImages.gallery,
                                        height: 8,
                                        width: 9,
                                      ),
                                      ParagraphText(
                                        '${task_list_data[index]['apartment']['image'].length??"0"}',
                                        color: Colors.white,
                                        fontSize: 10,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: -5,
                                  left: 5,
                                  child: RoundEdgedButton(
                                text: '${task_list_data[index]['workStatus']}',
                                textColor: task_list_data[index]['workStatus'] == 'NOT STARTED'
                                    ? Colors.black
                                    : Colors.white,
                                height:  18,
                                width:  68,
                                verticalPadding: 0,
                                fontSize:  8,
                                fontWeight: FontWeight.w600,
                                color: task_list_data[index]['workStatus'] == 'IN PROGRESS'
                                    ? Color(0xffF9C50F)
                                    : task_list_data[index]['workStatus'] == 'COMPLETED'
                                    ? Color(0xff14A300)
                                    : task_list_data[index]['workStatus'] == 'CHECKED'
                                    ? Color(0xffB009FF)
                                    : Colors.grey,
                              ))
                            ],
                          ):
                          Container(
                            width:  size_width*0.24,
                            height:   size_width*0.24,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: MyColors.greyColor)
                            ),
                            child: Icon(Icons.camera_alt, color:  MyColors.whiteColor, size: 30,),
                          ),

                          SizedBox(width: size_width*0.03,),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    ParagraphText(
                                      '${task_list_data[index]['apartment']['name']}',
                                      color: MyColors.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                    ParagraphText(
                                      '#${task_list_data[index]['apartment']['apartment_no']}',
                                      color: MyColors.blackColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ],
                                ),

                                SizedBox(height: size_height*0.005,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.location_on_rounded,
                                      color: Color(0xffB49877),
                                      size: 12,
                                    ),
                                    hSizedBox05,
                                    SizedBox(
                                      width: size_width/1.9,
                                      child: Wrap(
                                        children: [
                                          ParagraphText(
                                            '${task_list_data[index]['apartment']['location']}',
                                            color: MyColors.primaryColor,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: size_height*0.005,),
                                Container(
                                 color: Color(0xffD9D9D9),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_month,
                                        color: Color(0xffB49877),
                                        size: 12,
                                      ),
                                      hSizedBox05,
                                      ParagraphText(
                                        '${DateFormat('dd-MMM-yyyy').format(DateTime.parse(task_list_data[index]['date']))}  ${task_list_data[index]['time']}',
                                        color: MyColors.blackColor,
                                        fontSize: 12,
                                      ),

                                    ],
                                  ),
                                ),

                                SizedBox(height: size_height*0.005,),
                                Row(
                                  children: [
                                    Icon(Icons.priority_high,color: Color(0xffB49877),size:12,),
                                    hSizedBox05,
                                    ParagraphText(
                                      '${task_list_data[index]['work_priority']['title']}',
                                      color: Color(0xffFFCA0D),
                                      fontSize: 12,
                                    ),
                                    hSizedBox05,
                                    ParagraphText(
                                      '(Priority)',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),

                                SizedBox(height: size_height*0.005,),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.cleaning_services_rounded,
                                      color: Color(0xffB49877),
                                      size: 12,
                                    ),
                                    hSizedBox05,
                                    ParagraphText(
                                      '${task_list_data[index]['admin_checklist']}',
                                      color: MyColors.blackColor,
                                      fontSize: 12,
                                    ),
                                  ],
                                ),



                                SizedBox(height: size_height*0.005,),
                                Row(
                                  children: [
                                    Icon(Icons.person,color: Color(0xffB49877),size:12,),
                                    hSizedBox05,
                                    ParagraphText(
                                      '${task_list_data[index]['staff_data']['name']}',
                                      color: MyColors.blackColor,
                                      fontSize: 12,
                                    ),
                                    hSizedBox05,
                                    ParagraphText(
                                      '(Cleaner)',
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),

                                  ],
                                ),


                              ],
                            ),
                          ),
                        ],
                      ),
                    ),


                    Container(
                      decoration: BoxDecoration(
                        color: MyColors.primaryColor,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10))
                      ),
                      child:  Padding(
                        padding: EdgeInsets.only(left: size_width*0.04, ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ParagraphText(
                              'Task #${task_list_data[index]['id']}',
                              color: MyColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            ParagraphText(
                              'Assign By: ${task_list_data[index]['supervisior']['name']}',
                              color: MyColors.whiteColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),

                            PopupMenuButton(
                              color: MyColors.whiteColor,
                              iconSize: size_height*0.03,
                              position: PopupMenuPosition.under,
                              padding: EdgeInsets.zero,
                              constraints:  BoxConstraints.expand(width: size_width/3, height: size_height/9.5),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              onSelected: (value) async{
                                ///Delete task
                                if (value == Options.Delete.index){

                                  showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context)
                                  {
                                   return Padding(
                                     padding: EdgeInsets.only(
                                       left: size_width * 0.085,
                                       right: size_width * 0.085,
                                     ),
                                     child: AlertDialog(
                                        backgroundColor: MyColors.scafoldcolor,
                                        alignment: Alignment.center,
                                        actionsAlignment: MainAxisAlignment.center,
                                        insetPadding: EdgeInsets.zero,
                                        elevation: 0.0,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                20)),
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [

                                              SizedBox(height: size_height * 0.03,),
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
                                              SizedBox(height: size_height * 0.01,),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  RoundEdgedButton(
                                                    width: size_width/3,
                                                    text: 'Delete',
                                                    color: MyColors.primaryColor,
                                                    onTap: () async {

                                                      Navigator.pop(context);

                                                      /// Delete task api

                                                      setState(() {
                                                        deleteTask=true;
                                                      });
                                                      Map<String, dynamic> request = {
                                                        'task_id': task_list_data[index]['id'],
                                                        'supervisior_id': userDataNotifier.value?.id,
                                                      };

                                                      final response = await Webservices.postData(apiUrl: ApiUrls.delete_supervisior_task, request: request);

                                                      setState(() {
                                                        deleteTask=false;
                                                      });

                                                      if (response['status'].toString() == '1') {
                                                        toast('Task has been deleted successfully');
                                                        taskList();
                                                      } else {
                                                        toast(response['message']);
                                                      }
                                                    },
                                                  ),
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
                                  });
                                }
                              },
                              itemBuilder: (BuildContext context) =>  [
                                _buildPopupMenuItem('Edit', Options.Edit.index, ),
                                _buildPopupMenuItem('Delete', Options.Delete.index, ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
