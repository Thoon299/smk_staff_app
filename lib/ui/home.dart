import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:badges/badges.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/ui/leave/apply_leave.dart';
import 'package:smk/ui/profile/profile.dart';
import 'package:smk/ui/staff/staff_dir_home.dart';
import 'package:smk/ui/staff/staff_leave_balance/StfLevApplyPageFromHome.dart';
import 'package:smk/ui/staff/staff_leave_balance/staff_leave_apply.dart';
import 'package:smk/ui/students/students_home.dart';
import 'package:smk/ui/timetable/timetable_home.dart';

import '../bloc/badge/badge.bloc.dart';
import '../bloc/badge/badge.event.dart';
import '../bloc/badge/badge_page.state.dart';
import '../data/repository/badge_repository.dart';
import '../data/sharedpreference/shared_preference_helper.dart';
import '../di/components/service_locator.dart';
import '../figma/core/utils/color_constant.dart';
import 'auth/login.dart';
import 'dashboard/dashboard.dart';
import 'package:get/get.dart';

import 'notification/notification_home.dart';

class Home extends StatefulWidget {
  int tabIndex;

  Home({required this.tabIndex});

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int? _current;
  String? title;
  String notiBadge="";
  BadgeBloc _badgeBloc = BadgeBloc(getIt<BadgeRepository>());
  int count = 0;
  late Timer timer;int timeVal = 0;

  final selectedItemColor = Colors.black;
  final unSelectedItemColor = Colors.white70;
  final selectedBackGroundColor = Colors.black12;
  final unselectedBackGroundColor = ColorConstant.purple900;

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Dashboard',
      style: optionStyle,
    ),
    Text(
      'Index 1: TimeTable',
      style: optionStyle,
    ),
    Text(
      'Index 2: Students',
      style: optionStyle,
    ),
    Text(
      'Index 3: Staffs',
      style: optionStyle,
    ),
    Text(
      'Index 4: Apply Leave',
      style: optionStyle,
    ),
  ];
  Color _getBgColor(int index) => _current == index
      ? selectedBackGroundColor
      : unselectedBackGroundColor;

  Color _getItemColor(int index) =>
      _current == index ? selectedItemColor : unSelectedItemColor;


  Widget _buildIcon(IconData iconData, String text, int index) => Container(

    width: MediaQuery.of(context).size.width ,
    height: kBottomNavigationBarHeight * 1.1,
    child: Material(
      color: _getBgColor(index),
      child: InkWell(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            Text(
              text,
              style: TextStyle(
                fontSize: 11,
                color: _getItemColor(index),
              ),
            ),
          ],
        ),
        onTap: () => _onTabTapped(index),
      ),
    ),
  );

  List<Widget> _children = [
    Dashboard(),
    TimeTable(),
    StudentHome(),
    StaffDirHome(),
    StfLevApplyPageFromHome(),
  ];
  addValue(){
    timeVal++;
  }Future<dynamic> _firebaseMessagingBackgroundHandler(RemoteMessage msg) async {
    print('home background msg');


  }

  @override
  void initState() {
    // TODO: implement initState
    title = "SMK Private School";
    _current = widget.tabIndex;
    _badgeBloc.add(FetchBadge(type: "notification"));

    FirebaseDatabase.instance
        .ref("users")
        .onValue
        .listen((event) {
      setState(() {
        _badgeBloc.add(FetchBadge(type: "notification"));

      });
      // process event
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {

      print('Message clicked!  '+message.notification!.body.toString());
      setState(() {
        _badgeBloc.add(FetchBadge(type: "notification"));
      });
      Navigator.push(context,
          MaterialPageRoute(builder:  (BuildContext context) =>
              NotificationHome(tabIndex:_current)
          ));

    });
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("message recieved");


      setState(() {
        _badgeBloc.add(FetchBadge(type: "notification"));
      });


      if ( count == 0 ){
        ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
          content: Container(
            height: 35,
            padding: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications,
                  color: Colors.white,
                ),
                Padding(padding: EdgeInsets.only(right: 5)),
                Text(
                  message.notification!.title.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.blue[600],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).size.height - 160,
          ),
        ));
        setState(() {
          count++;
        });
        print(count);
      }



    });

    super.initState();
  }

  void _onTabTapped(int index) {
    setState(() {
      title = index == 1
          ? 'Time Table'
          : index == 2
          ? 'Students Directory'
          : index == 3
          ? 'Staffs'
          : index == 4
          ? 'Staff Leave Apply': 'SMK Private School';
      _current = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Do something here
        print("After clicking the Android Back Button");
        if(_current != 0){

          Navigator.push(context,
              MaterialPageRoute(builder:  (BuildContext context) =>
                  Home(tabIndex: 0,
                  )
              ));
        }
        else SystemNavigator.pop();


        return false;
      },
      child: Scaffold(
        backgroundColor: ColorConstant.gray100,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: ColorConstant.gray100,
          elevation: 0.0,
          toolbarHeight: 95,
          toolbarOpacity: 0.8,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Container(
                  width: 65,
                  height: 60,
                  margin: EdgeInsets.only(right: 5,top: 20,bottom: 20),

                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: Image.asset('assets/images/original_bg.png').image,
                      image: Image.asset('assets/images/smk_app_icon.png').image,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Text(title!),
              ],
            ),
          ),
          actions: <Widget>[


            IconButton(
              icon: Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,


                    child: Center(
                      child:  Icon(
                        Icons.notifications,
                        size: 30,
                      ),
                    ),
                  ),
                  BlocProvider<BadgeBloc>(
                    create: (_) => BadgeBloc(getIt<BadgeRepository>()),
                    child: BlocBuilder<BadgeBloc, BadgePageState>(
                        bloc: _badgeBloc,
                        builder: (context, state) {
                          if (state is BadgeLoading) {
                            return Container();
                          } else if (state is BadgeError) {
                            return Container(
                                padding: EdgeInsets.only(top: 20, bottom: 20),
                                child: Center(
                                    child: Text(
                                      state.errorMessage,
                                      style: TextStyle(color: Colors.red, fontSize: 15),
                                    )));
                          } else if (state is BadgeLoaded) {

                            return state.badgeModel.badge.toString() == "0"?
                            Positioned(
                              right: 0,
                              top: 0,
                              child:  Container(
                                  margin: EdgeInsets.only(top: 10),
                                  height: 25,
                                  decoration: new BoxDecoration(

                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child: Center(
                                    child: new Text(
                                      "",
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            ):
                            Positioned(
                              right: 0,
                              top: 0,
                              child:  Container(
                                  margin: EdgeInsets.only(top: 10),
                                  padding: EdgeInsets.only(left: 3,right: 3),
                                  height: 25,
                                  decoration: new BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                  child:  Center(
                                    child: new Text(
                                      state.badgeModel.badge.toString(),
                                      style: new TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                              ),
                            );
                          }
                          return Container();
                        }),
                  ),


                ],
              ),
              tooltip: 'Notification Icon',
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder:  (BuildContext context) =>
                        NotificationHome(tabIndex:_current)));
              },
            ),

            /*IconButton(
            icon: Badge(
              position: BadgePosition.topEnd(top: -10, end: -5),
              toAnimate: false,
              shape: BadgeShape.circle,
              badgeColor: Colors.indigoAccent,
              borderRadius: BorderRadius.circular(5),
              badgeContent: BlocProvider<BadgeBloc>(
                create: (_) => BadgeBloc(getIt<BadgeRepository>()),
                child: BlocBuilder<BadgeBloc, BadgePageState>(
                    bloc: _badgeBloc,
                    builder: (context, state) {
                      if (state is BadgeLoading) {
                        return Container();
                      } else if (state is BadgeError) {
                        return Container(
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            child: Center(
                                child: Text(
                              state.errorMessage,
                              style: TextStyle(color: Colors.red, fontSize: 15),
                            )));
                      } else if (state is BadgeLoaded) {
                        notiBadge = '1';

                        return Text(notiBadge.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 13));
                      }
                      return Container();
                    }),
              ),
              child: Icon(
                Icons.notifications,
                size: 30,
              ),
            ),
            tooltip: 'Notification Icon',
            onPressed: () {},
          ),*/
            //IconButton
            IconButton(
              icon: const Icon(
                Icons.person,
                size: 30,
              ),
              tooltip: 'Person Icon',
              onPressed: () async{
              /*  FirebaseDatabase database = FirebaseDatabase.instance;

                DatabaseReference userRef = FirebaseDatabase.instance.ref('users');
                userRef.child('testing').push().set({'testing1': 'hello', 'testing2': 'bye'}); */

                Navigator.push(context,
                    MaterialPageRoute(builder:  (BuildContext context) =>
                        Profile()
                    ));

              },
            ),
            //IconButton
          ],

          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
              ),
              color: ColorConstant.purple900,
            ),
          ),
        ),
        body: Container(
          color: ColorConstant.purple900,
          child: _children[_current!],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _buildIcon(
                Icons.dashboard,
                'Dashboard',
                0,
              ),
              label: "Dashboard",

            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                Icons.table_view_sharp,
                'TimeTable',
                1,
              ),
              label: "TimeTable",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                Icons.people_alt_rounded,
                'Students',
                2,
              ),
              label: "Students",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                Icons.people_outline_rounded,
                'Staffs',
                3,
              ),
              label: "Staffs",
            ),
            BottomNavigationBarItem(
              icon: _buildIcon(
                Icons.add_card,
                'Apply Leave',
                4,
              ),
              label: "Apply Leave",
            ),
          ],
          currentIndex: _current!,
          selectedItemColor: selectedItemColor,
          unselectedItemColor: unSelectedItemColor,
        ),
      ),
    );
  }



}
