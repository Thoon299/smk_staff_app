import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smk/bloc/students/student_attendence_marking/student_attendence_marking_new/new_bloc.dart';
import 'package:smk/bloc/students/student_attendence_marking/student_attendence_marking_new/new_event.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';
import 'package:smk/data/repository/std_att_marking_new_repository.dart';
import 'package:smk/models/announcements/announcement_list_model.dart';
import 'package:smk/ui/students/student_attendence/student_attendence_marking.dart';

import '../../../bloc/announcements/announcementsList/announcement_list_bloc.dart';
import '../../../bloc/announcements/announcementsList/announcement_list_event.dart';
import '../../../bloc/announcements/announcementsList/announcement_lsit_state.dart';
import '../../../bloc/students/student_attendence_marking/student_attendence_marking_bloc.dart';
import '../../../bloc/students/student_attendence_marking/student_attendence_marking_event.dart';
import '../../../bloc/students/student_attendence_marking/student_attendence_marking_new/new_state.dart';
import '../../../bloc/students/student_attendence_marking/student_attendence_marking_state.dart';
import '../../../data/repository/announcement_repository.dart';
import '../../../data/repository/student_attendence_marking_repository.dart';
import '../../../data/sharedpreference/shared_preference_helper.dart';
import '../../../di/components/service_locator.dart';
import '../../../figma/core/utils/color_constant.dart';
import '../../home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class StudentAttendenceMarkingNew extends StatefulWidget {
  String class_id, section_id, classs, section, atts;
  List<String> valueList;

  StudentAttendenceMarkingNew(
      {required this.class_id,
        required this.section_id,
        required this.classs,
        required this.section, required this.atts, required this.valueList});



  @override
  _StudentAttendenceMarkingNewState createState() =>
      _StudentAttendenceMarkingNewState();
}

class _StudentAttendenceMarkingNewState
    extends State<StudentAttendenceMarkingNew> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String pickDate = DateFormat('d-MM-yyyy').format(DateTime.now());
  NewBloc newBloc =  NewBloc(getIt<StdAttMaringNewRepository>());




  StudentAttendenceMarkingBloc _studentAttendenceMarkingBloc =
  StudentAttendenceMarkingBloc(getIt<StudentAttendenceMarkingRepository>());
  List<String> typeList=[];
  List<String> vList=[];
  List<String> stdSession = [];
  List<String> stdAttId = [];


  @override
  void initState() {
    // TODO: implement initState
    _studentAttendenceMarkingBloc.add(FetchStudentAttendenceMarking(class_id: widget.class_id,
        session_id: widget.section_id, date: pickDate));
    newBloc.add(NewStart());

    String str = widget.atts;
    typeList = str.split(",");
    typeList.removeLast();
    print('init');print(typeList[0]);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String? dropdownSection;

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
          title: Text('Students Attendence Marking'),
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
        body:
        BlocBuilder<NewBloc,NewState>(
          bloc: newBloc,
          builder: (context,state){
            if(state is NewLoading){
              WidgetsBinding.instance?.addPostFrameCallback((_) {
                showDialog(
                    barrierColor: Color(0x00ffffff),
                    context: context,
                    builder: (BuildContext context){
                      return
                        Material(
                          type: MaterialType.transparency,
                          child: Center(
                              child: SpinKitThreeBounce(color: Color(0xff334A52),)
                          ),
                        );
                    }
                );
              });
            }
            else if(state is NewError){
              newBloc.add(NewStart());
              WidgetsBinding.instance?.addPostFrameCallback((_){
                Navigator.pop(context);
                showDialog(
                    context: context,
                    builder: (BuildContext context){
                      return AlertDialog(
                        content:
                        Text(
                            state.errorMessage,style: TextStyle(fontSize: 18,fontFamily: 'Rasa')
                        ),
                      );
                    }
                );
              });
            }
            else if (state is NewLoaded){
              newBloc.add(NewStart());
              WidgetsBinding.instance?.addPostFrameCallback((_){
                Navigator.pop(context);
                showDialog(
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
              });
            }
            return
              listContainer();
          },
        )
    );
  }

  listContainer(){
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
          child:  Form(
            key: _key,
            child: Column(
              children: [
                Container(
                  child: Column(
                    children: [
                      ClassContainer(),
                      SectionContainer(),
                      selectDateContainer(),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      Divider(
                        thickness: 1,
                      ),
                      //Padding(padding: EdgeInsets.only(top: 15)),
                      //attendenceTextContainer(),
                      Padding(padding: EdgeInsets.only(top: 8)),

                    ],
                  ),
                ),

                marked(),
                saveButton(),
                Padding(padding: EdgeInsets.only(top: 5)),
                Expanded(
                    child:
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, left: 5, right: 5, bottom: 13),
                      child: BlocProvider<StudentAttendenceMarkingBloc>(
                        create: (_) =>
                            StudentAttendenceMarkingBloc(getIt<StudentAttendenceMarkingRepository>()),
                        child: BlocBuilder<StudentAttendenceMarkingBloc,
                            StudentAttendenceMarkingState>(
                            bloc: _studentAttendenceMarkingBloc,
                            builder: (context, state) {
                              if (state is StudentAttendenceMarkingLoading) {
                                return SpinKitFadingFour(
                                  color: Color(0xff334A52),
                                );
                              } else if (state is StudentAttendenceMarkingError) {
                                return Container(
                                    padding: EdgeInsets.only(top: 20, bottom: 20),
                                    child: Center(
                                        child: Text(
                                          state.errorMessage,
                                          style:
                                          TextStyle(color: Colors.red, fontSize: 15),
                                        )));
                              } else if (state is StudentAttendenceMarkingLoaded) {
                                int length = state.studentAttendenceMarkingModel.postData!.length;
                                List<String> pList=[];

                                pList.clear();
                                stdSession.clear();
                                stdAttId.clear();
                                if(length != 0){
                                  for(int i= 0;i<length; i++){
                                    pList.add(state.studentAttendenceMarkingModel.postData![i].type.toString());
                                    stdSession.add(state.studentAttendenceMarkingModel.postData![i]
                                        .student_session_id.toString());

                                    if(state.studentAttendenceMarkingModel.postData![i].student_attendence_id != ''){
                                      stdAttId.add(state.studentAttendenceMarkingModel.postData![i]
                                          .student_attendence_id.toString());
                                    }
                                  }
                                  print("listbuilder");print(pList.toString());
                                }



                                return state.studentAttendenceMarkingModel.postData!.length == 0?
                                Container(
                                  height: 200,
                                  child: Center(
                                    child: Text(
                                      "No Students in this class section.",
                                      style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'ABeeZee',
                                      ),
                                    ),
                                  ),
                                ):
                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  // shrinkWrap: true,
                                  // physics: ScrollPhysics(),
                                  itemCount: state.studentAttendenceMarkingModel.postData!.length,
                                  itemBuilder: (BuildContext context, int index) {


                                    return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[

                                          newAttendence(state,index,pList),
                                          Padding(padding: EdgeInsets.only(top: 10)),
                                          Divider(
                                            thickness: 1,
                                          ),
                                          Padding(padding: EdgeInsets.only(top: 10)),
                                        ]);
                                  },
                                );
                              }
                              return SpinKitFadingFour(
                                color: Color(0xff334A52),
                              );
                            }),
                      ),

                    )

                ),
              ],
            ),
          ),
        ));
  }

  marked(){
    return  BlocProvider<StudentAttendenceMarkingBloc>(
      create: (_) =>
          StudentAttendenceMarkingBloc(getIt<StudentAttendenceMarkingRepository>()),
      child: BlocBuilder<StudentAttendenceMarkingBloc,
          StudentAttendenceMarkingState>(
          bloc: _studentAttendenceMarkingBloc,
          builder: (context, state) {
            if (state is StudentAttendenceMarkingLoading) {
              return Container();
            } else if (state is StudentAttendenceMarkingError) {
              return Container(
                 );
            } else if (state is StudentAttendenceMarkingLoaded) {

              return (state.studentAttendenceMarkingModel.postData![0].attendence_type_id == '')?
              Container():Column(
                children: [
                 Row(
                   children: [
                     Icon(Icons.info_outline),
                     Text(
                       'Student Attendence is marked for this day.',
                       textAlign: TextAlign.center,
                       style: TextStyle(
                         color: Colors.black,
                         fontSize: 20,
                         fontFamily: 'ABeeZee',
                       ),
                     ),
                   ],
                 ),
                  Padding(padding: EdgeInsets.only(top: 14))
                ],
              );
            }
            return SpinKitFadingFour(
              color: Color(0xff334A52),
            );
          }),
    );
  }


  newAttendence(StudentAttendenceMarkingLoaded state, int index, List<String> pList) {
    print("newAtt");print(vList.length);print(pList.toString());String v;
    if( vList.length == 0 ) v = pList[index];
    else v = vList[index];


    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.4,
          padding: EdgeInsets.only(left: 5),
          height: 50,

          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              state.studentAttendenceMarkingModel.postData![index].firstname.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            height: 50,
            decoration: BoxDecoration(
                color:ColorConstant.gray200,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey)
            ),
            child: DropdownButtonHideUnderline(
                child:ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton(
                      iconEnabledColor: Color(0xff334A52),
                      iconSize: 30,
                      isExpanded: true,
                      value: v,
                      onChanged: (value){

                        setState(() {
                          if(vList.length == 0){
                            for (var i = 0; i < pList.length; i++) {
                              vList.insert(i, pList[i]);
                            }
                          }

                          pList[index] = value.toString();
                          vList[index]=value.toString();
                          print("newAtt2"+index.toString());print(vList.toString());


                        });
                      },
                      items:typeList.map((String value){
                        return new DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,style: TextStyle(fontFamily:'MyanmarSansPro',fontSize: 17),)
                        );
                      }).toList(),
                    )
                )
            ),
          ),
        )
      ],
    );
  }


  saveButton() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(right: 10),
        child: GestureDetector(
          onTap: () {
            print('save');
            String std_session_str;String vListStr; String stdAttIdStr;

            std_session_str = stdSession.toString().replaceAll("[", "").replaceAll("]", "");

            if(stdAttId.length == 0)  stdAttIdStr = "null";
            else stdAttIdStr = stdAttId.toString().replaceAll("[", "").replaceAll("]", "");

            if(vList.length == 0)  vListStr = "null";
            else vListStr = vList.toString().replaceAll("[", "").replaceAll("]", "");
            print('stdmarkingError');
            print(std_session_str+"   "+stdAttIdStr+"  "+pickDate+"   "+vListStr);

            var sharedPreference=getIt<SharedPreferenceHelper>();
            String stdAttCanAdd = sharedPreference.getStdAttCanAdd.toString();
            if( stdAttCanAdd == "1" ){
              if(_key.currentState!.validate()){
                // doGAPPost();
                newBloc.add(New(student_session_id: std_session_str, student_attendence_id:stdAttIdStr
                    ,date: pickDate,type: vListStr));
              }

              _studentAttendenceMarkingBloc.add(FetchStudentAttendenceMarking(class_id: widget.class_id,
                  session_id: widget.section_id, date: pickDate));
            }
            else{
              showDig();
            }



            // print(selectedClass + "   " + selectedSection + "   " + pickDate);
          },
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
              width: 150,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ColorConstant.purple900,
              ),
              child: Center(
                child: Text('Save Attendence',
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ),
        ));
  }

  attendenceTextContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text('P:Present',
              style: TextStyle(color: Colors.black, fontSize: 18)),
          Padding(padding: EdgeInsets.only(left: 5)),
          Text('A:Absent', style: TextStyle(color: Colors.black, fontSize: 18)),
          Padding(padding: EdgeInsets.only(left: 5)),
          Text('OL:On Leave',
              style: TextStyle(color: Colors.black, fontSize: 18)),
          Padding(padding: EdgeInsets.only(left: 5)),
          Text('L:Late', style: TextStyle(color: Colors.black, fontSize: 18)),
          Padding(padding: EdgeInsets.only(left: 5)),
          Text('H:Half Day',
              style: TextStyle(color: Colors.black, fontSize: 18)),
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

  ClassContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.18,
          padding: EdgeInsets.only(left: 10),
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
          padding: EdgeInsets.only(left: 10),
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

  selectDateContainer() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.18,
          padding: EdgeInsets.only(left: 10),
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
                          vList.clear();
                          _studentAttendenceMarkingBloc.add(FetchStudentAttendenceMarking(class_id: widget.class_id,
                              session_id: widget.section_id, date: pickDate));
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
  Future<List<String>> getAllCategory(String att_id,String att_type) async {
    var baseUrl = Endpoints.baseUrl + "student_dir/getAttendenceTypes";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<String> items = [];
      var jsonData = json.decode(response.body) as List;
      items.add(att_id + '&' + att_type);

      for (var element in jsonData) {
        if( element['id'] != att_id )
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
    print('ddl'+ddl.toString());
    return ddl
        .map((value) => DropdownMenuItem(
      value: value,
      child: Text(value),
    ))
        .toList();

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
