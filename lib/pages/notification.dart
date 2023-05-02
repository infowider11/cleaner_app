import 'dart:developer';

import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/global_data.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/constants/sized_box.dart';
import 'package:cleanerapp/constants/toast.dart';
import 'package:cleanerapp/functions/navigation_functions.dart';
import 'package:cleanerapp/pages/taskdetailsscreen.dart';
import 'package:cleanerapp/services/api_urls.dart';
import 'package:cleanerapp/services/webservices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../widgets/CustomTexts.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  bool load = false;
  Map? notification_list;


  getNotiapi() async{

    setState(() {
      load = true;
    });

    Map<String, dynamic> request = {
      'user_id' : userDataNotifier.value?.id,
    };

    final response = await Webservices.postData(apiUrl: ApiUrls.GetNotification+"?user_id=${userDataNotifier.value?.id}", request: request);
    log("notification_list_response========$response");
    notification_list = response;
    log("notification_list_length========${notification_list?['data'].length}");



    if(response['status'].toString() == '1'){
      toast('All notification fetched successfully');
    }else{
      toast(response['message'].toString());
    }

    ///--------------mark as read noti api-----------------

    final readRes = await Webservices.getData(ApiUrls.MarkAsReadNotification+"?user_id=${userDataNotifier.value?.id}");

    ///----------------------------------------------------

    setState(() {
      load = false;
    });
  }
  
  @override
  void initState() {
    getNotiapi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scafoldcolor,
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        // Image.asset(MyImages.menu,height:0,width:0,),
        title:ParagraphText('Notifications ',fontWeight: FontWeight.w500,),
        toolbarHeight: 73,


      ),
      body:
      load == true? Center(child: CupertinoActivityIndicator(radius: 20, color: MyColors.primaryColor,),):
      ListView.builder(
        itemCount: notification_list?['data'].length,
          itemBuilder: (context, index){
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,),
          child: GestureDetector(
            onTap: (){
              if(notification_list?['data'][index]['other']['task_id'].toString() != null)
              push(context: context, screen: TaskDetailsScreen(task_id: notification_list?['data'][index]['other']['task_id'].toString(),));
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Wrap(
                  // alignment: WrapAlignment.spaceBetween,
                  spacing: 10,
                  direction: Axis.horizontal,
                  children: [
                    Image.asset(MyImages.splash, height: 40,),

                    SizedBox(
                        width: MediaQuery.of(context).size.width*0.41,
                        child: ParagraphText(notification_list?['data'][index]['message'], maxline: 2, overflow: TextOverflow.ellipsis,)),

                    ParagraphText(notification_list?['data'][index]['create_date'], fontSize: 10,),
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
