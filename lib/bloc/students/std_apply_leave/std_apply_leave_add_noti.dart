import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';
import 'package:smk/ui/students/student_apply_leave/std_apply_leave_edit.dart';

import '../../../bloc/students/std_apply_leave/std_apply_leave_bloc.dart';
import '../../../bloc/students/std_apply_leave/std_apply_leave_event.dart';
import '../../../bloc/students/std_apply_leave/std_apply_leave_state.dart';
import '../../../data/repository/std_apply_leave_repository.dart';
import '../../../data/sharedpreference/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
import '../../../figma/core/utils/color_constant.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StdApplyLeaveAddNoti extends StatefulWidget {
  String  gPickDate, gPStatus, id, title, body;

  StdApplyLeaveAddNoti(
      {required this.gPickDate, required this.gPStatus, required this.id,
      required this.title, required this.body});

  @override
  _StdApplyLeaveAddNotiState createState() => _StdApplyLeaveAddNotiState();
}

class _StdApplyLeaveAddNotiState extends State<StdApplyLeaveAddNoti> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? pickDate;


  StdApplyLeaveBloc _stdApplyLeaveBloc =
  StdApplyLeaveBloc(getIt<StdApplyLeaveRepository>());

  @override
  void initState() {
    // TODO: implement initState
    pickDate = widget.gPickDate;


    _stdApplyLeaveBloc.add(FetchStdApplyLeave(
      date: pickDate!,
      id: widget.id,
    ));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.whiteA700,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: ColorConstant.whiteA700,
        elevation: 0.0,
        toolbarHeight: 95,
        toolbarOpacity: 0.8,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 30,
          ),
          tooltip: 'Back Icon',
          onPressed: () {
            Navigator.pop(context);
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
      body: listContainer(),
    );
  }

  listContainer() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: ColorConstant.whiteA700,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(45.0),
            )),
        child: Container(
          margin: EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 15),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Icon(Icons.notifications,size: 30,),
                    Padding(padding: EdgeInsets.only(right: 8)),
                    Expanded(child: Text(
                      widget.body,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),)

                  ],
                ),
              ),

              Padding(padding: EdgeInsets.only(top: 50)),
              dropdownContainer(),
              Padding(padding: EdgeInsets.only(top: 15)),
              Divider(
                thickness: 1,
              ),
              listHeaderContainer(),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Expanded(
                  child: Container(
                    child: BlocProvider<StdApplyLeaveBloc>(
                      create: (_) =>
                          StdApplyLeaveBloc(getIt<StdApplyLeaveRepository>()),
                      child: BlocBuilder<StdApplyLeaveBloc, StdApplyLeaveState>(
                          bloc: _stdApplyLeaveBloc,
                          builder: (context, state) {
                            if (state is StdApplyLeaveLoading) {
                              return SpinKitFadingFour(
                                color: Color(0xff334A52),
                              );
                            } else if (state is StdApplyLeaveError) {
                              return Container(
                                  padding: EdgeInsets.only(top: 20, bottom: 20),
                                  child: Center(
                                      child: Text(
                                        state.errorMessage,
                                        style:
                                        TextStyle(color: Colors.red, fontSize: 15),
                                      )));
                            } else if (state is StdApplyLeaveLoaded) {
                              return state.stdApplyLeaveModel.postData!.length == 0
                                  ? Container(
                                height: 200,
                                child: Center(
                                  child: Text(
                                    "NO DATA.",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontFamily: 'ABeeZee',
                                    ),
                                  ),
                                ),
                              )
                                  : ListView.builder(
                                scrollDirection: Axis.vertical,
                                // shrinkWrap: true,
                                // physics: ScrollPhysics(),
                                itemCount:
                                state.stdApplyLeaveModel.postData!.length,
                                itemBuilder:
                                    (BuildContext context, int index) {
                                  return Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        listBodyContainer(state, index),
                                        Divider(
                                          thickness: 1,
                                        ),
                                      ]);
                                },
                              );
                            }
                            return SpinKitFadingFour(
                              color: Color(0xff334A52),
                            );
                          }),
                    ),
                  ))
            ],
          ),
        ));
  }

  listHeaderContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 2, right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 23,
            color: Colors.orange,

          ),
          Expanded(
            child: Container(

              child: Text(
                'Name',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              'From Date',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              'To Date',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.15,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              'Status',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Container(
              child: Text(
                'Action',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ))

        ],
      ),
    );
  }

  listBodyContainer(StdApplyLeaveLoaded state, int index) {
    String status = state.stdApplyLeaveModel.postData![index].status.toString();
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 5, right: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,

        children: [
          GestureDetector(
            onTap: () {
              showInfoDig(state,index);
            },
            child:
            Container(
              width: 25,

              child: Icon(Icons.info_outline,size: 25,),
            ),
          ),
          Expanded(
            child: Container(

              child: Text(
                state.stdApplyLeaveModel.postData![index].firstname.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),

          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              state.stdApplyLeaveModel.postData![index].from_date.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 14),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              state.stdApplyLeaveModel.postData![index].to_date.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.08,
            margin:  EdgeInsets.only(right: 17,left: 15),
            height: 20,
            color: (status == "0")?ColorConstant.orangeA100:Colors.green[400],
          ),
          status == "0"?
          Container(
              width: MediaQuery.of(context).size.width * 0.12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  GestureDetector(
                    onTap: () {
                      var sharedPreference=getIt<SharedPreferenceHelper>();
                      String appLevCanEdit = sharedPreference.getAppLeveCanEdit.toString();
                      if( appLevCanEdit == "1" ){
                        _stdApplyLeaveBloc.add(UpdateStdApplyLeaveStatus(
                            student_applyleave_id: state.stdApplyLeaveModel.postData![index].student_applyleave_id.toString(),
                            status: "1"));

                        setState(() {

                          _stdApplyLeaveBloc.add(FetchStdApplyLeave(
                              date: pickDate!,
                            id: widget.id,));
                        });
                        showDialogs(context);
                      }
                      else{
                        showDig();
                      }



                    },
                    child:Icon(
                      Icons.approval,
                      size: 25,
                    ),
                  )

                  //edit
                  /* GestureDetector(
                    onTap: () {
                      var sharedPreference=getIt<SharedPreferenceHelper>();
                      String appLevCanEdit = sharedPreference.getAppLeveCanEdit.toString();
                      if( appLevCanEdit == "1" ){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) =>
                              StdApplyLeaveEditPage(
                                comeFrom: "StdApplyLeave",
                                class_id: widget.class_id,
                                section_id: widget.section_id,
                                classs: widget.classs,
                                section: widget.section,
                                atts: widget.atts,
                                gPickDate : pickDate!,
                                gPStatus: pStatus!,

                                firstname: state.stdApplyLeaveModel.postData![index].firstname.toString(),
                                from_date: state.stdApplyLeaveModel.postData![index].from_date.toString(),
                                to_date: state.stdApplyLeaveModel.postData![index].to_date.toString(),
                                apply_date: state.stdApplyLeaveModel.postData![index].apply_date.toString(),
                                reason: state.stdApplyLeaveModel.postData![index].reason.toString(),
                                student_applyleave_id: state.stdApplyLeaveModel.postData![index].student_applyleave_id.toString(),

                              )
                          ),
                        );
                      }
                      else{
                        showDig();
                      }


                    },
                    child:Icon(
                      Icons.edit,
                      size: 19,
                    ),
                  ),*/
                  //delete
                  /* GestureDetector(
                    onTap: () {


                    },
                    child: Icon(
                      Icons.delete,
                      size: 19,
                    )
                  ),*/
                ],
              )):Container(

              width: MediaQuery.of(context).size.width * 0.12,

              child:Text(
                '_',textAlign: TextAlign.center,
              )
          )
        ],
      ),
    );
  }

  showDialogs(BuildContext context){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Success',style: TextStyle(fontSize: 18,fontFamily: 'Rasa')
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color(0xff334A52),
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Center(child: Text('OK',style: TextStyle(fontSize: 20,fontFamily: 'Rasa',color: Colors.white),),),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                ],
              )
          );
        }
    );
  }

  dropdownContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 25, right: 10),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 25,
            color: Colors.green[400],
          ),
          Padding(padding: EdgeInsets.only(left: 10)),
          Text(
            'Approve',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 10)),
          Container(
            width: 35,
            height: 25,
            color: ColorConstant.orangeA100,
          ),
          Padding(padding: EdgeInsets.only(left: 19)),
          Text(
            'Pending',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1)),

        ],
      ),
    );
  }

  searchButton() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () {
            print('searchbtn');
            // print(selectedClass + "   " + selectedSection + "   " + pickDate);
          },
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorConstant.purple900,
              ),
              child: Center(
                child: Text('Search',
                    style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
          ),
        ));
  }
/*
  ClassContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.18,

          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Class',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.04,
          height: 50,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              ':',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 15)),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.classs,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'ABeeZee',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  SectionContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.18,

          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Section',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.04,
          height: 50,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              ':',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 15)),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10),
            height: 50,
            padding: EdgeInsets.only(left: 15, right: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.section,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'ABeeZee',
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
*/
  selectDateContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          width: MediaQuery.of(context).size.width * 0.18,

          height: 50,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Date',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'ABeeZee',
                  fontWeight: FontWeight.w700
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.04,
          height: 50,
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              ':',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: 'ABeeZee',
              ),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 15)),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                height: 50,
                padding: EdgeInsets.only(left: 15, right: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "${pickDate.toString()}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'ABeeZee',
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(2000, 1, 1),
                      maxTime: DateTime(2050, 12, 31), onChanged: (date) {
                        print('change $date');
                      }, onConfirm: (date) {
                        setState(() {
                          pickDate = DateFormat('d-MM-yyyy').format(date);
                          _stdApplyLeaveBloc.add(FetchStdApplyLeave(
                              date: pickDate!,id: widget.id,));
                        });
                      }, currentTime: DateTime.now());
                },
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  height: 40,
                  width: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.grey[400],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.date_range_rounded,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<List<String>> getAllCategory(String att_id, String att_type) async {
    var baseUrl =
        Endpoints.baseUrl + "student_dir/getAttendenceTypes";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<String> items = [];
      var jsonData = json.decode(response.body) as List;
      items.add(att_id + '&' + att_type);

      for (var element in jsonData) {
        if (element['id'] != att_id)
          items.add(element['id'] + '&' + element['type']);
      }
      print(baseUrl);
      print("  items");
      return items;
    } else {
      throw response.statusCode;
    }
  }

  List<DropdownMenuItem<String>> _dropDownItem() {
    List<String> ddl = ["NONE", "1 YEAR", "2 YEAR"];
    print('ddl' + ddl.toString());
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList();
  }

  showInfoDig(StdApplyLeaveLoaded state, int index){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content:
              Container(
                width: MediaQuery.of(context).size.width,

                child:  Column(
                  mainAxisSize: MainAxisSize.min,

                  children: [
                    Text(
                        state.stdApplyLeaveModel.postData![index].firstname.toString()+"'s Leave",
                        style: TextStyle(fontSize: 18,fontFamily: 'Rasa',fontWeight: FontWeight.bold)
                    ),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Divider(thickness: 1,),
                    Padding(padding: EdgeInsets.only(top: 5)),
                    Row(
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width*0.22,

                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "Apply Date",
                                  style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                              ),
                            )
                        ),
                        Text(
                            ":   ",
                            style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                        ),

                        Text(
                            state.stdApplyLeaveModel.postData![index].apply_date.toString(),
                            style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                        ),
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(

                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width*0.22,

                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "Class",
                                  style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                              ),
                            )
                        ),
                        Text(
                            ":   ",
                            style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                        ),
                        Expanded(child:  Text(
                            state.stdApplyLeaveModel.postData![index].class_name.toString(),
                            style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                        ),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(

                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width*0.22,

                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                  "Section",
                                  style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                              ),
                            )
                        ),
                        Text(
                            ":   ",
                            style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                        ),
                        Expanded(child:  Text(
                            state.stdApplyLeaveModel.postData![index].section_name.toString(),
                            style: TextStyle(fontSize: 18,fontFamily: 'Rasa',)
                        ),)
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);

                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        height: 40,
                        decoration: BoxDecoration(
                            color: Color(0xff334A52),
                            borderRadius: BorderRadius.circular(5.0)
                        ),
                        child: Center(child: Text('OK',style: TextStyle(fontSize: 20,fontFamily: 'Rasa',color: Colors.white),),),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                  ],
                ),
              )
          );
        }
    );
  }

  showDig(){
    return showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              content:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'Sorry,You are not allowed for this action.',style: TextStyle(fontSize: 18,fontFamily: 'Rasa')
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  GestureDetector(
                    onTap: (){
                      Navigator.pop(context);

                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20,right: 20),
                      height: 40,
                      decoration: BoxDecoration(
                          color: Color(0xff334A52),
                          borderRadius: BorderRadius.circular(5.0)
                      ),
                      child: Center(child: Text('OK',style: TextStyle(fontSize: 20,fontFamily: 'Rasa',color: Colors.white),),),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                ],
              )
          );
        }
    );
  }
}
