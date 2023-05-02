import 'package:flutter/material.dart';

import '../constants/images_url.dart';
class Addvertigement extends StatelessWidget {
  const Addvertigement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
padding:EdgeInsets.all(16),
      constraints: BoxConstraints(
          maxHeight:50,

      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
             Color(0xFF0075d9),
            Color(0xFF002d79),
          ],
        ),
      ),

      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('All-In-One Accounting is a Hole In One',style: TextStyle(fontSize: 12,fontFamily: 'OpenSansSemiBold',color: Color(0xffffffff)),),
              Icon(Icons.flag,color: Color(0xffffffff),)
            ],

          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal:12,vertical:4),
            decoration: BoxDecoration(
              color: Color(0xFF37a401),
              borderRadius: BorderRadius.circular(2)
            ),
            child: Text('Try FreshBook',style: TextStyle(color: Color(0xffffffff),fontFamily: 'OpenSansSemiBold',fontSize: 10),),
          )
        ],
      ),
      // Image.asset(MyImages.addimage,width:MediaQuery.of(context).size.width ,),

    );
  }
}
