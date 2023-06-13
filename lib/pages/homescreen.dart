import 'dart:developer';
import 'package:badges/badges.dart' as badges;
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/global_data.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/constants/sized_box.dart';
import 'package:cleanerapp/constants/toast.dart';
import 'package:cleanerapp/functions/navigation_functions.dart';
import 'package:cleanerapp/pages/notification.dart';
import 'package:cleanerapp/pages/taskdetailsscreen.dart';
import 'package:cleanerapp/services/onesignal.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/round_edged_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../services/api_urls.dart';
import '../services/webservices.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/drawer.dart';
import '../widgets/dropdown.dart';
import '../widgets/workcard.dart';

class HomeScreen extends StatefulWidget {
  final UserType userType;
  final String?  title;
  const HomeScreen({required Key key, required this.userType, required this.title}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();
  bool isdateselected= false;
  bool load=false;
  bool isLoad=false;
  bool load2=false;
  bool loadAddTask=false;
  TextEditingController search=TextEditingController();
  DateTime now = DateTime.now();
  var formatted_date=DateFormat("yyyy-MM-dd").format(DateTime.now());
  List task_list_data=[];
  var day1= DateFormat("dd-MMM-yyyy").format(DateTime.now())??'';
  var day2= DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1))??'';
  var day3= DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 2))??'';
  var day4= DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 3))??'';
  var day5= DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 4))??'';
  var day6 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 5))??'';
  var day7 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 6))??'';
  var day8 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1))??'';
  var day9 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2))??'';
  var day10 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 3))??'';
  var day11 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 4))??'';
  var day12 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 5))??'';
  var day13 = DateFormat("dd-MMM-yyyy").format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 6))??'';
  String? selectedVal;
    ValueNotifier<String?> badge_count = ValueNotifier('');
    String filterSelectedDate = '';

  pick_date(){
    return showDatePicker(
        context: context,
        initialDate: selectedDate,
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
          value != null ? value.year : selectedDate.year,
          value != null ? value.month : selectedDate.month,
          value != null ? value.day : selectedDate.day,
          selectedDate.hour,
          selectedDate.minute);
      setState(() {
        selectedDate = newDate;
        filterSelectedDate=  DateFormat("yyyy-MM-dd").format(selectedDate);
        isdateselected=true;
      });

    });
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  Map? selected_apt;
  Map? selected_priority;
  Map? apt_priority_data;
  Map? selected_cleaner;
  List cleaner_list = [];
  List all_cleaner_list = [];
  bool _showCartBadge=false;
  bool maintenanceLoad=false;
  ValueNotifier<int> buildingIndexNotifier = ValueNotifier(0);
  ValueNotifier<int> cleanerIndexNotifier = ValueNotifier(0);


  Future<void> taskList() async {
    setNotificationHandler(context);


    setState(() {load=true;});

    if(widget.userType == UserType.Supervisor || widget.userType == UserType.Logistics){
      final cleanerRes = await Webservices.getList(ApiUrls.all_cleaner_list);
      if (cleanerRes.length > 0) {
        all_cleaner_list = cleanerRes;
        log("all_Cleaner_list: $all_cleaner_list");
      }
    }

    final Response= await Webservices.getList(ApiUrls.task_list+"?date=$formatted_date&user_id=${userDataNotifier.value?.id}&type=1");



    if(Response.length>0){
      task_list_data = Response ;
      log("task_list response---${task_list_data[0]['id']}");


      for(int i=0 ; i<task_list_data.length;i++){
        var check_array = task_list_data[i]['apartment']['check_list'].split(',');
        if(check_array.contains == 'maintenance'){
          task_list_data[i]['isMaintanence']=true;
        }
        else{
          task_list_data[i]['isMaintanence']=false;

        }
      }
      setState(() {});
    }
    else{
      task_list_data=[];
    }

    ///--------------unread notification------------------

    Map<String, dynamic> notiReq = {
      'user_id' : userDataNotifier.value?.id
    };
    print('user_id-----${userDataNotifier.value?.id}');
    final notiRes= await Webservices.postData(apiUrl: ApiUrls.GetUnreadNotification, request: notiReq);
    log("Total unread notification: $notiRes");//unreadNotification

    badge_count.value = notiRes['unreadNotification'];
    _showCartBadge = badge_count.value.toString() != "" ;

    ///----------------------------------------------

    if(widget.userType == UserType.Supervisor || widget.userType == UserType.Logistics)
    supervisorDropdownData();

    setState(() {load=false;});

    interval_api();
  }

  supervisorDropdownData() async{
    ///apartment & priority list------------------
    
    final Response= await Webservices.getMap(ApiUrls.apartment_priority_list);
    
    if(Response.length>0){
      apt_priority_data = Response ;
      log("apartment_&_priority_list_response---${apt_priority_data}");
    }
    
    ///staff list---------------------------------


      final staffRes = await Webservices.getList(ApiUrls.supervisior_cleaner_list + "?supervisior_id=${userDataNotifier.value?.id}");

      if (Response.length > 0) {
        cleaner_list = staffRes;
        log("Cleaner_list: $cleaner_list");
      }



  }

  interval_api() async{

    Map<String,dynamic> request ={
      'user_id' : userDataNotifier.value?.id
    };

    final res = await Webservices.postData(apiUrl: ApiUrls.interval_api, request: request);
    log("interval_api_response=============$res");
    log("interval_api_response=============${res['data']['un_read_count']}");
    badge_count.value = res['data']['un_read_count'];
    print("badge_count${badge_count.value}");

    Future.delayed(Duration(seconds: 25),(){
      interval_api();
    });
  }




  @override
  void initState() {
    if(widget.userType != UserType.Maintenance)
      taskList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(
            drawer: get_drawer(context),
            key: scaffoldKey,
          backgroundColor: Color(0xffF5F5F5),
          appBar: AppBar(
            backgroundColor: MyColors.primaryColor,
            leading:GestureDetector(
              onTap: (){
                scaffoldKey.currentState?.openDrawer();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical:15,horizontal:18),
                child: Image.asset
                  (MyImages.menu,),
              ),
            ),
            // Image.asset(MyImages.menu,height:0,width:0,),
            // title:ParagraphText("${userDataNotifier.value?.name}", fontWeight: FontWeight.w500,fontSize: 18,),
            title:ValueListenableBuilder(
                valueListenable: userDataNotifier,
                builder: (context, userData, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child:ParagraphText("${userData!.name}", fontWeight: FontWeight.w500,fontSize: 18,),

                  );
                }
            ),
            toolbarHeight: 73,
            titleSpacing: 0,
            actions: [
              if( load!=true || load2!=true || loadAddTask != true)
              GestureDetector(
                onTap: () async{
                 await push(context: context, screen: NotificationScreen());
                 taskList();
                },
                child: ValueListenableBuilder(
                  valueListenable: badge_count,
                    builder: (context, notiCount, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                        child: badges.Badge(
                          position: badges.BadgePosition.topEnd(top: -15),
                          badgeAnimation: badges.BadgeAnimation.scale(
                            animationDuration: Duration(seconds: 1),
                            colorChangeAnimationDuration: Duration(seconds: 1),
                            loopAnimation: false,
                            curve: Curves.fastOutSlowIn,
                            colorChangeAnimationCurve: Curves.easeInCubic,
                          ),
                          showBadge: _showCartBadge,
                          badgeStyle: badges.BadgeStyle(
                            badgeColor: Colors.red,
                          ),
                          badgeContent: Text(
                            badge_count.value.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                          child: Image.asset
                            (MyImages.Notification, height: 20, width: 17,),
                        ),//badge_count.value
                      );
                    }
                ),
              ),

            ],

          ),
            body:
            load==true || load2==true || loadAddTask == true || maintenanceLoad == true? Center(child: CupertinoActivityIndicator(radius: 20, color: MyColors.primaryColor,),):
            Padding(
            padding: const EdgeInsets.symmetric(horizontal:14),
            child: Column(
              children: [
                vSizedBox2,
                CustomTextField(
                  preffix: Icon(Icons.search_sharp,color: Color(0xff000000).withOpacity(0.4),),
                  controller: search,
                  hintcolor: Color(0xff000000).withOpacity(0.4),
                  textColor: Color(0xff000000).withOpacity(0.4),
                  hintText: 'Search',
                  bgColor:Colors.white,
                  borderRadius: 8,
                  onChanged: (val){
                    setState(() {});
                  },
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(task_list_data.length == 0)
                      ParagraphText('No Task For ${selectedVal??"Today"}',fontSize: 12,)
                    else
                    ParagraphText('${task_list_data.length} Task For ${selectedVal??"Today"}',fontSize: 12,),


                      if(widget.userType==UserType.Cleaners || widget.userType==UserType.Maintenance || widget.userType==UserType.Secratary)
                      if(day7!=null)
                        DropDown(
                      items: [day13, day12, day11, day10, day9, day8, day1,day2, day3, day4, day5, day6, day7],
                      label: 'Select Date',
                      selectedValue: selectedVal,
                      width: MediaQuery.of(context).size.width/3,
                      dropdownwidth: MediaQuery.of(context).size.width/3,
                      onChange: (val) async{
                        setState(() {
                          selectedVal = val;
                          formatted_date = selectedVal!;
                        });
                        ///calling api here
                        taskList();
                        },
                    ),

                    if(widget.userType==UserType.Supervisor|| widget.userType==UserType.Logistics )
                      PopupMenuButton(
                        child:  Container(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            child:ParagraphText('Sort By',color: Colors.black,)
                        ),
                        itemBuilder: (context) {
                          return List.generate(1, (index) {
                            return PopupMenuItem(
                              child: StatefulBuilder(
                                  builder: (BuildContext context, StateSetter popUPsetState){
                                    // ValueNotifier<int> buildingIndexNotifier = ValueNotifier(0);
                                    // ValueNotifier<int> cleanerIndexNotifier = ValueNotifier(0);
                                    return GestureDetector(
                                      onTap: (){
                                        print('object$filterSelectedDate');
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                  child: Center(
                                                      child:
                                                      isdateselected==false?
                                                      Text(
                                                        "Date",
                                                        style: TextStyle(
                                                            fontSize: 14
                                                        ),
                                                      ):
                                                      ParagraphText( DateFormat("dd-MMM-yyyy").format(this.selectedDate),)
                                                  ),
                                                  decoration: BoxDecoration(
                                                      color: Color(0xfff1f1f1),
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Color(0xFFe1e1e1))
                                                  ),
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 30,
                                                ),
                                                vSizedBox05,
                                                RoundEdgedButton(text: 'Select Date',
                                                  onTap: () async{
                                                    await pick_date();

                                                    popUPsetState((){});
                                                  },
                                                  color: MyColors.primaryColor,
                                                  height: 30,
                                                  verticalPadding: 0,
                                                  horizontalMargin: 0,
                                                  verticalMargin: 0,
                                                  borderRadius: 7,
                                                ),
                                              ],
                                            ),
                                            vSizedBox2,

                                            Text('Building',style: TextStyle(fontSize:20,fontFamily: 'OpenSansSemiBold'),),
                                            vSizedBox,
                                            ValueListenableBuilder(
                                              valueListenable: buildingIndexNotifier,
                                              builder: (context, selectedIndex, child) {
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    for(int i=0;i<apt_priority_data?['apartment_list'].length;i++ )
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            child: Radio<int>(
                                                              value: i,
                                                              groupValue: buildingIndexNotifier.value,
                                                              activeColor: MyColors.primaryColor,
                                                              onChanged: (val){
                                                                buildingIndexNotifier.value = i;
                                                                print("building ${apt_priority_data?['apartment_list'][i]['name']} & id is "
                                                                    "${apt_priority_data?['apartment_list'][buildingIndexNotifier.value]['id']}");
                                                            },

                                                            ),
                                                          ),
                                                          hSizedBox,
                                                          Text('${apt_priority_data?['apartment_list'][i]['name']}',style: TextStyle(fontSize:14,fontFamily: 'OpenSansRegular'),),
                                                        ],
                                                      ),
                                                  ],
                                                );
                                              }
                                            ),
                                            vSizedBox2,
                                            Text('Cleaners',style: TextStyle(fontSize: 20,fontFamily: 'OpenSansSemiBold'),),
                                            vSizedBox,
                                            ValueListenableBuilder(
                                              valueListenable: cleanerIndexNotifier,
                                              builder: (context, cleanerIndex, child){
                                                return Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [

                                                    for(int i=0;i<all_cleaner_list.length;i++ )
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 30,
                                                            child: Radio<int>(
                                                              value: i,
                                                              groupValue: cleanerIndexNotifier.value,
                                                              activeColor: MyColors.primaryColor,
                                                              onChanged: (val){
                                                                cleanerIndexNotifier.value = i;
                                                                print("cleaner ${all_cleaner_list?[i]['name']} & id is "
                                                                    "${all_cleaner_list?[cleanerIndexNotifier.value]['id']}");
                                                              },

                                                            ),
                                                          ),
                                                          hSizedBox,
                                                          Text('${all_cleaner_list?[i]['name']}',style: TextStyle(fontSize:14,fontFamily: 'OpenSansRegular'),),
                                                        ],
                                                      )
                                                  ],
                                                );
                                              },
                                            ),
                                            vSizedBox2,
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                GestureDetector(
                                                  onTap: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: MyColors.primaryColor
                                                    ),
                                                    child: Text('Cancle',style: TextStyle(fontSize:14,fontFamily: 'OpenSansRegular',color: Color(0xffffffff)),),

                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () async{
                                                    ///here we are calling sorting api

                                                    setState(() {load=true;});
                                                    popUPsetState(() {isLoad=true;});
                                                    final response = await Webservices.getList(ApiUrls.task_list+"?date=$filterSelectedDate&"
                                                        "apartment_keyword=${apt_priority_data?['apartment_list'][buildingIndexNotifier.value]['id']}&"
                                                          "cleaner_keyword=${all_cleaner_list?[cleanerIndexNotifier.value]['id']}");

                                                    task_list_data = [];

                                                    if (response.length > 0) {
                                                      task_list_data = response;
                                                      Navigator.pop(context);
                                                      toast("Sorting done successfully");
                                                    }else{
                                                      Navigator.pop(context);
                                                      task_list_data = [];
                                                      toast("Nothing found :( ");
                                                    }
                                                    setState(() {load=false;});
                                                    popUPsetState(() {isLoad=false;});
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal:14,vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: MyColors.primaryColor
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Text('Apply',style: TextStyle(fontSize:14,fontFamily: 'OpenSansRegular',color: Color(0xffffffff)),),
                                                        if(isLoad==true)
                                                          Row(
                                                            children: [
                                                              SizedBox(width: MediaQuery.of(context).size.width*0.03),
                                                              CupertinoActivityIndicator(radius: 8, color:MyColors.whiteColor,)
                                                            ],
                                                          )
                                                      ],
                                                    ),

                                                  ),
                                                ),

                                              ],
                                            )

                                          ],
                                        ),
                                      ),
                                    );
                                  }
                              ),
                            );
                          });
                        },
                      ),
                  ],
                ),


                task_list_data.length == 0 ? Expanded(child: Center(child: Lottie.asset(MyImages.no_data))) :
                Expanded(
                  child: ListView.builder(
                    itemCount: task_list_data.length,
                    itemBuilder: (context, index) {

                    if(
                    task_list_data[index]['apartment']['name'].toString().toLowerCase().contains(search.text) ||
                    task_list_data[index]['apartment']['location'].toString().toLowerCase().contains(search.text) ||
                    task_list_data[index]['apartment']['check_list'].toString().toLowerCase().contains(search.text) ||
                    task_list_data[index]['apartment']['apartment_no'].toString().toLowerCase().contains(search.text) ||
                    task_list_data[index]['time'].toString().toLowerCase().contains(search.text) ||
                    task_list_data[index]['apartment_type']['name'].toString().toLowerCase().contains(search.text) ||
                    task_list_data[index]['work_priority']['title'].toString().toLowerCase().contains(search.text) ||
                    task_list_data[index]['assinged_by']['name'].toString().toLowerCase().contains(search.text)

                    ) {
                      return GestureDetector(
                        onTap: () async{
                          print('abcd');
                         await push(context: context, screen: TaskDetailsScreen(task_id: task_list_data[index]['id'], ));
                         taskList();
                        },
                        child: WorkCard(
                          usertype: widget.userType,
                          onTap: () {

                          },
                          ListData: task_list_data[index],
                          isMaintenance: userDataNotifier.value?.userType == UserType.Maintenance,
                          workStatus: task_list_data[index]['status'].toString() == '0' ? 'NOT STARTED':
                          task_list_data[index]['status'].toString() == '1' ? 'COMPLETED': 'IN PROGRESS',
                          mark_as_supervisor_Tap:  () async{
                            if( task_list_data[index]['supervisior_task_status'].toString() == "1"){
                              toast('You have already supervised this task.');
                            }
                            else {
                              // if(task_list_data[index]['status'].toString() == "1" ){

                              ///checked by supervisor api
                              Map<String,dynamic> request={
                                'task_id': task_list_data[index]['id'],
                                'check_status': "1",
                              };

                              setState(() {
                                load2=true;
                              });
                              final Response= await Webservices.postData(apiUrl: ApiUrls.supervisior_check_task , request: request, showErrorMessage: false, showSuccessMessage: false);
                              log("checked by supervisor api response---$Response");

                              setState(() {
                                load2=false;
                              });

                              if(Response['status'].toString() =="1"){
                                toast("Task has been supervised");
                                taskList();
                              }else{
                                toast("${Response['message']}");
                              }
                            }
                            // else{
                            //   toast('This task has not been completed yet.');
                            // }


                          },
                        ),
                      );
                    }
                    else{
                      return Container(
                        height: 500,
                        child: Center(child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('No Task found :(', style: TextStyle(fontSize: 20, color: MyColors.primaryColor, fontWeight: FontWeight.w900, ),),
                            // Image.asset(MyImages.sad_emoji, height: 50,)
                          ],
                        ),),
                      );
                    }
                    },
                  ),
                ),
              ],
            ),
          ),

            floatingActionButton: widget.userType != UserType.Supervisor ? Container() :
            FloatingActionButton(
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
                                      borderRadius: 10,
                                      onTap: () async{
                                        ///supervisor add task validation & api integration

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

                                          setState(() {loadAddTask = true;});

                                          final Response = await Webservices.postData(apiUrl: ApiUrls.supervisor_add_task, request: request);

                                          setState(() {loadAddTask = false;});

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
        ),
      ),
    );
  }
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
}
