import 'package:cleanerapp/constants/global_keys.dart';
import 'package:cleanerapp/pages/notification.dart';
import 'package:cleanerapp/pages/splashscreen.dart';
import 'package:cleanerapp/pages/taskdetailsscreen.dart';
import 'package:cleanerapp/services/webservices.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import '../constants/global_data.dart';
import '../functions/navigation_functions.dart';
import 'api_urls.dart';



String? onesignal_device_id;
Future<void> initOneSignal(app_id) async { //this should be called in first screen init state (example: splash screen)
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  OneSignal.shared.setAppId(app_id);

// The promptForPushNotificationsWithUserResponse function will show the iOS or Android push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });

}



setNotificationHandler(context) async{ //this should be called in after logged in first screen init state (example: tab)

  OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent event) {
    // Will be called whenever a notification is received in foreground
    // Display Notification, pass null param for not displaying the notification
    event.complete(event.notification);
    print('the notificationnnn is ${event.notification.toString()}');
  });

  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) async {
    print('the notificationnnn is ');
    print('the notificationnnn is ${result.notification.toString()}');

    /* notificationHandling(context,result.notification.additionalData);*/

    print("notificationopen--------------------------------${result.notification.additionalData?['match_id'].runtimeType}  ${result.notification.additionalData}");
    print("notification--------------------------------"+result.notification.additionalData!['match_id'].toString());

    ///use for redirection, you will get this "task" in notification api response inside other 'screen'
    if(result.notification.additionalData!['screen'].toString()=="task") {
      ///--------------mark as read noti api-----------------

      await Webservices.getData(ApiUrls.MarkAsReadNotification+"?user_id=${userDataNotifier.value?.id}");

      ///----------------------------------------------------
       push(context: MyGlobalKeys.navigatorKey.currentState!.context, screen: TaskDetailsScreen(task_id: result.notification.additionalData!['task_id'].toString(), ));
    }else{
      push(context:  MyGlobalKeys.navigatorKey.currentState!.context, screen: SplashScreen());
    }

    // Will be called whenever a notification is opened/button pressed.
  });

  OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
    // Will be called whenever the permission changes
    // (ie. user taps Allow on the permission prompt in iOS)
  });
  onesignal_device_id = await get_device_id();

  print("onesignal_device_id===================$onesignal_device_id");


  ///update device id api calling
  // var request={
  //   "user_id":userData!.userId,
  //   "device_id": onesignal_device_id.toString()
  // };
  //
  // var jsonResponse = await Webservices.postData(apiUrl: ApiUrls.update_deviceId, request: request,showSuccessMessage: false,isGetMethod: true);

  // print("jsonResponse=======================$jsonResponse");

  print("device id--------------------------------"+onesignal_device_id.toString());
  // OneSignal.shared.setSubscriptionObserver((OSSubscriptionStateChanges changes) async{
  //   print("subscription--------------------------------");
  //
  //
  //
  //   // Webservices.getData(url, data)
  //   // Will be called whenever the subscription changes
  //   // (ie. user gets registered with OneSignal and gets a user ID)
  // });

}


Future<String?> get_device_id() async {
  var deviceState = await OneSignal.shared.getDeviceState();
  if (deviceState == null || deviceState.userId == null)
    return null;
  return deviceState.userId!;
}