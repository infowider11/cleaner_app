import 'package:cleanerapp/Model/user_model.dart';
import 'package:cleanerapp/constants/images_url.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum UserType { Maintenance , Supervisor,Logistics,Cleaners,Secratary }

double size_height=0;
double size_width=0;

enum Options { Edit, Delete }


 final One_Signal_appid = "f2c16224-62fe-410d-8b93-71b94a1d77e7";

late final SharedPreferences prefs;

ValueNotifier<User_data?> userDataNotifier = ValueNotifier(null);

String userToken = '';

String? selectedValue;


List<bool> numberTruthList = [false, true, true, true , true, true];

List workcarddetails =[
  {  'apartmentimage':MyImages.apartmentpic,
    'apartmentname':'Apartment Name',
    'location':'15205 North Kierland Blvd. Suite 100',
    'apartmenttype':'Commercial ',
    'wrokpriority':'high',
    'cleanername':'John Smith (cleaner)',
    'time':'03 Feb 2023',
    'workstatus':'NOT STARTED',
    'workstatus1':'Maintenance'
  },
  {  'apartmentimage':MyImages.apartmentpic,
    'apartmentname':'Apartment Name',
    'location':'15205 North Kierland Blvd. Suite 100',
    'apartmenttype':'Commercial ',
    'wrokpriority':'high',
    'cleanername':'John Smith (cleaner)',
    'time':'Stated at 2PM',
    'workstatus':'IN PROGRESS',
    'workstatus1':'Cleaning'

  },
  {  'apartmentimage':MyImages.apartmentpic,
    'apartmentname':'Apartment Name',
    'location':'15205 North Kierland Blvd. Suite 100',
    'apartmenttype':'Commercial ',
    'wrokpriority':'high',
    'cleanername':'John Smith (cleaner)',
    'time':'Stated at 2PM',
    'workstatus':'Completed',
    'workstatus1':'Cleaning'

  },
  {  'apartmentimage':MyImages.apartmentpic,
    'apartmentname':'Apartment Name',
    'location':'15205 North Kierland Blvd. Suite 100',
    'apartmenttype':'Commercial ',
    'wrokpriority':'high',
    'cleanername':'John Smith (cleaner)',
    'time':'Stated at 2PM',
    'workstatus':'Completed',
    'workstatus1':'Cleaning'

  },
  {  'apartmentimage':MyImages.apartmentpic,
    'apartmentname':'Apartment Name',
    'location':'15205 North Kierland Blvd. Suite 100',
    'apartmenttype':'Commercial ',
    'wrokpriority':'high',
    'cleanername':'John Smith (cleaner)',
    'time':'Stated at 2PM',
    'workstatus':'CHECKED',
    'workstatus1':'Cleaning',
    'CHECKEDBY':'Supervised'

  },

];
 List checklist=[
   {
     'check':false,
     'title':'Floor'
   },
   {
     'check':false,
     'title':'Microwave'
   },
   {
     'check':false,
     'title':'Glasses'
   },
   {
     'check':false,
     'title':'Mirror'
   },
   {
     'check':false,
     'title':'Bathroom'
   },


 ];

List suncat=[
  {
    'name':'building 1 apt 1',
    'show': false
  },
  {

    'name':'building 1 apt 2',
    'show': false
  },
  {

    'name':'building 1 apt 3',
    'show': true
  },
  {

    'name':'building 2 apt 1',
    'show': false
  },
  {
    'name':'building 2 apt 2',
    'show': true
  },
  {
    'name':' building 2 apt 3',
    'show': true
  },
];

List ingradientslist=[
  {
    'name':'building 1 apt 1',
    'show': false
  },
  {

    'name':'building 1 apt 2',
    'show': false
  },
  {

    'name':'building 1 apt 3',
    'show': false
  },
  {

    'name':'building 2 apt 1',
    'show': false
  },
  {
    'name':'building 2 apt 2',
    'show': true
  },
  {
    'name':' building 2 apt 3',
    'show': false
  },
];

