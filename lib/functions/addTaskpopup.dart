import 'package:cleanerapp/widgets/custom_text_field.dart';
import 'package:cleanerapp/widgets/dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/colors.dart';
import '../widgets/round_edged_button.dart';



addTaskDialog(
    BuildContext context,
    final List<String> apt_name,
        final String? selected_apt,
        final Function(String?)? apt_onChange,
    ){

  DateTime selectedDate = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  TextEditingController datepicker = TextEditingController();
  TextEditingController timepicker = TextEditingController();
  bool isEnable=false;





  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width*0.05, right: MediaQuery.of(context).size.width*0.05,  ),
        child: StatefulBuilder(
            builder: (context, setState) {

              pick_date(){
                return showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 100000)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: MyColors.primaryColor,
                            onPrimary: Color(0xffE2E2E2),
                            onSurface: Color(0xff1C1F24),
                          ),
                        ),
                        child: child!,
                      );
                    }).then((value) {
                  DateTime newDate = DateTime(
                      value != null ? value.year : selectedDate.year,
                      value != null ? value.month : selectedDate.month,
                      value != null ? value.day : selectedDate.day,
                      selectedDate.hour,
                      selectedDate.minute);
                  setState(() {
                    selectedDate = newDate;
                    datepicker.text = DateFormat("dd-MMM-yyyy").format(selectedDate);
                  });

                });
              }

              _selectTime() async {
                final TimeOfDay? newTime = await showTimePicker(
                  context: context,
                  initialTime: _time,
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: MyColors.primaryColor,
                            onPrimary: Color(0xffE2E2E2),
                            onSurface: Color(0xff1C1F24),
                          ),
                        ),
                        child: child!,
                      );
                    }
                );
                if (newTime != null) {
                  setState(() {
                    _time = newTime;
                    print("_time$_time");
                    timepicker.text = _time.format(context);
                  });
                }
              }

              return AlertDialog(
                backgroundColor:   MyColors.scafoldcolor,
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                content: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 1.1,

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ///heading
                            Text("Add Task",
                              style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: InkWell(
                                  onTap: ()=> Navigator.pop(context),
                                  child: Icon(CupertinoIcons.multiply)),
                            ),
                          ],
                        ),
                        Divider(),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                        Text("Appartment",
                          style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                        DropDown(
                            label: "Select Apartment",
                          fontsize: 16,
                          width: MediaQuery.of(context).size.width,
                          dropdownwidth: MediaQuery.of(context).size.width/1.25,
                          height: MediaQuery.of(context).size.height*0.06,
                          items: apt_name,
                          selectedValue: selected_apt,
                          onChange: apt_onChange,
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Text("Date",
                          style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomTextField(
                            controller: datepicker,
                            hintText: 'Pick Date',
                            enabled: isEnable,
                            borderRadius: 5,
                            bgColor: Colors.white,
                            suffix2: GestureDetector(
                                onTap: (){
                                  pick_date();
                                },
                                child: Icon(Icons.calendar_month)),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Text("Time",
                          style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        CustomTextField(
                            controller: timepicker,
                            hintText: 'Pick Time',
                            enabled: isEnable,
                            borderRadius: 5,
                            bgColor: Colors.white,
                            suffix2: GestureDetector(
                                onTap: (){
                                  _selectTime();
                                },
                                child: Icon(Icons.access_time)),
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Text("Work Priority",
                          style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                        DropDown(
                          label: "Select Work Priority",
                          items: ["Low", "Medium", "High"],
                          fontsize: 16,
                          width: MediaQuery.of(context).size.width,
                          dropdownwidth: MediaQuery.of(context).size.width/1.25,
                          height: MediaQuery.of(context).size.height*0.06,
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),



                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        Text("Staff",
                          style: TextStyle(letterSpacing: 0.3, height: 1.5,fontSize: 18, color: MyColors.blackColor, fontFamily: "trans_regular ", fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),

                        DropDown(
                          label: "Select Staff Name",
                          items: ["Kritika", "Rohit"],
                          fontsize: 16,
                          width: MediaQuery.of(context).size.width,
                          dropdownwidth: MediaQuery.of(context).size.width/1.25,
                          height: MediaQuery.of(context).size.height*0.06,
                        ),

                        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                        RoundEdgedButton(
                            text: 'Add Task',
                            color: MyColors.primaryColor,
                          borderRadius: 10,
                        ),


                      ],
                    ),
                  ),
                ),
              );
            }
        ),
      );
    },
  );
}