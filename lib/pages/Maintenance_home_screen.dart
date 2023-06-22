import 'dart:developer';
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/pages/taskdetailsscreen.dart';
import 'package:cleanerapp/widgets/round_edged_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../constants/global_data.dart';
import '../constants/images_url.dart';
import '../constants/sized_box.dart';
import '../constants/toast.dart';
import '../functions/navigation_functions.dart';
import '../services/api_urls.dart';
import '../services/onesignal.dart';
import '../services/webservices.dart';
import '../widgets/CustomTexts.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/drawer.dart';
import '../widgets/dropdown.dart';
import '../widgets/workcard.dart';
import 'notification.dart';

class Maintenance_home_screen extends StatefulWidget {
  const Maintenance_home_screen({required Key key,}) : super(key: key);

  @override
  State<Maintenance_home_screen> createState() => Maintenance_home_screenState();
}

class Maintenance_home_screenState extends State<Maintenance_home_screen> with SingleTickerProviderStateMixin {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showCartBadge=false;
  ValueNotifier<String?> badge_count = ValueNotifier('');
  bool maintenanceLoad =false;
  bool cleanerLoad =false;
  bool isCleaner_task =false;
  bool assign_load =false;
  bool isReported_task =true;
  var formatted_date=DateFormat("yyyy-MM-dd").format(DateTime.now());
  List maintenance_task_list_data=[];
  List cleaners_task_list_data=[];
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
  TextEditingController search = TextEditingController();
  String? selectedVal;
  late TabController tabController;
  Map? apt_priority_data;
  List all_cleaner_list = [];
  bool load=false;
  bool isLoad=false;

  interval_api() async{
    Map<String,dynamic> request ={
      'user_id' : userDataNotifier.value?.id
    };

    final res = await Webservices.postData(apiUrl: ApiUrls.interval_api, request: request);
    log("interval_api_response=============$res");
    badge_count.value = res['data']['un_read_count'];

    Future.delayed(Duration(seconds: 5),(){
      interval_api();
    });
  }

  maintenance_taskList() async{
    setNotificationHandler(context);

    setState(() {
      maintenanceLoad =true;
      isCleaner_task =false;
      isReported_task =true;
    });


    Map<String, dynamic> request =  {
      'date' : formatted_date,
    };

    final Response= await Webservices.postData(apiUrl: ApiUrls.maintenance_task_list, request: request);

    if(Response.length>0) {
      maintenance_task_list_data = Response['data'];
      log("maintenace_task_list===${maintenance_task_list_data}");

    }else{
      maintenance_task_list_data=[];
    }

    ///--------------unread notification------------------

    Map<String, dynamic> notiReq = {
      'user_id' : userDataNotifier.value?.id
    };
    final notiRes= await Webservices.postData(apiUrl: ApiUrls.GetUnreadNotification, request: notiReq);
    log("Total unread notification: $notiRes");//unreadNotification

    badge_count.value = notiRes['unreadNotification'];
    _showCartBadge = badge_count.value.toString() != "" ;



    ///apartment & priority list------------------

    final Response1= await Webservices.getMap(ApiUrls.apartment_priority_list);

    if(Response.length>0){
      apt_priority_data = Response1 ;
      apt_priority_data!['apartment_list'].add({'id':'all','name':'All'});
      log("apartment_&_priority_list_response---${apt_priority_data}");
    }

    final cleanerRes = await Webservices.getList(ApiUrls.all_cleaner_list);
    if (cleanerRes.length > 0) {
      all_cleaner_list = cleanerRes;
      all_cleaner_list!.add({'id':'all','name':'All'});
      log("all_Cleaner_list: $all_cleaner_list");
    }

    ///----------------------------------------------

    interval_api();

    setState(() {maintenanceLoad =false;});
  }

  cleanerListApi() async{
    ///calling api for all cleaner list

    Map<String, dynamic> request =  {
      'type' : "1",
      'date' : formatted_date,
    };

    setState(() {
      cleanerLoad = true;
      isCleaner_task = true;
      isReported_task =false;
    });

    final Response= await Webservices.postData(apiUrl: ApiUrls.maintenance_task_list+"?M=000", request: request);

    if(Response.length>0) {
      cleaners_task_list_data = Response['cleaner_task'];
      log("cleaners_task_list_data===${cleaners_task_list_data}");

    }else{
      cleaners_task_list_data=[];
    }

    setState(() {
      cleanerLoad = false;
    });
  }

  assigned_task_list() async{

    setState(() {
      assign_load = true;
      isReported_task = false;
    });

    Map<String, dynamic> request =  {
      'date' : formatted_date,
      'user_id' : userDataNotifier.value?.id,
    };

    final Response= await Webservices.postData(apiUrl: ApiUrls.admin_maintenance_task, request: request);

    setState(() {
      assign_load = false;
    });

    maintenance_task_list_data=[];
    if(Response.length>0) {
      maintenance_task_list_data = Response['data'];
      log("assigned_task_list===${maintenance_task_list_data}");

    }else{
      maintenance_task_list_data=[];
    }
  }

  DateTime selectedDate = DateTime.now();
  String filterSelectedDate = '';
  bool isdateselected= false;
  ValueNotifier<int> buildingIndexNotifier = ValueNotifier(0);
  ValueNotifier<int> cleanerIndexNotifier = ValueNotifier(0);

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

  @override
  void initState() {

    maintenance_taskList();
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(_handleTabChange);
  }

  void _handleTabChange() {
    if (tabController.indexIsChanging) {
      switch (tabController.index) {
        case 0:
          maintenance_taskList();
          print('First tab tapped');
          break;
        case 1:
          assigned_task_list();
          print('Second tab tapped');
          break;
        case 2:
          cleanerListApi();
          print('Third tab tapped');
          break;
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
            if(maintenanceLoad != true)
              GestureDetector(
                onTap: () async{
                  await push(context: context, screen: NotificationScreen());
                  maintenance_taskList();
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
        body: maintenanceLoad == true  || cleanerLoad == true || assign_load == true ? Center(child: CupertinoActivityIndicator(radius: 20, color: MyColors.primaryColor,),):
        Padding(
          padding: const EdgeInsets.symmetric(horizontal:14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSizedBox2,

              DefaultTabController(
                length: 3,
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ButtonsTabBar(
                        controller: tabController,
                        backgroundColor: MyColors.primaryColor,
                        unselectedBackgroundColor: Colors.grey[300],
                        contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        unselectedLabelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                        labelStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(text: "Reported Task"),
                          Tab(text: "Assigned Task"),
                          Tab(text: "Cleaner Task"),
                        ],
                      ),

                      ///search bar
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

                      ///task count & dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

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
                                                // Column(
                                                //   mainAxisSize: MainAxisSize.min,
                                                //   children: <Widget>[
                                                //     Container(
                                                //       child: Center(
                                                //           child:
                                                //           isdateselected==false?
                                                //           Text(
                                                //             "Date",
                                                //             style: TextStyle(
                                                //                 fontSize: 14
                                                //             ),
                                                //           ):
                                                //           ParagraphText( DateFormat("dd-MMM-yyyy").format(this.selectedDate),)
                                                //       ),
                                                //       decoration: BoxDecoration(
                                                //           color: Color(0xfff1f1f1),
                                                //           borderRadius: BorderRadius.circular(10),
                                                //           border: Border.all(color: Color(0xFFe1e1e1))
                                                //       ),
                                                //       width: MediaQuery.of(context).size.width,
                                                //       height: 30,
                                                //     ),
                                                //     vSizedBox05,
                                                //     RoundEdgedButton(text: 'Select Date',
                                                //       onTap: () async{
                                                //         await pick_date();
                                                //
                                                //         popUPsetState((){});
                                                //       },
                                                //       color: MyColors.primaryColor,
                                                //       height: 30,
                                                //       verticalPadding: 0,
                                                //       horizontalMargin: 0,
                                                //       verticalMargin: 0,
                                                //       borderRadius: 7,
                                                //     ),
                                                //   ],
                                                // ),
                                                // vSizedBox2,

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

                                                if( tabController.index == 2)
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
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
                                                  ],
                                                ),

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



                                                        if( tabController.index == 0){
                                                          setState(() {load=true;});
                                                          popUPsetState(() {isLoad=true;});
                                                          final response = await Webservices.getList(ApiUrls.maintenance_task_list+"?apartment_keyword=${apt_priority_data?['apartment_list'][buildingIndexNotifier.value]['id']}");

                                                          maintenance_task_list_data=[];


                                                          if (response.length > 0) {
                                                            maintenance_task_list_data = response;
                                                            Navigator.pop(context);
                                                            toast("Sorting done successfully");
                                                          }else{
                                                            Navigator.pop(context);
                                                            maintenance_task_list_data = [];
                                                            toast("Nothing found :( ");
                                                          }
                                                          setState(() {load=false;});
                                                          popUPsetState(() {isLoad=false;});
                                                        }
                                                        else if( tabController.index == 2){
                                                          setState(() {load=true;});
                                                          popUPsetState(() {isLoad=true;});
                                                          // final response = await Webservices.getList(ApiUrls.maintenance_task_list+"?type=1&apartment_keyword=${apt_priority_data?['apartment_list'][buildingIndexNotifier.value]['id']}");
                                                          final response = await Webservices.getList(ApiUrls.task_list+"?date=$filterSelectedDate&"
                                                              "apartment_keyword=${apt_priority_data?['apartment_list'][buildingIndexNotifier.value]['id']}&"
                                                              "cleaner_keyword=${all_cleaner_list?[cleanerIndexNotifier.value]['id']}");

                                                          cleaners_task_list_data=[];


                                                          if (response.length > 0) {
                                                            cleaners_task_list_data = response;
                                                            Navigator.pop(context);
                                                            toast("Sorting done successfully");
                                                          }else{
                                                            Navigator.pop(context);
                                                            cleaners_task_list_data = [];
                                                            toast("Nothing found :( ");
                                                          }
                                                          setState(() {load=false;});
                                                          popUPsetState(() {isLoad=false;});
                                                        }
                                                        else{

                                                          setState(() {load=true;});
                                                          popUPsetState(() {isLoad=true;});
                                                          final response = await Webservices.getList(ApiUrls.admin_maintenance_task+"?apartment_keyword=${apt_priority_data?['apartment_list'][buildingIndexNotifier.value]['id']}");

                                                          maintenance_task_list_data=[];

                                                          if (response.length > 0) {
                                                            maintenance_task_list_data = response;
                                                            Navigator.pop(context);
                                                            toast("Sorting done successfully");
                                                          }else{
                                                            Navigator.pop(context);
                                                            maintenance_task_list_data = [];
                                                            toast("Nothing found :( ");
                                                          }
                                                          setState(() {load=false;});
                                                          popUPsetState(() {isLoad=false;});
                                                        }



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

                            if(day7!=null && isReported_task == false)
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
                                  assigned_task_list();
                                  cleanerListApi();
                                },
                              ),

                        ],
                      ),

                      vSizedBox,
                      if(maintenance_task_list_data.length == 0)
                        ParagraphText(isReported_task == true ? 'No Task' :'No Task For ${selectedVal??"Today"}',fontSize: 12,)
                      else
                        ParagraphText(isReported_task == true ? 'Total ${maintenance_task_list_data.length} Tasks' : '${maintenance_task_list_data.length} Task For ${selectedVal??"Today"}',fontSize: 12,),

                      vSizedBox,

                      Expanded(
                        child: TabBarView(
                          controller: tabController,
                          children: <Widget>[
                            maintenance_task_list_data.length == 0 ? Center(child: Lottie.asset(MyImages.no_data)) : ListView.builder(
                              itemCount: maintenance_task_list_data.length,
                              itemBuilder: (context, index) {
                                print( 'checking_type===${maintenance_task_list_data[index]['work_priority'].runtimeType}',);
                                if(
                                maintenance_task_list_data[index]['apartment']['name'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['apartment']['location'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['location'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['apartment']['apartment_no'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['time'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['apartment_type']['name'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['work_priority']['title'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['title'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['assinged_by']['name'].toString().toLowerCase().contains(search.text)
                                ) {
                                  return GestureDetector(
                                    onTap: () async{

                                      await push(context: context, screen: TaskDetailsScreen(task_id: maintenance_task_list_data[index]['id'], ));
                                        maintenance_taskList();
                                    },
                                    child: WorkCard(
                                      usertype: UserType.Maintenance,
                                      onTap: () {

                                      },
                                      ListData: maintenance_task_list_data[index],
                                      isMaintenance: true,
                                      workStatus: maintenance_task_list_data[index]['status'].toString() == '2' ? 'IN PROGRESS':
                                      maintenance_task_list_data[index]['status'].toString() == '1' ? 'COMPLETED': 'NOT STARTED',
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
                            maintenance_task_list_data.length == 0 ? Center(child: Lottie.asset(MyImages.no_data)) : ListView.builder(
                              itemCount: maintenance_task_list_data.length,
                              itemBuilder: (context, index) {

                                if(
                                maintenance_task_list_data[index]['apartment']['name'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['apartment']['location'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['location'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['apartment']['apartment_no'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['time'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['apartment_type']['name'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['work_priority']['title'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['title'].toString().toLowerCase().contains(search.text) ||
                                    maintenance_task_list_data[index]['assinged_by']['name'].toString().toLowerCase().contains(search.text)
                                ) {
                                  return GestureDetector(
                                    onTap: () async{

                                      await push(context: context, screen: TaskDetailsScreen(task_id: maintenance_task_list_data[index]['id'], ));
                                      assigned_task_list();
                                    },
                                    child: WorkCard(
                                      usertype: UserType.Maintenance,
                                      onTap: () {

                                      },
                                      ListData: maintenance_task_list_data[index],
                                      isMaintenance: true,
                                      workStatus: maintenance_task_list_data[index]['status'].toString() == '2' ? 'IN PROGRESS':
                                      maintenance_task_list_data[index]['status'].toString() == '1' ? 'COMPLETED': 'NOT STARTED',
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
                            cleaners_task_list_data.length == 0 ? Center(child: Lottie.asset(MyImages.no_data)) : ListView.builder(
                              itemCount: cleaners_task_list_data.length,
                              itemBuilder: (context, index) {

                                if(
                                cleaners_task_list_data[index]['apartment']['name'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['apartment']['location'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['apartment']['apartment_no'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['time'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['admin_checklist'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['date'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['apartment_type']['name'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['staff_data']['name'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['work_priority']['title'].toString().toLowerCase().contains(search.text) ||
                                    cleaners_task_list_data[index]['assinged_by']['name'].toString().toLowerCase().contains(search.text)
                                ) {
                                  return GestureDetector(
                                    onTap: () async{

                                      await push(context: context, screen: TaskDetailsScreen(task_id: cleaners_task_list_data[index]['id'], isCleaner_task: true));
                                      cleanerListApi();
                                    },
                                    child: WorkCard(
                                      usertype: UserType.Maintenance,
                                      onTap: () {},
                                      ListData: cleaners_task_list_data[index],
                                      isMaintenance: false,
                                      workStatus: cleaners_task_list_data[index]['status'].toString() == '0' ? 'NOT STARTED':
                                      cleaners_task_list_data[index]['status'].toString() == '1' ? 'COMPLETED': 'IN PROGRESS',
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),


            ],
          ),
        ),
      ),
    );
  }
}
