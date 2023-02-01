import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:smk/bloc/staff_timetable/staff_timetable_bloc.dart';
import 'package:smk/bloc/staff_timetable/staff_timetable_state.dart';
import 'package:smk/data/repository/staff_timetable_repository.dart';

import '../../bloc/badge/badge.bloc.dart';
import '../../bloc/staff_timetable/staff_timetable_event.dart';
import '../../data/repository/badge_repository.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import '../../figma/core/utils/size_utils.dart';

class TimeTable extends StatefulWidget {
  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable>  {
  final CalendarWeekController _controller = CalendarWeekController();
  String post_day_name =  DateFormat('EEEE').format(DateTime.now());
  String time = DateFormat('hh:mm a').format(DateTime.now());
  String? day;String? month_name;String? year;String? day_name;
  bool ascending = false;
  StaffTimetableBloc _staffTimetableBloc=StaffTimetableBloc(getIt<StaffTimetableRepository>());
  var sharedPreference=getIt<SharedPreferenceHelper>();
  BadgeBloc _badgeBloc = BadgeBloc(getIt<BadgeRepository>());
int c = 0;

 int? returnIndex;
  @override
  void initState() {
    // TODO: implement initState

    String teacherId = sharedPreference.getTeacherId.toString();
    _staffTimetableBloc.add(FetchStaffTimetable(day :post_day_name));

    sharedPreference.removettColorIndex();
    DateTime date = DateTime.now();
    day_name =  DateFormat('EEEE').format(DateTime.now());
    month_name = DateFormat.MMMM().format(date);
    year =  DateTime.now().year.toString();
    day = DateTime.now().day.toString();

    super.initState();
  }


  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstant.gray100,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45.0),
          )),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TodayContainer(),
          CalendarContainer(),
          Divider(thickness: 1,),
          TimeTableMenu(),
          Expanded(child: sample(),
          )

        ],
      )
    );
  }

  sample(){
    return BlocProvider<StaffTimetableBloc>(
      create: (_) => StaffTimetableBloc(getIt<StaffTimetableRepository>()),
      child: BlocBuilder<StaffTimetableBloc, StaffTimetableState>(
          bloc:_staffTimetableBloc,
          builder: (context,state){
            if(state is StaffTimetableLoading) {
              return SpinKitFadingFour(color: Color(0xff334A52),);
            }
            else if(state is StaffTimetableError){
              return Container(
                  padding: EdgeInsets.only(top: 20,bottom: 20),
                  child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
            }
            else if(state is StaffTimetableLoaded){
              int length = state.staffTimetableList.postData!.length;
              int rlength = length - 1;
              if(state.staffTimetableList.postData!.length == 0)
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No Timetabel.',style: TextStyle(fontSize: 20,),)
                  ],
                );
              if(state.staffTimetableList.postData!.length != 0)
                if ( post_day_name != day_name)
                  sharedPreference.removettColorIndex();
                else{
                  returnIndex = savettColorIndex(state,length,rlength);
                  print('return Index');
                  sharedPreference.setttColorIndex(returnIndex!);
                  print(sharedPreference.getttColorIndex);
                }


              return ListView.builder(
                scrollDirection: Axis.vertical,
                // shrinkWrap: true,
                // physics: ScrollPhysics(),
                itemCount: state.staffTimetableList.postData!.length,
                itemBuilder: (BuildContext context, int index){

                  return TimeTableList(state,index)
                  ;
                },
              )
              ;
            }
            return SpinKitFadingFour(color: Color(0xff334A52),);
          }
      ),
    );
  }

  savettColorIndex(StaffTimetableLoaded state, int length, int rlength){
    int saveIndex = 0;
    for( var i=0; i<length; i++){
      DateTime fromTime = DateFormat("hh:mm a").parse(state.staffTimetableList.postData![i].time_from.toString());
      String from = DateFormat.Hm().format(fromTime);
      String fromInt = from.replaceAll(":", "");

      DateTime toTime = DateFormat("hh:mm a").parse(state.staffTimetableList.postData![i].time_to.toString());
      String to = DateFormat.Hm().format(toTime);
      String toInt =  to.replaceAll(":", "");

      String now = DateFormat.Hm().format(DateTime.now());
      String nowInt = now.replaceAll(":", "");

      print("compare");

      if( int.parse(nowInt) == int.parse(toInt) ){
        print('equal to');
        return i;
      }
      else if( int.parse(nowInt) == int.parse(fromInt) ){
        print('equal from');
        return i;
      }
      else if( int.parse(fromInt) < int.parse(nowInt) && int.parse(nowInt) < int.parse(toInt) ){
        print('btw'); return i;
      }
      else{
        if ( int.parse(nowInt) < int.parse(fromInt) ){ print('less from');return i==0?0:i-1;}
        else{
          if ( i == rlength){print('23');return 0;}
          for( var j=i+1; j<length; j++){
            int first = j-1;
            DateTime f = DateFormat("hh:mm a").parse(state.staffTimetableList.postData![first].time_to.toString());
            String toStr = DateFormat.Hm().format(f);
            String fToInt = toStr.replaceAll(":", "");

            DateTime s = DateFormat("hh:mm a").parse(state.staffTimetableList.postData![j].time_from.toString());
            String sStr = DateFormat.Hm().format(s);
            String sFromInt = sStr.replaceAll(":", "");
            if ( int.parse(nowInt) > int.parse(fToInt) && int.parse(nowInt) < int.parse(sFromInt)){
              print('j');
              return j;
            }

          }


        }

      }

    }

  }
  secIndex(StaffTimetableLoaded state, int i, int rlength){
    DateTime fromTime = DateFormat("hh:mm a").parse(state.staffTimetableList.postData![i].time_from.toString());
    String from = DateFormat.Hm().format(fromTime);
    String fromInt = from.replaceAll(":", "");

    DateTime toTime = DateFormat("hh:mm a").parse(state.staffTimetableList.postData![i].time_to.toString());
    String to = DateFormat.Hm().format(toTime);
    String toInt =  to.replaceAll(":", "");

    String now = DateFormat.Hm().format(DateTime.now());
    String nowInt = now.replaceAll(":", "");

    if ( int.parse(nowInt) > int.parse(toInt) ){

      return i;
    }
    else{
      if ( i == rlength) return 0;
      else return i+1;
    }

  }


  sample2(){
    return SingleChildScrollView(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          // TimeTableList(),
         // TimeTableList(),
         // TimeTableList(),
         // TimeTableList(),TimeTableList(),
         // TimeTableList(),
         // TimeTableList(),
         // TimeTableList(),TimeTableList(),TimeTableList(),TimeTableList(),TimeTableList(),


        ],
      ),);
  }
  TimeTableMenu(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:
      CrossAxisAlignment.start,
        children: [
          Container(
              margin: new EdgeInsets.only(top: 20,left: 15),
              width: 100,
              height: 40,

              child:
              Text(
                'Time', overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                style: TextStyle( color : ColorConstant.bluegray200,fontSize: 18,
                  fontFamily: 'Poppins',
                ),
              )),
          Expanded(
              child:Container(
                margin: new EdgeInsets.only(top: 20,right: 15),
                height: 40,
                child: Text(
                  'Course', overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                  style: TextStyle( color : ColorConstant.bluegray200,fontSize: 18,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
          )
        ],

    );
  }

  TimeTableList(StaffTimetableLoaded state, int index){
    int length = state.staffTimetableList.postData!.length;
    return  Container(
      margin: EdgeInsets.only(left: 15,right: 15,bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 100,
              height: 70,
              child: Column(
                mainAxisSize:MainAxisSize.min,
                crossAxisAlignment:CrossAxisAlignment.start,
                mainAxisAlignment:MainAxisAlignment.center,
                children: [
                  Text(
                    state.staffTimetableList.postData![index].time_from.toString(),
                    overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                    style: TextStyle(
                      color: ColorConstant.gray900, fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Padding(
                      padding: getPadding( left: 2,top: 1,right: 1,),
                      child: Text(state.staffTimetableList.postData![index].time_to.toString(),
                        overflow: TextOverflow.ellipsis,
                        textAlign:TextAlign.left,
                        style: TextStyle(color: ColorConstant.bluegray200,
                          fontSize:16,fontFamily:'Poppins',fontWeight:FontWeight.w500,
                        ),
                      ),
                    ),)
                ],
              )
          ),
          Expanded(
              child:Container(
                  padding: EdgeInsets.only(left: 10),
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: sharedPreference.getttColorIndex== index?
                    Colors.greenAccent: ColorConstant.gray200,
                  ),
                  child:  Column(
                    mainAxisSize:MainAxisSize.min,
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Text(
                        state.staffTimetableList.postData![index].subject_name.toString(),
                        overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.gray900, fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(padding: getPadding( left: 2,top: 2,right: 1,)),
                      Row(
                        children: [
                          SvgPicture.asset(
                            "assets/images/img_location.svg", //asset location
                            //svg color
                            semanticsLabel: 'SVG From asset folder.',
                            width: 20,
                            height: 20,
                          ),
                          Padding(padding: EdgeInsets.only(right: 5)),
                          Text(
                            state.staffTimetableList.postData![index].room_no.toString(),
                            overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                            style: TextStyle(
                              color: ColorConstant.gray900, fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),

                          )],
                      )
                    ],
                  )
              )
          )
        ],

      ),
    );
  }


  TodayContainer(){
    return Container(
        height: 90,
        margin: EdgeInsets.only(left: 15,right: 15),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child:  Text(day!,overflow:
              TextOverflow.ellipsis,
                textAlign:
                TextAlign.left,
                style:
                TextStyle(
                  color:
                  ColorConstant.black900,
                  fontSize: 50,
                  fontFamily:
                  'Poppins',
                  fontWeight:
                  FontWeight.w600,
                ),),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  day_name!, overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                  style: TextStyle( color: Colors.grey,fontSize: 16,
                    fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      month_name!, overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                      style: TextStyle( color: Colors.grey,fontSize: 16,
                        fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      year!, overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,
                      style: TextStyle( color: Colors.grey,fontSize: 16,
                        fontFamily: 'Poppins', fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            //for today button
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child:  GestureDetector(
                  onTap: (){
                    _controller.jumpToDate(DateTime.now());
                    setState(() {
                      post_day_name =  DateFormat('EEEE').format(DateTime.now());
                      String teacherId = sharedPreference.getTeacherId.toString();
                      _staffTimetableBloc.add(FetchStaffTimetable(day :post_day_name));
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    height: 50,
                    width: 100,
                    decoration: BoxDecoration(
                        color: ColorConstant.blue50,
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Center(child: Text('Today',
                      style: TextStyle(fontSize: 20,fontFamily: 'Rasa',color: Colors.greenAccent),),),
                  ),
                ),
              ),
            )
          ],
        )
    );
  }


  CalendarContainer(){
    return Column(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  spreadRadius: 1)
            ]),
            child: CalendarWeek(
              controller: _controller,
              height: 100,
              dateStyle: TextStyle(color: Colors.black,),
              dayOfWeekStyle: TextStyle(color: Colors.black),
              minDate: DateTime.now().add(
                Duration(days: -365),
              ),
              maxDate: DateTime.now().add(
                Duration(days: 365),
              ),
              onDatePressed: (DateTime datetime){
                setState(() {

                    post_day_name =  DateFormat('EEEE').format(datetime);
                    String teacherId = sharedPreference.getTeacherId.toString();
                    sharedPreference.removettColorIndex();
                    _staffTimetableBloc.add(FetchStaffTimetable(day :post_day_name));
                });

              },
              onDateLongPressed: (DateTime datetime) {
                // Do something
              },
              onWeekChanged: () {
                // Do something
              },
              monthViewBuilder: (DateTime time) => Align(
                alignment: FractionalOffset.center,
                child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMM().format(time),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w600),
                    )),
              ),
              decorations: [
                DecorationItem(
                    decorationAlignment: FractionalOffset.bottomRight,
                    date: DateTime.now(),
                    decoration: Icon(
                      Icons.today,
                      color: Colors.red,
                    )),

              ],


            ),
          )
        ]
    );
  }
}

