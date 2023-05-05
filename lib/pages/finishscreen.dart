import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/global_data.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/functions/navigation_functions.dart';
import 'package:cleanerapp/pages/homescreen.dart';
import 'package:cleanerapp/pages/notification.dart';
import 'package:cleanerapp/services/api_urls.dart';
import 'package:cleanerapp/services/webservices.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/custom_text_field.dart';
import 'package:cleanerapp/widgets/dropdown.dart';
import 'package:cleanerapp/widgets/round_edged_button.dart';
import 'package:cleanerapp/widgets/workcard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../constants/sized_box.dart';
import '../constants/toast.dart';
import '../widgets/showSnackbar.dart';
class FinishScreen extends StatefulWidget {
  Map? taskDetail;
  String? completed_checklist;
  FinishScreen({Key? key, this.taskDetail, this.completed_checklist}) : super(key: key);

  @override
  State<FinishScreen> createState() => _FinishScreenState();
}

class _FinishScreenState extends State<FinishScreen> {
  var size_height;
  var size_width;
  late File imgFile;
  late File imgFile2;
  final imgPicker = ImagePicker();
  final imgPicker2 = ImagePicker();
  var selectedimage1;
  // var selectedimage2;
  Position? _currentPosition;
  String? _currentAddress;
  // TextEditingController title1=TextEditingController();
  // TextEditingController title2=TextEditingController();
  TextEditingController location1=TextEditingController();
  // TextEditingController location2=TextEditingController();
  String task_name="";
  bool loading=false;
  bool isUpload=false;
  bool bottomsheetopen=false;
  int _current = 0;
  List<String> titleList=[];
  var selectedimage;
  List data = [];


  ///image upload code
  Future<void> _image_camera_dialog(BuildContext context) async{
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          'Select an Image',
          style: GoogleFonts.openSans(
              fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black54),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
              onPressed: () async{
                var imgGallery = await imgPicker.pickImage(source: ImageSource.gallery);
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
              onPressed: () async{
                var imgCamera = await imgPicker.pickImage(source: ImageSource.camera);
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
      _currentAddress!=null ? location1.text = _currentAddress.toString() : "" ;
    }).catchError((e) {
      debugPrint(e);
    });
  }


  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];

  Future<File?> selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
      return File(selectedImages[selectedImages.length-1]!.path);
    }
    setState(() {

    });
  }

  taskDetails(){
    setState(() {
      loading = true;
    });
    widget.taskDetail!['task_type'].toString() == "3" ? task_name = "Logistics" :
    widget.taskDetail!['task_type'].toString() == "4" ? task_name = "Maintenance" :
    widget.taskDetail!['task_type'].toString() == "5" ? task_name = "Cleaner" :
    task_name = "";
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    print("string_format_checklist ${widget.completed_checklist}");

    _getCurrentPosition();
    taskDetails();
    super.initState();
  }
  TextEditingController titleController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    size_height=MediaQuery.of(context).size.height;
    size_width=MediaQuery.of(context).size.width;
    double bottomsheetHeight= size_height/1.8;

    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        // Image.asset(MyImages.menu,height:0,width:0,),
        title:ParagraphText('Task Detail #${widget.taskDetail!['id']}',fontWeight: FontWeight.w500,fontSize: 18,),
        toolbarHeight: 73,
        titleSpacing:-10,



      ),
      body:
      loading == true? Center(child: CupertinoActivityIndicator(radius: 20, color: MyColors.primaryColor,),):
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                widget.taskDetail!['apartment']['image'].length != 0 ?
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
                      return  widget.taskDetail!['apartment']['image'][index]['image'];})].map((i){
                    return Builder(
                        builder:(BuildContext context) {
                          return    ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.taskDetail!['apartment']['image'].length,
                              itemBuilder: (context, index) {
                                return  CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  height: 170,
                                  width: MediaQuery.of(context).size.width,
                                  placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(radius: 10, color: MyColors.primaryColor,),
                                  imageUrl: widget.taskDetail!['apartment']['image'][index]['image'],
                                );
                              });});}).toList(),


                ):
                Container(
                  alignment: Alignment.center,
                  height: 170,
                  width: double.infinity,
                  child: Text("No Image"),
                ),


                Positioned(
                  right: 5,
                  child: RoundEdgedButton(
                    icon:MyImages.flag ,
                    text: widget.taskDetail!['is_report'].toString() == '0' ?  'REPORT MAINTENANCE' : 'REPORTED',
                    fontSize: 10,
                    width: widget.taskDetail!['is_report'].toString() == '0' ? size_width*0.38 : size_width*0.22,
                    height: 24,
                    verticalMargin:5,
                    verticalPadding: 0,
                    borderRadius: 5,
                    onTap:() async{

                      if(widget.taskDetail!['is_report'].toString() == '0') {
                       await showDialog(
                          context: context,
                          builder: (ctx) =>
                              Dialog(
                                  insetPadding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  child: ReportCard(current_location: _currentAddress ?? "", taskDetail: widget.taskDetail,)

                              ),

                        );

                       taskDetails();
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
                  ParagraphText('${widget.taskDetail!['apartment']['name']}',color: MyColors.primaryColor,fontWeight: FontWeight.w600,fontSize: 16,),
                  ParagraphText('${widget.taskDetail!['apartment']['apartment_no']}',color:Colors.black,fontWeight: FontWeight.w600,fontSize: 16,),
                ],
              ),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),

              child: Row(
                children: [
                  Icon(Icons.location_on_rounded,color: Color(0xffB49877),size:12,),
                  hSizedBox05,
                  ParagraphText('${widget.taskDetail!['apartment']['location']}',color: Colors.black,fontSize: 12,),

                ],
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
                      ParagraphText('${widget.taskDetail!['apartment_type']['name']}',color: Colors.black,fontSize: 12,),

                    ],
                  ),
                  // RichText(text: TextSpan(
                  //     text: 'Priority: ',
                  //     style: TextStyle(color:Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Regular',fontSize: 10),
                  //     children: [
                  //       TextSpan(
                  //         text: 'High',style: TextStyle(color:Color(0xffFFCA0D),fontFamily: 'Regular',fontSize: 10),
                  //
                  //       )
                  //     ]
                  // )),
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
                        ParagraphText('Started on ${widget.taskDetail!['time']}',color: Colors.black,fontSize: 12,),
                      ],
                    ),
                    ParagraphText('${widget.taskDetail!['apartment']['check_list']}',color:Color(0xff0F3750),underlined: true,fontSize: 12,),

                  ],
                ),
              ),
            ),
            Container(width: double.infinity, height: 1, color: MyColors.primaryColor,),
            vSizedBox,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal:8),
            //   child: ParagraphText('Bathroom',color: MyColors.primaryColor,fontWeight: FontWeight.w600,fontSize: 16,),
            // ),
            // vSizedBox05,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 8),
            //   child: DropDwon(
            //     width:MediaQuery.of(context).size.width-32,
            //     height: 40,
            //     dropdownwidth:MediaQuery.of(context).size.width-32,
            //     items: ['Select Bathroom Area','trash ','shower','tub and toilet'],
            //   ),
            // ),

///
//           Expanded(
//             child: GridView.builder
//               (gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
//                 maxCrossAxisExtent:200,
//                 childAspectRatio:0.95,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10),
//                 itemCount: imageFileList!.length,
//                 itemBuilder: (BuildContext ctx, index) {
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           // for(int i=0; i<imageFileList!.length; i++)
//
//                             Stack(
//                               alignment: Alignment.topRight,
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(10),
//                                   child: imageFileList?.length != 0?
//                                   Image.file(File(imageFileList![index].path,), fit: BoxFit.cover,height: 162,width: 162,) :
//                                   Container(height: 162,width: 162,),),
//
//                                 // Image.asset(MyImages.reportimage,height: 162,width: 162,),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                                   child: RoundEdgedButton(text: 'Delete',height:19,width:  size_width*0.13,verticalPadding: 0,fontSize: 10,
//                                     fontWeight: FontWeight.w600,borderRadius: 5,
//                                   onTap: (){
//                                     print(imageFileList![index]);
//                                   },),
//                                 ),
//                               ],
//
//                             )
//
//                         ],
//                       ),
//                       vSizedBox05,
//                       ParagraphText('Bathroom',fontSize: 15,),
//                       ParagraphText('315, Pukhraj, indore',fontSize: 12,),
//                     ],
//                   );
//                 }),
//           ),
///
            data.length != 0  ?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  runSpacing: 20,
                  direction: Axis.horizontal,
                  alignment: WrapAlignment.center,
                  children: [
                    for(int i=0; i<data.length; i++)
                      Container(
                        width: size_width/2.1,
                      // padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                            Row(
                            children: [

                                Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                        Image.file(File(data![i]['image'].path,), fit: BoxFit.cover,height: 162,width: 162,)),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: RoundEdgedButton(text: 'Delete',height:19,width:  size_width*0.13,verticalPadding: 0,fontSize: 10,
                                        fontWeight: FontWeight.w600,borderRadius: 5,
                                      onTap: (){
                                        print(data![i]['image'].path);
                                        // File(data![i]['image'].path).delete();
                                        data.removeAt(i);
                                        setState(() {});
                                        print(imageFileList![i].path);
                                      },),
                                    ),
                                  ],

                                )

                            ],
                          ),
                          vSizedBox05,

                          ParagraphText(data[i]['title']??'',fontSize: 15,),

                          ParagraphText(data[i]['address'],fontSize: 11,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ):
            Container(),
            vSizedBox05,

            if(data.length == 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ParagraphText('Please upload your work images',fontSize: 13,),
            ),
            vSizedBox05,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RoundEdgedButton(
                text: data.length == 0? 'UPLOAD IMAGE' : 'UPLOAD MORE IMAGES',
                color:  Color(0xffDBDBDB), borderRadius: 10, textColor: Colors.black,
              onTap: (){
                titleController.text = "";
                setState(() {});
                selectedimage = null;


                File? selectedImage;
                showModalBottomSheet(
                    context: context,
                    barrierColor: Colors.transparent,
                    isDismissible: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    ),
                    builder: (context) {
                      return StatefulBuilder(
                          builder: (BuildContext context, StateSetter dabbeKaSetState) {

                            return SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ///select image
                                  vSizedBox4,
                                  GestureDetector(
                                    onTap: ()async{
                                      await _image_camera_dialog(context);

                                      dabbeKaSetState((){});
                                    },
                                    child:
                                    selectedimage!=null?
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child:
                                        Image.file(File(selectedimage!.path,),  fit: BoxFit.cover,height: 162,width: 162,)):
                                    Container(
                                        height:162,width: 162,
                                        decoration: BoxDecoration(
                                            color: Color(0xffDBDBDB),
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child:

                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Image.asset(MyImages.uploadreport,height:52,width:52,),
                                            ParagraphText('UPLOAD IMAGE',fontSize: 15,)

                                          ],
                                        )
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:40),
                                    child: CustomTextField
                                      (controller: titleController, hintText: 'TITLE',bgColor:Colors.white,borderRadius: 0,verticalPadding:0,maxLines:1,
                                      height: size_height*0.05,
                                    ),
                                  ) ,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:40),
                                    child: CustomTextField(controller: location1, enabled: false, hintText: 'LOCATION',bgColor:Colors.white,borderRadius: 0,maxLines: 5, contentPadding: 10,),
                                  ) ,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal:40),
                                    child: RoundEdgedButton(
                                      text: 'Save', color: MyColors.primaryColor, borderRadius: 10,onTap: (){

                                      if(titleController.text != "" && location1.text != "" && selectedimage!=null){

                                        Map temp = {
                                            'title': titleController.text,
                                            'address': location1.text,
                                            'image': selectedimage,
                                          };

                                        data.add(temp);

                                        Navigator.pop(context);

                                        this.setState(() {});
                                      }else{
                                        toast('Please enter all fields.');
                                      }
                                    },),
                                  )

                                ],
                              ),
                            );
                          });
                    });
              },
              ),
            ),



          ],
        ),
      ),

      bottomNavigationBar:


      data.length != 0 ?
      Padding(
        padding: const EdgeInsets.symmetric(horizontal:10,vertical:10),
        child: Row
          (
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RoundEdgedButton(text: 'SUBMIT', isLoad: isUpload ,height:49,width: 171,verticalPadding: 0,borderRadius: 5,color:Color(0xff14A300),
            onTap: () async{
              setState(() {
                isUpload = true;
              });

              Map<String, dynamic> request ={};
              Map<String, dynamic> img ={};

              for(int i=0; i<data.length; i++) {
                request['task_id'] = widget.taskDetail?['id'];
                request['end_location'] = _currentAddress?? "";
                request['user_id'] = userDataNotifier.value!.id;
                request['complete_checklist'] = widget.completed_checklist;
                request['title[$i]'] = data[i]['title'];
                request['location[$i]'] = data[i]['address'];
                img['images[$i]'] = data[i]['image'];
              }

              final response = await Webservices.postDataWithImageFunction(body: request, files: img, context: context, apiUrl: ApiUrls.complete_task);

              setState(() {
                isUpload = false;
              });
               if(response['status'].toString() == "1"){
                 Navigator.pop(context, true);
                 toast('Task has been completed successfully');
               }


            },),

            RoundEdgedButton(text: 'CANCEL',height: 49,width: 171,verticalPadding: 0,borderRadius: 5,color: Color(0xff5B5B5B),onTap: (){Navigator.pop(context);},),
          ],
        ),
      ): 
      Container(height: 10,)


    );
  }

}
