import 'dart:convert' as convert;
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../widgets/showSnackbar.dart';
import 'api_urls.dart';

class Webservices {
  static Future<http.Response> getData(String url) async {
    http.Response response =
    http.Response('{"message":"failure","status":0}', 404);
    log('called $url');
    try {
      response = await http.get(
        Uri.parse(url),
      );
      if(response.statusCode!=200){
        print('The response status for url $url is ${response.statusCode}');
      }
      log(response.body);
    } catch (e) {
      // showSnackbar(context, text)
      log('Error in $url : ------ $e');
    }
    return response;
  }

  static Future<Map<String, dynamic>> postData(
      {required String apiUrl,
        required Map<String, dynamic> request,
        bool showSuccessMessage  = false, bool isGetMethod = false, bool showErrorMessage = true}) async {
    http.Response response =
    http.Response('{"message":"failure","status":0}', 404);
    try {
      log('the requesst for $apiUrl is $request');
      String tempGetRequest = '?';
      request.forEach((key, value) {
        tempGetRequest +=key+'=' + value + '&';

      });
      tempGetRequest = tempGetRequest.substring(0,tempGetRequest.length-1);
      print('the url issss $apiUrl$tempGetRequest');
      late http.Response response;
      if(isGetMethod){
        response = await http.get(Uri.parse(apiUrl + tempGetRequest));
      }else{
        response = await http.post(Uri.parse(apiUrl), body: request);
      }
      print('response.status----'+response.statusCode.toString());
      if (response.statusCode == 200) {
        print('i am here');
        var jsonResponse = convert.jsonDecode(response.body);
        log('the response for $apiUrl is $jsonResponse');

        if (jsonResponse['status'].toString() == "1") {
          if(showSuccessMessage){
            print("check1");
            showSnackbar(jsonResponse['message']);
          }
          // return jsonResponse;
        } else {
          if(showErrorMessage){
            print("check2${jsonResponse['message']}");
            showSnackbar(jsonResponse['message']);
          }
        }
        return jsonResponse;
      } // if 200


      else{
        print('the response is ${response.statusCode} : ${response.body}');
        try{
          if(showErrorMessage){
            // print("check3");
            var jsonResponse = convert.jsonDecode(response.body);
            showSnackbar(jsonResponse['message'] );
          }
        }catch(e){
          print('Error in  catch block 39 $e');
        }
      }
    } catch (e) {
      log('Error in  f $apiUrl : ------ $e');
    }
    return {"status": 0, "message": "api failed"};
  }


  static Future<Map<String, dynamic>> getMap(String url, {Map<String, dynamic>? request, bool showSuccessMessage = false}) async {

    Map<String, dynamic> tempRequest = {};
    if(request!=null){
      request.forEach((key, value) {
        if(value!=null){
          tempRequest['$key'] = value;
        }
      });
    }
    try{
      log('the request for url $url is $tempRequest');
      late http.Response response;
      if(request==null){
        response = await http.get(Uri.parse(url));
      }else{
        response = await http.post(Uri.parse(url), body: tempRequest);
      }
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['status'].toString() == '1') {
          log('the respognse for url: $url is ${jsonResponse}');
          if(showSuccessMessage){
            showSnackbar(jsonResponse['message']);
          }
          return jsonResponse['data'] ?? jsonResponse['content']??jsonResponse;
        } else {
          log('Error in response for url $url -----${response.body}');
        }
      }else{
        print('error in status code ${response.statusCode}');
        log(response.body);
      }
    }catch(e){
      print('inside catch block 546745 $e');
    }

    return {};
  }

  static Future<List> getList(String url) async {
    var response = await getData(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if (jsonResponse['status'] == 1) {
        log('the response for url: $url is ${jsonResponse}');
        return jsonResponse['data']??[];
      } else {
        log('Error in response for url $url -----${response.body}');
      }
    }
    return [];
  }

  static Future<List> getListFromRequestParameters(String url, Map<String, dynamic> request) async {

    Map<String, dynamic> tempRequest = {};
    request.forEach((key, value) {
      if(value!=null){
        tempRequest['$key'] = value;
      }
    });
    try{
      log('the request for url $url is $tempRequest');
      var response = await http.post(Uri.parse(url), body: tempRequest);
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          log('the respognse for url: $url is ${jsonResponse}');
          try{
            print('the length is ${jsonResponse['data'].length}');
          }catch(e){
            print('Error in catch block coud not read length 32 $e');
          }
          return jsonResponse['data'] ?? [];
        } else {
          log('Error in response getlistfromrequest for url $url -----${response.body}');
        }
      }else{
        print('error in status code ${response.statusCode} for url ${url} and request $request');
        log(response.body);
      }
    }catch(e){
      print('inside catch block. 564 $e');
    }

    return [];
  }


  static Future<Map<String, dynamic>> postDataWithImageFunction({
    required Map<String, dynamic> body,
    required Map<String, dynamic> files,
    required BuildContext context,

    /// endpoint of the api
    required String apiUrl,
    bool successAlert = false,
    bool errorAlert = true,
  }) async {
    print('the request is $body');
    var url = Uri.parse(apiUrl);
    //
    log(apiUrl);
    try {
      var request = new http.MultipartRequest("POST", url);
      body.forEach((key, value) {
        request.fields[key] = value;
        // log(value2);
      });

      if (files != null) {
        (files as Map<dynamic, dynamic>).forEach((key, value) async {
          request.files.add(await http.MultipartFile.fromPath(key, value.path));
        });
      }


      log(request.fields.toString());
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      log(response.body);
      var jsonResponse = convert.jsonDecode(response.body);

      if (jsonResponse['status'].toString() == '1') {
        if (successAlert) {
          showSnackbar(jsonResponse['message']);
        }
      } else {
        if (errorAlert) {
          showSnackbar(jsonResponse['message']);
        }
      }
      return jsonResponse;
      // return response;
    } catch (e) {
      print(e);
      try{
        var response = await http.post(
            url,
            body: body
        );
        if(response.statusCode==200){
          var jsonResponse = convert.jsonDecode(response.body);
          return jsonResponse;
        }
      }catch(error){
        print('inside double catch block $error');
      }
      return {'status': 0, 'message': "fail"};
      // return null;
    }
  }



  // static Future<void> updateDeviceToken({
  //   required String userId,
  //   required String token,
  // }) async {
  //   var request = {
  //     "user_id": userId,
  //     "device_id": token,
  //   };
  //   print('the device token request for url ${ApiUrls.updateDeviceToken} is $request');
  //   try {
  //     var response = await http.post(
  //       Uri.parse(ApiUrls.updateDeviceToken),
  //       body: request,
  //     );
  //     if (response.statusCode == 200) {
  //       print('the device token is updated');
  //     } else {
  //
  //       print('error in device token with status code ${response.statusCode}');
  //       log(response.body);
  //     }
  //   } catch (e) {
  //     print('error in device token:  $e');
  //   }
  // }
  static Future<String> getStringData(String url, {Map<String, dynamic>? request}) async {

    Map<String, dynamic> tempRequest = {};
    if(request!=null){
      request.forEach((key, value) {
        if(value!=null){
          tempRequest['$key'] = value;
        }
      });
    }
    try{
      log('the request for url $url is $tempRequest');
      late http.Response response;
      if(request==null){
        response = await http.get(Uri.parse(url));
      }else{
        response = await http.post(Uri.parse(url), body: tempRequest);
      }
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        if (jsonResponse['status'].toString() == '1') {
          log('the respognse for url: $url is ${jsonResponse}');
          return jsonResponse['data'] ?? jsonResponse['content']??'NA';
        } else {
          log('Error in response for url $url -----${response.body}');
        }
      }else{
        print('error in status code ${response.statusCode}');
        log(response.body);
      }
    }catch(e){
      print('inside catch block 546745 $e');
    }

    return 'NA';
  }

  static Future<void> updateDeviceToken({
    required String userId,
    required String token,
  }) async {
    var request = {
      "user_id": userId,
      "id": userId,
      "device_id": token,
    };
    print('the device token request for url ${ApiUrls.updateDeviceToken} is $request');
    try {
      var response = await http.post(
        Uri.parse(ApiUrls.updateDeviceToken),
        body: request,
      );
      if (response.statusCode == 200) {
        print('the device token is updated');
        print(response.body);
      } else {

        print('error in device token with status code ${response.statusCode}');
        log(response.body);
      }
    } catch (e) {
      print('error in device token:  $e');
    }
  }

}
