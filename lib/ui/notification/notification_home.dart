import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smk/bloc/badge/badge.bloc.dart';
import 'package:smk/bloc/badge/badge.event.dart';
import 'package:smk/bloc/staff/staff_bloc.dart';
import 'package:smk/bloc/staff/staff_event.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';
import 'package:smk/data/repository/badge_repository.dart';
import 'package:smk/data/repository/staff_repository.dart';
import 'package:smk/ui/announcements/announcement_detail.dart';
import 'package:smk/ui/staff/staff_dir_detail.dart';

import '../../bloc/announcements/announcement_bloc.dart';
import '../../bloc/announcements/announcement_event.dart';
import '../../bloc/announcements/announcement_state.dart';
import '../../bloc/staff/staff_state.dart';
import '../../bloc/students/std_apply_leave/std_apply_leave_add_noti.dart';
import '../../data/repository/announcement_repository.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import '../../figma/core/utils/size_utils.dart';
import '../home.dart';
import '../staff/staff_leave_balance/staff_leave_balance_home.dart';
import '../students/student_apply_leave/std_apply_leave_home.dart';
import '../timetable/timetable_home.dart';

class NotificationHome extends StatefulWidget {
  int? tabIndex;
  NotificationHome({required this.tabIndex});
  @override
  _NotificationHomeState createState() => _NotificationHomeState();
}

class _NotificationHomeState extends State<NotificationHome> {
  AnnouncementBloc _announcementBloc=AnnouncementBloc(getIt<AnnouncementRepository>());
  BadgeBloc _badgeBloc = BadgeBloc(getIt<BadgeRepository>());
  String pickDate = DateFormat('yyyy-MM-d').format(DateTime.now());
  @override
  void initState() {
    // TODO: implement initState
    _announcementBloc.add(FetchNoti());
    _badgeBloc.add(UpdateBadge(type: "notification"));
    //var sharedPreference=getIt<SharedPreferenceHelper>();
    //sharedPreference.setb("88");
    FirebaseDatabase.instance.ref("users").remove();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Do something here
        print("After clicking the Android Back Button");
        Navigator.push(context,
            MaterialPageRoute(builder:  (BuildContext context) =>
                Home(tabIndex: widget.tabIndex!,
                )
            ));


        return false;
      },
      child: Scaffold(
          backgroundColor: ColorConstant.whiteA700,
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: ColorConstant.whiteA700,
            elevation: 0.0,
            toolbarHeight: 100,
            toolbarOpacity: 0.8,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: Text("Notifications"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,size: 30,),
              tooltip: 'Back Icon',
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder:  (BuildContext context) =>
                        Home(tabIndex: 0,)
                    ));
              },
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45),),
                color: ColorConstant.purple900,
              ),
            ),
          ),
          body: Container(
            margin: EdgeInsets.only(top: 20, left:20, right: 20, bottom: 15),
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorConstant.whiteA700,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45.0),
                )),
            child: BlocProvider<AnnouncementBloc>(
              create: (_) => AnnouncementBloc(getIt<AnnouncementRepository>()),
              child: BlocBuilder<AnnouncementBloc, AnnouncementState>(
                  bloc:_announcementBloc,
                  builder: (context,state){
                    if(state is NotiLoading) {
                      return SpinKitFadingFour(color: Color(0xff334A52),);
                    }
                    else if(state is NotiError){
                      return Container(
                          padding: EdgeInsets.only(top: 20,bottom: 20),
                          child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
                    }
                    else if(state is NotiLoaded){
                      return
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          // shrinkWrap: true,
                          // physics: ScrollPhysics(),
                          itemCount: state.notiModel.notiData!.length,
                          itemBuilder: (BuildContext context, int index){

                            return
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  state.notiModel.notiData![index].same.toString() != "false"?
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10,top: 10),
                                    child: Text(
                                      state.notiModel.notiData![index].same.toString(),
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: ColorConstant.indigo700,
                                        fontSize: 16,
                                        fontFamily: 'ABeeZee',
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ):Container(),
                                  list(state,index),
                                  Padding(padding: EdgeInsets.only(top: 10)),
                                ],
                              );
                          },
                        );
                    }
                    return SpinKitFadingFour(color: Color(0xff334A52),);
                  }
              ),
            ),
          )),
    );
  }

  list(NotiLoaded state, int index) {
    return
      GestureDetector(
          onTap: () {
            print('typeId');print(state.notiModel.notiData![index].type_id.toString());
            if( state.notiModel.notiData![index].type.toString() == "staff_leave_approve"  ){
              Navigator.push(context,
                  MaterialPageRoute(builder:  (BuildContext context) =>
                      StaffLeaveBalanceHome()));
            }
            else if( state.notiModel.notiData![index].type.toString() == "notification"  ){
              Navigator.push(context,
                  MaterialPageRoute(builder:  (BuildContext context) =>
                      AnnouncementDeatil(id: state.notiModel.notiData![index].type_id.toString())));
            }
            else if( state.notiModel.notiData![index].type.toString() == "time_table"  ){
              Navigator.push(context,
                  MaterialPageRoute(builder:  (BuildContext context) =>
                      Home(tabIndex: 1,)));
            }
            else{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>
                    StdApplyLeaveAddNoti(
                      gPickDate : DateFormat('d-MM-yyyy').format(DateTime.now()),
                      gPStatus: "0",id: state.notiModel.notiData![index].type_id.toString(),
                      title: state.notiModel.notiData![index].title.toString(),
                      body: state.notiModel.notiData![index].body.toString(),

                    )
                ),
              );
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(top: 20, left: 30, bottom: 20, right: 20),
            decoration: BoxDecoration(
              color: ColorConstant.red50,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.notiModel.notiData![index].title.toString(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ColorConstant.black900,
                    fontSize:  18,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15)),
                Text(
                  state.notiModel.notiData![index].body.toString(),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: ColorConstant.black90087,
                    fontSize: 18,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ));
  }
}
