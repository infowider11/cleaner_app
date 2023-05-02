import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../constants/colors.dart';
import '../constants/sized_box.dart';
class RoundEdgedButton extends StatelessWidget {
  final double? height;
  final Color color;
  final Color? loaderColor;
  final String text;
  final bool load;
  final String fontfamily;
  final Function()? onTap;
  final double horizontalMargin;
  final double verticalPadding;
  final double verticalMargin;
  // final Gradient? gradient;
  final bool isSolid;
  final bool isWhite;
  final Color? textColor;
  final double? borderRadius;
  final bool isBold;
  final double? fontSize;
  final double? width;
  final String? icon;
  final bool showGradient;
  final bool isLoad;
  final  FontWeight?  fontWeight;

  const RoundEdgedButton(
      {Key? key,
        this.color = MyColors.redColor,
        this.loaderColor = MyColors.primaryColor,
      required this.text,
        this.isWhite = false,
        this.fontfamily = 'Regular',
      this.onTap,
      this.load=false,
        this.horizontalMargin=0,
        this.textColor,
        this.borderRadius,
        this.isBold = false,
        this.verticalMargin = 12,
        this.verticalPadding = 0,
        this.width,
        this.isLoad=false,
        this.fontSize=15,
        this.icon,
        this.showGradient = false,
        this.height=50,
        this.fontWeight= FontWeight.w500,

        // required this.hasGradient,
      this.isSolid=true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (isLoad==true)?null:onTap,
      child: Stack(
        children: [
          Container(
             height: height,
            margin: EdgeInsets.symmetric(horizontal: horizontalMargin,vertical: verticalMargin),
            width: width??(MediaQuery.of(context).size.width),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: verticalPadding),
            decoration: BoxDecoration(
              color:isWhite?Colors.white:isSolid? color:Colors.transparent,
                gradient:showGradient? LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xfff02321),
                    Color(0xff781211),
                  ],
                ):null,
              borderRadius: BorderRadius.circular(borderRadius??30),
              border:isSolid?null: Border.all(color: color),
            ),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(icon!=null)
                Image.asset(icon!,height:12,),
                if(icon!=null)
                  hSizedBox,
                Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:textColor??(isWhite?MyColors.primaryColor:isSolid? Colors.white:color),
                    fontSize: fontSize??24,
                    fontWeight:fontWeight,

                    // fontWeight:isBold?FontWeight.w700: FontWeight.w500,

                    // letterSpacing: 2,
                    fontFamily: fontfamily,
                  ),
                ),

                if(isLoad==true)
                  Row(
                    children: [
                      SizedBox(width: MediaQuery.of(context).size.width*0.03),
                      CupertinoActivityIndicator(radius: 15, color:loaderColor,)
                    ],
                  )


              ],
            )
          ),
          // if(load==true)
          //   Positioned(
          //     right:32,
          //     top: 0,
          //     bottom: 0,
          //     child: Center(
          //       child: Container(
          //           height: (height??50)-20,
          //           width: (height??50)-20,
          //           child: CircularProgressIndicator(color: loaderColor??MyColors.primaryColor)
          //       ),
          //     ),
          //   )
        ],
      ),
    );
  }
}
