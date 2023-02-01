import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smk/bloc/students/std_apply_leave/std_apply_leave_bloc.dart';
import 'package:smk/ui/students/student_apply_leave/std_apply_leave_add.dart';

import '../../../bloc/students/std_apply_leave/std_apply_leave_edit/stdApplyLeave_edit_bloc.dart';
import '../../../bloc/students/std_apply_leave/std_apply_leave_edit/stdApplyLeave_edit_event.dart';
import '../../../bloc/students/std_apply_leave/std_apply_leave_edit/stdApplyLeave_edit_state.dart';
import '../../../data/repository/std_apply_leave_repository.dart';
import '../../../di/components/service_locator.dart';
import '../../../figma/core/utils/color_constant.dart';

class StdApplyLeaveEditPage extends StatefulWidget {
  String comeFrom;String firstname;
  String student_applyleave_id;
  String from_date;
  String to_date;
  String apply_date;
  String reason;String gPickDate,gPStatus;

  String class_id, section_id, classs, section, atts;
  StdApplyLeaveEditPage({required this.comeFrom, required this.firstname, required this.student_applyleave_id,
    required this.from_date, required this.to_date, required this.apply_date, required this.reason,
    required this.class_id,
    required this.section_id,
    required this.classs,
    required this.section,
    required this.atts, required this.gPStatus, required this.gPickDate});

  @override
  _StdApplyLeaveEditPageState createState() => _StdApplyLeaveEditPageState();
}

class _StdApplyLeaveEditPageState extends State<StdApplyLeaveEditPage> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  String? fromDate;
  String? toDate;
  String? applyDate;

  StdApplyLeaveEditBloc _stdApplyLeaveEditBloc=StdApplyLeaveEditBloc(getIt<StdApplyLeaveRepository>());

  @override
  void initState(){
    _stdApplyLeaveEditBloc.add(StdApplyLeaveEditStart());
   fromDate = widget.from_date;
   toDate = widget.to_date;
   applyDate =  widget.apply_date;
   _reasonController.text = widget.reason;

    super.initState();
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
        title: Text(widget.firstname+"'s Leave Form"),
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
      body: SingleChildScrollView(
          child:
          BlocBuilder<StdApplyLeaveEditBloc,StdApplyLeaveEditState>(
            bloc: _stdApplyLeaveEditBloc,
            builder: (context,state){
              if(state is StdApplyLeaveEditLoading){
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
              else if(state is StdApplyLeaveEditError){
                _stdApplyLeaveEditBloc.add(StdApplyLeaveEditStart());
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
              else if (state is StdApplyLeaveEditLoaded){
                _stdApplyLeaveEditBloc.add(StdApplyLeaveEditStart());
                WidgetsBinding.instance?.addPostFrameCallback((_){
                  Navigator.pop(context);
                  showDialog(
                      barrierDismissible: false,
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) =>
                                            StdApplyLeaveAdd(

                                              gPickDate : widget.gPickDate,
                                              gPStatus: widget.gPStatus,

                                            )
                                        ),
                                      );


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
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 35)),

                        //date
                        Text("From Date", style:TextStyle(color: Color(0xff008066),fontFamily:'MyanmarSansPro',fontSize: 17) ,),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2050, 12, 31), onChanged: (date) {
                                  print('change $date');
                                },
                                onConfirm: (date) {
                                  setState(() {

                                     fromDate =DateFormat('yyyy-MM-dd').format(date);
                                  });
                                }, currentTime: DateTime.now());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.black45,),
                              borderRadius:  BorderRadius.circular(5.0),
                            ),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(" ${fromDate.toString()}")),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top: 35)),

                        //manufacturing date
                        Text("To Date", style:TextStyle(color: Color(0xff008066),fontFamily:'MyanmarSansPro',fontSize: 17) ,),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2050, 12, 31), onChanged: (date) {
                                  print('change $date');
                                },
                                onConfirm: (date) {
                                  setState(() {
                                    toDate =DateFormat('yyyy-MM-dd').format(date);

                                  });
                                }, currentTime: DateTime.now());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.black45,),
                              borderRadius:  BorderRadius.circular(5.0),
                            ),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(" ${toDate.toString()}")),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top: 35)),

                        //expiry date
                        Text('Apply Date', style:TextStyle(color: Color(0xff008066),fontFamily:'MyanmarSansPro',fontSize: 17) ,),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        GestureDetector(
                          onTap: (){
                            DatePicker.showDatePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2000, 1, 1),
                                maxTime: DateTime(2050, 12, 31), onChanged: (date) {
                                  print('change $date');
                                },
                                onConfirm: (date) {
                                  setState(() {
                                   applyDate =DateFormat('yyyy-MM-dd').format(date);
                                  });
                                }, currentTime: DateTime.now());
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 10,right: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.black45,),
                              borderRadius:  BorderRadius.circular(5.0),
                            ),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(" ${applyDate.toString()}")),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top: 35)),

                        //reason
                        Text('Reason', style:TextStyle(color: Color(0xff008066),fontFamily:'MyanmarSansPro',fontSize: 17) ,),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        Container(
                          margin: EdgeInsets.only(left: 10,right: 10),
                          child: TextFormField(
                            controller: _reasonController,
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'reason',
                              hintStyle: TextStyle(color: Colors.grey,fontFamily:'MyanmarSansPro',fontSize: 17),
                              errorStyle:TextStyle(fontFamily:'MyanmarSansPro',fontSize: 17) ,
                              fillColor: Colors.white,
                              filled: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.grey)
                              ),
                            ),
                            validator: (value) {
                              if(value!.length < 1 ) {
                                return 'reason';
                              }
                            },
                          ),
                        ),


                        Padding(padding: EdgeInsets.only(top: 40)),

                        GestureDetector(
                          onTap: () async{
                            if(_key.currentState!.validate()){
                              _stdApplyLeaveEditBloc.add(FormStdApplyLeaveEdit(
                                   student_applyleave_id: widget.student_applyleave_id,
                                from_date: fromDate!,to_date: toDate!, apply_date: applyDate!,
                                reason: _reasonController.text,
                              ));
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.only(left: 20,right: 20),
                            height: 55,
                            decoration: BoxDecoration(
                                color: ColorConstant.purple900,
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Center(child: Text('Update',style: TextStyle(fontSize: 20,fontFamily: 'Rasa',color: Colors.white),),),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top: 30)),
                      ],
                    ),
                  ),
                );
            },
          )
      ),
    );
  }
}
