import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smk/bloc/class_sections/class_sections_bloc.dart';
import 'package:smk/bloc/class_sections/class_sections_event.dart';
import 'package:smk/bloc/class_sections/class_sections_state.dart';
import 'package:smk/data/repository/class_sections_repository.dart';
import 'package:smk/ui/students/student_apply_leave/std_apply_leave_add.dart';
import 'package:smk/ui/students/student_attendence/student_attendence_marking_new.dart';

import '../../../bloc/badge/badge.bloc.dart';
import '../../../bloc/badge/badge.event.dart';
import '../../../data/repository/badge_repository.dart';
import '../../../data/sharedpreference/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
import '../../../figma/core/utils/color_constant.dart';
import '../../home.dart';

class StdApplyLeaveHome extends StatefulWidget {
  @override
  _StdApplyLeaveHomeState createState() =>
      _StdApplyLeaveHomeState();
}

class _StdApplyLeaveHomeState extends State<StdApplyLeaveHome> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  String search = 'all';
  ClassSectionsBloc _classSectionsBloc=ClassSectionsBloc(getIt<ClassSectionsRepository>());
  var sharedPreference=getIt<SharedPreferenceHelper>();
  BadgeBloc _badgeBloc = BadgeBloc(getIt<BadgeRepository>());


  @override
  void initState() {
    // TODO: implement initState
    _classSectionsBloc.add(FetchClassSections(search: search));
    _badgeBloc.add(UpdateBadge(type: "student_applyleave"));
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
      // Do something here
      print("After clicking the Android Back Button");
      Navigator.push(context,
          MaterialPageRoute(builder:  (BuildContext context) =>
              Home(tabIndex:0,
              )
          ));


      return false;
    },
    child:Scaffold(
        backgroundColor: ColorConstant.gray100,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: ColorConstant.gray100,
          elevation: 0.0,
          toolbarHeight: 95,
          toolbarOpacity: 0.8,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text('Students Leave Approval'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            tooltip: 'Back Icon',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder:  (BuildContext context) =>
                      Home(tabIndex: 0,
                      )
                  ));
            },
          ),
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
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
                color: ColorConstant.gray100,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45.0),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[

                searchContainer(),
                Padding(padding: EdgeInsets.only(top: 20)),
                Expanded(
                  child:Container(
                    margin: EdgeInsets.only(top: 15,left: 10,right: 10,bottom: 8),
                    child: BlocProvider<ClassSectionsBloc>(
                      create: (_) => ClassSectionsBloc(getIt<ClassSectionsRepository>()),
                      child: BlocBuilder<ClassSectionsBloc, ClassSectionsState>(
                          bloc:_classSectionsBloc,
                          builder: (context,state){
                            if(state is ClassSectionsLoading) {
                              return SpinKitFadingFour(color: Color(0xff334A52),);
                            }
                            else if(state is ClassSectionsError){
                              return Container(
                                  padding: EdgeInsets.only(top: 20,bottom: 20),
                                  child: Center(child: Text(state.errorMessage,style:
                                  TextStyle(color: Colors.red,fontSize: 15),)));
                            }
                            else if(state is ClassSectionsLoaded){
                              int length = state.classSectionsModel.postData!.length;
                              double divide = (length / 2) ;
                              int res = divide.ceil();
                              return
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  // shrinkWrap: true,
                                  // physics: ScrollPhysics(),
                                  itemCount: res,
                                  itemBuilder: (BuildContext context, int index){
                                    int length = state.classSectionsModel.postData!.length;
                                    return
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            firCard(state,index),
                                            Padding(padding: EdgeInsets.only(right: 13)),
                                            secCard(state,index),
                                          ]
                                      );
                                  },
                                );
                            }
                            return SpinKitFadingFour(color: Color(0xff334A52),);
                          }
                      ),
                    ),
                  ),
                )


              ],
            )
        )

    ));
  }
  firCard(ClassSectionsLoaded state ,int index){
    int firIndex =  index + index;
    return  GestureDetector(
        onTap: () {
          print('fi');
          List<String> valueList=[];
          for(int i= 0;i<7; i++){
            valueList.add("မျိုးစေ့");
          }
          print("post list");print(valueList.toString());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                StdApplyLeaveAdd(
                /*  class_id: state.classSectionsModel.postData![firIndex].class_id.toString(),
                  section_id: state.classSectionsModel.postData![firIndex].section_id.toString(),
                  classs: state.classSectionsModel.postData![firIndex].classs.toString(),
                  section: state.classSectionsModel.postData![firIndex].section.toString(),
                  atts: state.classSectionsModel.postData![firIndex].atts.toString(),*/
                  gPickDate : DateFormat('d-MM-yyyy').format(DateTime.now()),
                  gPStatus: "0",

                )
            ),
          );

        },
        child:
        Card(
          color: ColorConstant.red100,
          margin: EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            //set border radius more than 50% of height and width to make circle
          ),
          child: Container(

            width: MediaQuery.of(context).size.width * 0.42,
            height: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.classSectionsModel.postData![firIndex].classs.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  state.classSectionsModel.postData![firIndex].section.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

          ),
        )
    );
  }

  secCard(ClassSectionsLoaded state , int index){
    int secIndex = index + index + 1;
    int length = state.classSectionsModel.postData!.length;

    return secIndex == length ? Container(): GestureDetector(
        onTap: () {
          List<String> valueList=[];
          for(int i= 0;i<7; i++){
            valueList.add("မျိုးစေ့");
          }
          print("post list");print(valueList.toString());
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                StdApplyLeaveAdd(
                  /*class_id: state.classSectionsModel.postData![secIndex].class_id.toString(),
                  section_id: state.classSectionsModel.postData![secIndex].section_id.toString(),
                  classs: state.classSectionsModel.postData![secIndex].classs.toString(),
                  section: state.classSectionsModel.postData![secIndex].section.toString(),
                  atts: state.classSectionsModel.postData![secIndex].atts.toString(),*/

                  gPickDate : DateFormat('d-MM-yyyy').format(DateTime.now()),
                  gPStatus: "0",
                )
            ),
          );

        },
        child:
        Card(
          color: ColorConstant.blue50,
          margin: EdgeInsets.only(bottom: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            //set border radius more than 50% of height and width to make circle
          ),
          child: Container(

            width: MediaQuery.of(context).size.width * 0.43,
            height: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  state.classSectionsModel.postData![secIndex].classs.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                Text(
                  state.classSectionsModel.postData![secIndex].section.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),

          ),
        )
    );
  }

  searchContainer() {
    return TextFormField(
      controller: searchController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        print('term');print(term);
        setState(() {
          if(term == '') search = 'all';
          else search = term;
          print(search);
          _classSectionsBloc.add(FetchClassSections(search: search));
        });
      },
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.gray200, width: 5.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorConstant.gray200, width: 5.0),
          borderRadius: BorderRadius.circular(25.0),
        ),
        fillColor: ColorConstant.gray200,
        filled: true,
        hintText: "Search",
        prefixIcon: Icon(Icons.search, color: Colors.black),
        suffixIcon: InkWell(
          onTap: () {
            searchController.clear();
            setState(() {
              search = 'all';
            });
          },
          child: Icon(Icons.clear, color: Colors.black),
        ),
      ),
      validator: (value) {
        if (value!.length < 1) {
          return 'Enter Text';
        }
      },
    );
  }
}
