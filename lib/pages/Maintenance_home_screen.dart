import 'dart:developer';
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

class Maintenance_home_screenState extends State<Maintenance_home_screen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showCartBadge=false;
  ValueNotifier<String?> badge_count = ValueNotifier('');
  bool maintenanceLoad =false;
  bool cleanerLoad =false;
  bool isCleaner_task =false;
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

    ///----------------------------------------------

    interval_api();

    setState(() {maintenanceLoad =false;});
  }

  cleanerListApi() async{
    ///calling api for all cleaner list

    Map<String, dynamic> request =  {
      'type' : "1",
    };

    setState(() {
      cleanerLoad = true;
      isCleaner_task = true;
    });

    final Response= await Webservices.postData(apiUrl: ApiUrls.maintenance_task_list, request: request);

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

  @override
  void initState() {
    maintenance_taskList();
    super.initState();
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
        body: maintenanceLoad == true  || cleanerLoad == true ? Center(child: CupertinoActivityIndicator(radius: 20, color: MyColors.primaryColor,),):
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
                  if(maintenance_task_list_data.length == 0)
                    ParagraphText('No Task For ${selectedVal??"Today"}',fontSize: 12,)
                  else
                    ParagraphText('${maintenance_task_list_data.length} Task For ${selectedVal??"Today"}',fontSize: 12,),


                    RoundEdgedButton(
                      text: 'All Cleaner List',
                      fontSize: 11,
                      width: 110,
                      height: 27,
                      borderRadius: 8,
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.w700,
                      onTap: () async{
                        cleanerListApi();
                      },
                    ),


                    if(day7!=null)
                      DropDown(
                        items: [day13, day12, day11, day10, day9, day8, day1,day2, day3, day4, day5, day6, day7],
                        label: 'Select Date',
                        selectedValue: selectedVal,
                        width: 120,
                        onChange: (val) async{
                          setState(() {

                            selectedVal = val;
                            formatted_date = selectedVal!;
                          });
                          ///calling api here
                          maintenance_taskList();
                        },
                      ),

                ],
              ),

              if(isCleaner_task != true)
              maintenance_task_list_data.length == 0 ? Expanded(child: Center(child: Lottie.asset(MyImages.no_data))) :
              Expanded(
                child: ListView.builder(
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
                          maintenance_taskList();
                        },
                        child: WorkCard(
                          usertype: UserType.Maintenance,
                          onTap: () {

                          },
                          ListData: maintenance_task_list_data[index],
                          isMaintenance: true,
                          workStatus: maintenance_task_list_data[index]['status'].toString() == '0' ? 'NOT STARTED':
                          maintenance_task_list_data[index]['status'].toString() == '1' ? 'COMPLETED': 'IN PROGRESS',
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

              if(isCleaner_task == true)
              cleaners_task_list_data.length == 0 ? Expanded(child: Center(child: Lottie.asset(MyImages.no_data))) :
              Expanded(
                child: ListView.builder(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
