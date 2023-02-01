import 'package:badges/badges.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:smk/bloc/announcements/announcement_bloc.dart';
import 'package:smk/bloc/announcements/announcement_event.dart';
import 'package:smk/bloc/announcements/announcementsList/announcement_list_event.dart';
import 'package:smk/bloc/staff_permission/stf_per_bloc.dart';
import 'package:smk/data/local/constants/svgImages.dart';
import 'package:smk/data/repository/announcement_repository.dart';
import 'package:smk/ui/notification/notification_home.dart';
import 'package:smk/ui/staff/staff_leave_balance/staff_leave_balance_home.dart';
import 'package:smk/ui/students/student_apply_leave/std_apply_leave_home.dart';

import '../../bloc/announcements/announcement_state.dart';
import '../../bloc/announcements/announcementsList/announcement_list_bloc.dart';
import '../../bloc/announcements/announcementsList/announcement_lsit_state.dart';
import '../../bloc/badge/badge.bloc.dart';
import '../../bloc/badge/badge.event.dart';
import '../../bloc/badge/badge_page.state.dart';
import '../../bloc/staff_permission/stf_per_event.dart';
import '../../bloc/staff_permission/stf_per_state.dart';
import '../../data/repository/badge_repository.dart';
import '../../data/repository/stf_per_repository.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import 'package:intl/intl.dart';

import '../../figma/core/utils/color_constant.dart';
import '../../firebase_options.dart';
import '../../models/announcements/announcement_list_model.dart';
import '../../models/announcements/announcement_model.dart';
import '../announcements/announcement_detail.dart';
import '../announcements/announcement_list.dart';
import '../students/student_apply_leave/std_apply_leave_add.dart';
import '../students/student_attendence/student_attendence_marking.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  AnnouncementListBloc _announcementBloc=AnnouncementListBloc(getIt<AnnouncementRepository>());
  StfPerBloc _stfPerBloc=StfPerBloc(getIt<StfPerRepository>());
  late Announcement _announcement;
  List colors = [ColorConstant.lightBlue50, ColorConstant.teal50, ColorConstant.red100, ColorConstant.teal50, ColorConstant.lightBlue50];
  String? imgRes;
  BadgeBloc _badgeBloc = BadgeBloc(getIt<BadgeRepository>());
  getH() async{

  }
  @override
  void initState() {
    _announcementBloc.add(FetchAnnouncementList());
    _stfPerBloc.add(FetchStfPer());
    _badgeBloc.add(FetchBadge(type: "student_applyleave"));
    _badgeBloc.add(FetchBadge(type: "notification"));

    print('home box');
    getH();


    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      print('Message clicked!  '+message.notification!.body.toString());
      setState(() {
        _badgeBloc.add(FetchBadge(type: "student_applyleave"));
      });


    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message recieved");

      setState(() {
        _badgeBloc.add(FetchBadge(type: "student_applyleave"));
      });


    });




    DateTime dateTime = DateFormat("hh:mm a").parse("01:00 AM");
    String from = DateFormat.Hm().format(dateTime);
    String time = DateFormat.Hm().format(DateTime.now());


    print("Dashboard");print(dateTime.toString());print(from.replaceAll(":", ""));print(time.toString());


    final format = DateFormat.jm(); //"6:00 AM"
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstant.gray100,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45.0),
          )),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 10,)),
            Align(
              alignment: Alignment.topLeft,
              child:  Text(
                'Announcements',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,

                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
                width: double.infinity,
                height: 220,
                child: BlocProvider<AnnouncementListBloc>(
                  create: (_) => AnnouncementListBloc(getIt<AnnouncementRepository>()),
                  child: BlocBuilder<AnnouncementListBloc, AnnouncementListState>(
                      bloc:_announcementBloc,
                      builder: (context,state){
                        if(state is AnnouncementListLoading) {
                          return SpinKitFadingFour(color: Color(0xff334A52),);
                        }
                        else if(state is AnnouncementListError){
                          return Container(
                              padding: EdgeInsets.only(top: 20,bottom: 20),
                              child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
                        }
                        else if(state is AnnouncementListLoaded){
                          return
                            ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // shrinkWrap: true,
                              // physics: ScrollPhysics(),
                              itemCount: 5,
                              itemBuilder: (BuildContext context, int index){
                                imgRes =  getImageLink(state,index);
                                return
                                  GestureDetector(
                                      onTap: () {



                                        Navigator.push(context,
                                            MaterialPageRoute(builder:  (BuildContext context) =>
                                                AnnouncementDeatil(
                                                  id: state.data.postData![index].id.toString(),
                                                )
                                            ));
                                      },
                                      child:Card(
                                        color: colors[index],
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          //set border radius more than 50% of height and width to make circle
                                        ),
                                        child: Container(

                                          width: 190,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(50)
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    // image: Image.asset('assets/images/original_bg.png').image,
                                                    image:imgRes=="null"?
                                                    Image.asset('assets/images/ann.jpg').image:
                                                    Image.network(imgRes!).image,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),

                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 5),
                                                  child:Container(
                                                    height: 78,

                                                    child:  Text(
                                                      state.data.postData![index].title.toString(),
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontFamily: 'Myanmar3',
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 7),
                                                  child: Container(
                                                    height: 20,
                                                    child: Text(
                                                      state.data.postData![index].publish_date.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,

                                                      ),
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),
                                          padding: EdgeInsets.all(10),
                                        ),
                                      )
                                  );

                              },
                            );
                        }
                        return SpinKitFadingFour(color: Color(0xff334A52),);
                      }
                  ),
                )
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(10),
                width: 100,
                height: 50,

                child:  GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder:  (BuildContext context) =>
                            AnnouncementListPage()));
                  },
                  child:
                  Center(
                    child: Text('View all', style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.purple900,
                    ),),
                  ),
                ),
              ),
            ),
            buttons(context),
          ],

        ),
      ),

    );
  }

  getImageLink(AnnouncementListLoaded state, int index){
    String str = state.data.postData![index].message.toString();
    String substring = "img";String imgRes;
    if( str.contains(substring)){
      const start = 'src="';
      const end = '">';

      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      imgRes = str.substring(startIndex + start.length, endIndex);
      return imgRes;
    }
    else
    {
      imgRes  =  "null";return imgRes;
    }
  }

  buttons(BuildContext context){
    return Container(

      child:  BlocBuilder<StfPerBloc,StfPerState>(
        bloc: _stfPerBloc,
        builder: (context, state){
          if(state is StfPerLoading){
            return SpinKitFadingFour(color: Color(0xff334A52),);
          }
          else if(state is StfPerError){
            return Container(
                padding: EdgeInsets.only(top: 20,bottom: 20),
                child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
          }
          else if(state is StfPerLoaded){
            String stdAttCanView = state.stfPerModel.stdAtt_can_view.toString();
            String appLevCanView = state.stfPerModel.appLev_can_view.toString();
            return
              Container(
                  child: Column(
                    children: [
                      if(stdAttCanView == "1" && appLevCanView == "1")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                stdAttMarkingCard(state),
                                stdLeaveCard(state),


                              ],
                            ),
                            //Second Row
                            Padding(padding: EdgeInsets.only(top: 10)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                leaveBalanceCard(state),

                              ],
                            ),
                          ],
                        )
                      else if(stdAttCanView == '0' && appLevCanView == '1')
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [

                                stdLeaveCard(state),
                                leaveBalanceCard(state),
                              ],
                            ),
                            //Second Row
                            Padding(padding: EdgeInsets.only(top: 10)),

                          ],
                        )
                      else if(stdAttCanView == '1' && appLevCanView == '0')
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [

                                  stdAttMarkingCard(state),
                                  leaveBalanceCard(state),
                                ],
                              ),
                              //Second Row
                              Padding(padding: EdgeInsets.only(top: 10)),

                            ],
                          )
                        else if(stdAttCanView == '0' && appLevCanView == '0')
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [


                                    leaveBalanceCard(state),
                                  ],
                                ),
                                //Second Row
                                Padding(padding: EdgeInsets.only(top: 10)),

                              ],
                            )
                    ],
                  )

              );
          }
          return SpinKitFadingFour(color: Color(0xff334A52));
        },
      ),
    );
  }

  stdAttMarkingCard(StfPerLoaded state){
    return GestureDetector(
      onTap: ()async{
        print('s att mk');

        var sharedPreference=getIt<SharedPreferenceHelper>();
        sharedPreference.setStdAttCanAdd(state.stfPerModel.stdAtt_can_add.toString());
        sharedPreference.setStdAttCanEdit(state.stfPerModel.stdAtt_can_edit.toString());
        sharedPreference.setStdAttCanDel(state.stfPerModel.stdAtt_can_delete.toString());
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    StudentAttendenceMarking(
                    )));
      },
      child:Card(
        child: Container(

          height: MediaQuery.of(context).size.height*0.18,
          width: MediaQuery.of(context).size.width*0.42,


          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorConstant
                .blue50,

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/user-pen-solid.svg",
                color: Colors.green[800],//asset location
                //svg color
                semanticsLabel: 'SVG From asset folder.',
                width: 60,
                height: 57,
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              Container(

                child:  Text('Student Attendence \nMarking',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                    ColorConstant
                        .black900,
                    fontSize: 16,
                    fontFamily:
                    'Poppins',
                    fontWeight:
                    FontWeight
                        .w500,
                  ),
                ),
              )
            ],
          ),

        ),
      ),
    );
  }

  stdLeaveCard(StfPerLoaded state){
    return GestureDetector(
        onTap: ()async{
          var sharedPreference=getIt<SharedPreferenceHelper>();
          sharedPreference.setAppLeveCanAdd(state.stfPerModel.appLeve_can_add.toString());
          sharedPreference.setAppLeveCanEdit(state.stfPerModel.appLev_can_edit.toString());
          sharedPreference.setAppLeveCanDel(state.stfPerModel.appLev_can_delete.toString());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                StdApplyLeaveAdd(
                  gPickDate : DateFormat('d-MM-yyyy').format(DateTime.now()),
                  gPStatus: "0",

                )
            ),
          );
        },
        child:Card(
          child: Container(

            height: MediaQuery.of(context).size.height*0.18,
            width: MediaQuery.of(context).size.width*0.42,


            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstant
                  .blue50,

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                SvgPicture.asset(
                  "assets/images/person-circle-check-solid.svg",
                  color: Colors.yellow[800],//asset location
                  //svg color
                  semanticsLabel: 'SVG From asset folder.',
                  width: 65,
                  height: 55,
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                BlocProvider<BadgeBloc>(
                  create: (_) => BadgeBloc(getIt<BadgeRepository>()),
                  child: BlocBuilder<BadgeBloc, BadgePageState>(
                      bloc: _badgeBloc,
                      builder: (context, badgeState) {
                        if (badgeState is BadgeLoading) {
                          return Container(
                            width: MediaQuery.of(context).size.width * 0.22,
                            height: 20,
                          );
                        } else if (badgeState is BadgeError) {
                          return Container(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Center(
                                  child: Text(
                                    badgeState.errorMessage,
                                    style: TextStyle(color: Colors.red, fontSize: 15),
                                  )));
                        } else if (badgeState is BadgeLoaded) {
                          String b = badgeState.badgeModel.badge.toString();
                          return  (b == "0")?Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              height: 20,
                          ):Container(
                              width: MediaQuery.of(context).size.width * 0.22,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.red,
                              ),
                              child:  Center(
                                child: Text('Pending '+badgeState.badgeModel.badge.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                    Colors.black,
                                    fontSize: 14,
                                    fontFamily:
                                    'Poppins',

                                  ),
                                ),
                              )
                          );
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width * 0.22,
                          height: 20,
                        );
                      }),
                ),

                Padding(padding: EdgeInsets.only(top: 10)),

                Container(

                  child:  Text('Student Leave \nApproval',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                      ColorConstant
                          .black900,
                      fontSize: 16,
                      fontFamily:
                      'Poppins',
                      fontWeight:
                      FontWeight
                          .w500,
                    ),
                  ),
                )
              ],
            ),

          ),
        )
    );
  }

  leaveBalanceCard(StfPerLoaded state){
    return GestureDetector(
        onTap: ()async{
          Navigator.push(context,
              MaterialPageRoute(builder:  (BuildContext context) =>
                  StaffLeaveBalanceHome(
                  )
              ));

        },
        child:Card(
          margin: EdgeInsets.only(left: 10),
          child: Container(

            height: MediaQuery.of(context).size.height*0.18,
            width: MediaQuery.of(context).size.width*0.42,


            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: ColorConstant
                  .blue50,

            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/newspaper-regular.svg",
                  color: Colors.red[500],
                  //asset location
                  //svg color
                  semanticsLabel: 'SVG From asset folder.',
                  width: 60,
                  height: 60,
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
                Container(

                  child:  Text('Leave/ Leave Balance',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                      ColorConstant
                          .black900,
                      fontSize: 16,
                      fontFamily:
                      'Poppins',
                      fontWeight:
                      FontWeight
                          .w500,
                    ),
                  ),
                )
              ],
            ),

          ),
        )
    );
  }
}
