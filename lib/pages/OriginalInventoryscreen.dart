import 'package:cached_network_image/cached_network_image.dart';
import 'package:cleanerapp/constants/colors.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:cleanerapp/constants/sized_box.dart';
import 'package:cleanerapp/functions/navigation_functions.dart';
import 'package:cleanerapp/widgets/CustomTexts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';



class OriginalInventoryScreen extends StatefulWidget {
  List? image;
  OriginalInventoryScreen({Key? key, required this.image}) : super(key: key);

  @override
  State<OriginalInventoryScreen> createState() => _OriginalInventoryScreenState();
}

class _OriginalInventoryScreenState extends State<OriginalInventoryScreen>  with SingleTickerProviderStateMixin{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteColor.withOpacity(0.85),
      appBar: AppBar(
        backgroundColor: MyColors.primaryColor,
        leading: GestureDetector(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back_ios)),
        // Image.asset(MyImages.menu,height:0,width:0,),
        title:ParagraphText('Original Inventory ',fontWeight: FontWeight.w500,fontSize: 18,),
        toolbarHeight: 73,
        titleSpacing: -10,


      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:10,vertical: 10),
        child: Column(
          children: [
            widget.image?.length == 0?
            Container(
              alignment: Alignment.center,
              height: 500,
              width: double.infinity,
              child: Text("No Image"),
            ):
            Expanded(
              child: GridView.builder
                (gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio:1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemCount: widget.image?.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15)),
                      child:

                      InkWell(
                        onTap: (){
                          // if(widget.image?[index]['id'] == "")
                          print(index);
                          push(context: context, screen: GalleryImages(images: widget.image, imgImdex:index ));
                        },
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              placeholder: (context, url) =>
                              const CupertinoActivityIndicator(radius: 5, color: MyColors.primaryColor,),
                              imageUrl: "${widget.image?[index]['image']}",
                              height: 200,
                              fit: BoxFit.cover,)),
                      )

                    );
                  }),
            ),
          ],
        ),
      ),

    );
  }
}

class GalleryImages extends StatefulWidget {
  final List? images;
  final int imgImdex;


  GalleryImages({Key? key, required this.images , required this.imgImdex}) : super(key: key);

  @override
  State<GalleryImages> createState() => _GalleryImagesState();
}

class _GalleryImagesState extends State<GalleryImages> {
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

