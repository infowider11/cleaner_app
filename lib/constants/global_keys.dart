import 'package:flutter/material.dart';
import '../pages/Maintenance_home_screen.dart';
import '../pages/homescreen.dart';

class MyGlobalKeys{

  static final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  static final GlobalKey<HomeScreenState> homeScreenKey = new GlobalKey<HomeScreenState>();
  static final GlobalKey<Maintenance_home_screenState> maintenanceHomeKey = new GlobalKey<Maintenance_home_screenState>();

}