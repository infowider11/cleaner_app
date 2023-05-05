import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleanerapp/constants/box_shadow.dart';
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/global_data.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/constants/sized_box.dart';
import 'package:cleanerapp/functions/navigation_functions.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:cleanerapp/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';


class LastInventoryScreen extends StatefulWidget {
  List? image;
  String date;
  String? time;
  String? cleanerName;

  LastInventoryScreen({Key? key, required this.image, required this.date, required this.time, required this.cleanerName}) : super(key: key);

  @override
  State<LastInventoryScreen> createState() => _LastInventoryScreenState();
}

class _LastInventoryScreenState extends State<LastInventoryScreen> with SingleTickerProviderStateMixin{
  var current_date_time = DateFormat('d MMM yyyy, hh:mm a').format(DateTime.now());

  late TransformationController controller;
  late AnimationController animationController;
  Animation<Matrix4>? animation;

  final double minScale = 1;
  final double maxScale = 4;

  @override
  void initState() {
    print("lastimage- ${widget.image}");
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

  @override
  Widget build(BuildContext context) {
    final List<Map> myProducts = [
      {"id": 1, "iamge": MyImages.LatestInventory},
      {"id": 2, "iamge": MyImages.LatestInventory},
      {"id": 3, "iamge": MyImages.LatestInventory},
      {"id": 4, "iamge": MyImages.LatestInventory},
      {"id": 5, "iamge": MyImages.LatestInventory},
      {"id": 6, "iamge": MyImages.LatestInventory},
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        // Image.asset(MyImages.menu,height:0,width:0,),
        title:ParagraphText('Last Inventory ',fontWeight: FontWeight.w500,fontSize: 18,),
        toolbarHeight: 73,
        titleSpacing:-10,



      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.image?.length == 0 ?
                ParagraphText('',fontSize: 16,):
                ParagraphText('${widget.image?.length} Images',fontSize: 16,),
                // DropDwon(
                //   width: 130,
                //   dropdownwidth: 130,
                //   label: 'Latest Inventory',
                //   items: ['Latest Inventory','1','2','3,'],
                //
                // ),

              ],
            ),
            vSizedBox2,

            widget.image?.length == 0 ? Expanded(child: Center(child: Lottie.asset(MyImages.no_data))) :
            Expanded(
              child: GridView.builder
                (gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:200,
                  childAspectRatio:0.88,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
                  itemCount:  widget.image?.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                        alignment: Alignment.center,
                      decoration: BoxDecoration(
                        boxShadow: [shadow],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          widget.image?.length != 0?
                          InkWell(
                            onTap: (){
                              print(index);
                              push(context: context, screen: lastInventaryGallery(images: widget.image, imgImdex:index ));
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                  const CupertinoActivityIndicator(radius: 5, color: MyColors.primaryColor,),
                                  imageUrl: "${widget.image?[index]['image']}",
                                  height: 130,
                                  width: double.infinity,
                                  fit: BoxFit.cover,)),
                          )   :
                          Container(
                            alignment: Alignment.center,
                            height: 500,
                            width: double.infinity,
                            child: Text("No Image"),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal:5,vertical:5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ParagraphText('Uploaded by: ${widget.cleanerName}',fontSize:12,overflow: TextOverflow.ellipsis,),
                                ParagraphText('Date: ${DateFormat('dd-MMM-yyyy').format(DateTime.parse(widget.date))}',fontSize:12,overflow: TextOverflow.ellipsis,),
                                ParagraphText('Time: ${widget.time}',fontSize:12,overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          )




                        ],
                      )
                    );
                  }),
            ),
          ],
        ),
      ),

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


class lastInventaryGallery extends StatefulWidget {
  final List? images;
  final int imgImdex;


  lastInventaryGallery({Key? key, required this.images , required this.imgImdex}) : super(key: key);

  @override
  State<lastInventaryGallery> createState() => lastInventaryGalleryState();
}

class lastInventaryGalleryState extends State<lastInventaryGallery> {
  PageController controller=PageController();
  final _controller = ScrollController();

  @override
  void initState() {
    openPicture();
    super.initState();
  }

  openPicture(){
    Future.delayed(Duration(microseconds: 500),(){
      controller.jumpToPage(widget.imgImdex);
    });
  }

  next(){
    controller.nextPage(duration: Duration(microseconds: 200), curve: Curves.easeIn);
  }

  previous(){
    controller.previousPage(duration: Duration(microseconds: 200), curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PhotoViewGallery.builder(

            itemCount: widget.images?.length,
            pageController: controller,

            builder: (context, index){
              final inventoryImage = widget.images?[index]['image'];

              return PhotoViewGalleryPageOptions(

                imageProvider: CachedNetworkImageProvider(inventoryImage),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.contained * 4,
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 70,
            child: Row(
              children: [
                GestureDetector(
                  onTap: (){
                    previous();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(CupertinoIcons.chevron_back, color: MyColors.blackColor, size: 30,),
                  ),
                ),
                hSizedBox8,
                hSizedBox8,
                GestureDetector(
                  onTap: (){
                    next();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100)
                    ),
                    child: Icon(CupertinoIcons.chevron_right, color: MyColors.blackColor, size: 30,),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: GestureDetector(
              onTap: (){
                Navigator.pop(context);
              },
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100)
                ),
                child: Icon(CupertinoIcons.multiply, color: MyColors.blackColor, size: 20,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
