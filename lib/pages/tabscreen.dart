// import 'package:flutter/material.dart';
// import 'package:valetapp/constants/colors.dart';
// import 'package:valetapp/constants/images_url.dart';
// import 'package:valetapp/pages/homescreen.dart';
//
// import '../constants/box_shadow.dart';
// class TabScreen extends StatefulWidget {
//   const TabScreen({Key? key}) : super(key: key);
//
//   @override
//   State<TabScreen> createState() => _TabScreenState();
// }
//
// class _TabScreenState extends State<TabScreen> {
//
//   @override
//   Widget build(BuildContext context) {
//     int _selectedIndex = 0;
//     void _onItemTapped(int index) {
//       setState(() {
//         print('pressed');
//         _selectedIndex = index;
//       });
//     }
//     return Scaffold(
//
//       body:  Center(
//         child: [
//             HomeScreen(),
//             HomeScreen(),
//             HomeScreen(),
//             HomeScreen(),
//           ].elementAt(_selectedIndex),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.symmetric(horizontal:20),
//         decoration: BoxDecoration(
//             color: MyColors.whiteColor,
//             boxShadow: [
//               boxShadowtop
//             ]
//         ),
//         child: BottomNavigationBar(
//           backgroundColor:MyColors.whiteColor,
//           type: BottomNavigationBarType.fixed,
//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           selectedFontSize: 10,
//           elevation: 0,
//           unselectedFontSize: 10,
//           selectedLabelStyle: TextStyle(fontFamily: 'medium'),
//           // unselectedLabelStyle: TextStyle(fontFamily: 'medium'),
//           unselectedItemColor:Color(0xff575757),
//           items: <BottomNavigationBarItem>[
//             BottomNavigationBarItem(
//               icon: Padding(
//                 padding: const EdgeInsets.all(2),
//                 child: ImageIcon(
//                   AssetImage(MyImages.tabicon0),
//                   size:24,
//                 ),
//               ),
//
//               activeIcon:Padding(
//                 padding: const EdgeInsets.all(2),
//                 child: ImageIcon(AssetImage(MyImages.tabicon0fill), size: 24,),
//               ),
//               label: '',
//
//
//             ),
//             BottomNavigationBarItem(
//               label: '',
//               icon: Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: ImageIcon(
//                       AssetImage(MyImages.tabicon1),
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//               activeIcon: Stack(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: ImageIcon(
//                       AssetImage(MyImages.tabicon1fill),
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             BottomNavigationBarItem(
//               label: '',
//               icon: Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: ImageIcon(
//                       AssetImage(MyImages.tabicon2),
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//               activeIcon: Stack(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(2),
//                     child: ImageIcon(
//                       AssetImage(MyImages.tabicon2fill),
//                       size: 24,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             BottomNavigationBarItem(
//
//               icon: Padding(
//                 padding: const EdgeInsets.all(2),
//                 child: ImageIcon(
//                   AssetImage(MyImages.tabicon3),
//                   size: 24,
//                 ),
//               ),
//               activeIcon: Padding(
//                 padding:  EdgeInsets.all(2),
//                 child: ImageIcon(
//                   AssetImage(MyImages.tabicon3fill),
//                   size: 24,
//                 ),
//               ),
//               label: '',
//
//             ),
//
//           ],
//           currentIndex: _selectedIndex,
//           selectedItemColor: MyColors.primaryColor,
//           onTap: _onItemTapped,
//         ),
//       ),
//     );
//   }
// }
