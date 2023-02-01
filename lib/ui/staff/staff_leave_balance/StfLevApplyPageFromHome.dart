import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/components/checkbox/gf_checkbox.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:intl/intl.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';

import '../../../bloc/staff_leave/stf_leave_apply/stf_lev_apply_bloc.dart';
import '../../../bloc/staff_leave/stf_leave_apply/stf_lev_apply_event.dart';
import '../../../bloc/staff_leave/stf_leave_apply/stf_lev_apply_state.dart';
import '../../../data/repository/staff_leave_apply_repository.dart';
import '../../../di/components/service_locator.dart';
import '../../../figma/core/utils/color_constant.dart';
import 'package:http/http.dart' as http;

import '../../home.dart';

class StfLevApplyPageFromHome extends StatefulWidget {



  @override
  _StfLevApplyPageStateFromHome createState() => _StfLevApplyPageStateFromHome();
}

class _StfLevApplyPageStateFromHome extends State<StfLevApplyPageFromHome> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _reasonController = TextEditingController();
  String fromDate = DateFormat('d-MM-yyyy').format(DateTime.now());
  String toDate=DateFormat('d-MM-yyyy').format(DateTime.now());
  String applyDate = DateFormat('d-MM-yyyy').format(DateTime.now());
  String leaveDate = DateFormat('d-MM-yyyy').format(DateTime.now());
  String halfLeave="Select";
  List<String> halfLeaveList=["Select","AM","PM"];
  String? leaveType;
  bool half = false;
  FilePickerResult? res;File? file;String? selectFile;


  StfLevApplyBloc _stfLevApplyBloc=StfLevApplyBloc(getIt<StfLevApplyRepository>());

  Future<List<String>> getLeaveTypes() async {
    var baseUrl =
        Endpoints.baseUrl + "staff_leave/getLeaveTypes";

    http.Response response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<String> items = [];
      var jsonData = json.decode(response.body) as List;

      for (var element in jsonData) {
        items.add(element['id'] + '&' + element['type']);
      }
      print(baseUrl);
      print("  items"+items.toString());
      return items;
    } else {
      throw response.statusCode;
    }
  }

  @override
  void initState(){
    _stfLevApplyBloc.add(StfLevApplyStart());

    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Container(

      width: double.infinity,
      decoration: BoxDecoration(
          color: ColorConstant.gray100,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(45.0),
          )),
      child:  SingleChildScrollView(
          child:
          BlocBuilder<StfLevApplyBloc,StfLevApplyState>(
            bloc: _stfLevApplyBloc,
            builder: (context,state){
              if(state is StfLevApplyLoading){
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
              else if(state is StfLevApplyError){
                _stfLevApplyBloc.add(StfLevApplyStart());
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
              else if (state is StfLevApplyLoaded){
                _stfLevApplyBloc.add(StfLevApplyStart());
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
                                    state.success.toString(),style: TextStyle(fontSize: 18,fontFamily: 'Rasa')
                                ),
                                Padding(padding: EdgeInsets.only(top: 30)),
                                GestureDetector(
                                  onTap: (){
                                    if(state.success.toString() == "Success")
                                    {
                                      Navigator.pop(context);
                                      Navigator.push(context,
                                          MaterialPageRoute(builder:  (BuildContext context) =>
                                              Home(tabIndex: 0)
                                          ));

                                    }
                                    else{Navigator.pop(context);
                                    }

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
                  padding: EdgeInsets.only(left: 15,right: 15),
                  margin: EdgeInsets.only(left: 10,right: 10),
                  child: Form(
                    key: _key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 35)),

                        //apply date
                        Text("Apply Date", style:TextStyle(color: Colors.black,
                            fontFamily:'Poppins',fontSize: 18) ,),
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

                                    applyDate =DateFormat('d-MM-yyyy').format(date);
                                  });
                                }, currentTime: DateTime.now());
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.black45,),
                              borderRadius:  BorderRadius.circular(5.0),
                            ),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text("${applyDate.toString()}", style:TextStyle(color: Colors.black,
                                    fontFamily:'Poppins',fontSize: 18) ,)),
                          ),
                        ),

                        Padding(padding: EdgeInsets.only(top: 35)),

                        //Available Leave
                        Text("Avaliable Leave", style:TextStyle(color: Colors.black,
                            fontFamily:'Poppins',fontSize: 18) ,),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        FutureBuilder<List<String>>(
                          future: getLeaveTypes(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!;
                              return  Container(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                height: 50,
                                decoration: BoxDecoration(
                                    color:Colors.grey[100],
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.grey)
                                ),
                                child: DropdownButtonHideUnderline(
                                    child:DropdownButton(
                                      iconEnabledColor: Color(0xff334A52),
                                      iconSize: 30,
                                      isExpanded: true,
                                      // Initial Value
                                      value: leaveType?? data[0],

                                      // Down Arrow Icon
                                      icon: const Icon(Icons.keyboard_arrow_down),

                                      // Array list of items
                                      items: data.map((String items) {
                                        List<String> list = items.split("&");
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(list[1],style:TextStyle(color: Colors.black,
                                              fontFamily:'Poppins',fontSize: 17) ,),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (value){
                                        setState(() {
                                          leaveType=value.toString();
                                          print("value"+value.toString());
                                        });
                                      },
                                    )
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),

                        Padding(padding: EdgeInsets.only(top: 15)),
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              child: GFCheckbox(
                                size: GFSize.LARGE,
                                activeBgColor: ColorConstant.purple900,
                                inactiveIcon: null,
                                //    <-- label
                                value: half,
                                onChanged: (newValue) {
                                  setState(() {
                                    half = newValue!;
                                  });
                                },
                              ),
                            ),
                            Text("Half Day",style:TextStyle(color: Colors.black,
                                fontFamily:'Poppins',fontSize: 17) ,),
                            Padding(padding: EdgeInsets.only(left: 15)),
                            half == true?
                            Expanded(child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    child: Text("AM / PM",
                                      style:TextStyle(color: Colors.black,
                                          fontFamily:'Poppins',fontSize: 17),)
                                ),
                                Padding(padding: EdgeInsets.only(top: 5)),
                                Container(
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color:Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.grey)
                                  ),
                                  child: DropdownButtonHideUnderline(
                                      child:ButtonTheme(
                                          alignedDropdown: true,
                                          child: DropdownButton(
                                            iconEnabledColor: Color(0xff334A52),
                                            iconSize: 30,
                                            isExpanded: true,
                                            value: halfLeave,
                                            onChanged: (value){
                                              setState(() {
                                                halfLeave=value.toString();
                                              });
                                            },
                                            items:halfLeaveList.map((String value){
                                              return new DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value,style:TextStyle(color: Colors.black,
                                                      fontFamily:'Poppins',fontSize: 17),)
                                              );
                                            }).toList(),
                                          )
                                      )
                                  ),
                                ),
                              ],
                            )):Container()
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        half == true?
                        //Leave date
                        Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Text('Leave Date', style:TextStyle(color: Colors.black,
                                  fontFamily:'Poppins',fontSize: 18) ,),
                            ),
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
                                        leaveDate =DateFormat('yyyy-MM-dd').format(date);
                                      });
                                    }, currentTime: DateTime.now());
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color:Colors.black45,),
                                  borderRadius:  BorderRadius.circular(5.0),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("${leaveDate.toString()}",style:TextStyle(color: Colors.black,
                                        fontFamily:'Poppins',fontSize: 17))),
                              ),
                            ),
                          ],
                        ):
                        //from and to date
                        Column(
                          children: [
                            //from date
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child:Text("From Date", style:TextStyle(color: Colors.black,
                                  fontFamily:'Poppins',fontSize: 18) ,),
                            ),
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

                                        fromDate =DateFormat('d-MM-yyyy').format(date);
                                      });
                                    }, currentTime: DateTime.now());
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color:Colors.black45,),
                                  borderRadius:  BorderRadius.circular(5.0),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("${fromDate.toString()}",style:TextStyle(color: Colors.black,
                                        fontFamily:'Poppins',fontSize: 17))),
                              ),
                            ),

                            Padding(padding: EdgeInsets.only(top: 15)),
                            //to date
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child:Text("To Date", style:TextStyle(color: Colors.black,
                                  fontFamily:'Poppins',fontSize: 18) ,),
                            ),
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

                                        toDate =DateFormat('d-MM-yyyy').format(date);
                                      });
                                    }, currentTime: DateTime.now());
                              },
                              child: Container(
                                padding: EdgeInsets.only(left: 10,right: 10),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  border: Border.all(color:Colors.black45,),
                                  borderRadius:  BorderRadius.circular(5.0),
                                ),
                                child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("${toDate.toString()}",style:TextStyle(color: Colors.black,
                                        fontFamily:'Poppins',fontSize: 17))),
                              ),
                            ),
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 25)),

                        //reason
                        Text('Reason',style:TextStyle(color: Colors.black,
                            fontFamily:'Poppins',fontSize: 18) ,),
                        Padding(padding: EdgeInsets.only(top: 15)),
                        Container(
                          width: MediaQuery.of(context).size.width,

                          child: TextFormField(
                            controller: _reasonController,
                            minLines: 1,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'reason',
                              hintStyle: TextStyle(color: Colors.grey,
                                  fontFamily:'Poppins',fontSize: 17),
                              errorStyle:TextStyle(fontFamily:'MyanmarSansPro',fontSize: 17) ,
                              fillColor: Colors.grey[100],
                              filled: true,
                              focusedBorder:OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(color: Colors.black45)
                              ),
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
                        Padding(padding: EdgeInsets.only(top: 20),),
                        Text('Attach Document',style:TextStyle(color: Colors.black,
                            fontFamily:'Poppins',fontSize: 18) ,),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        GestureDetector(
                          onTap: ()async{
                            res = await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg','png', 'docx', 'pdf', 'doc'],);

                            if (res != null) {

                              setState(() {
                                file = File(res!.files.single.path!);
                                selectFile = file!.path;
                              });
                            } else {
                              print("No file selected");
                            }

                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 4),
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            decoration: BoxDecoration(
                              border: Border.all(color:Colors.black45,),
                              borderRadius:  BorderRadius.circular(5.0),
                            ),
                            child: (res != null)?
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text(selectFile!,style:TextStyle(color: Colors.black,
                                    fontFamily:'Poppins',fontSize: 16))):
                            Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.cloud_download,color: Colors.grey[800],),
                                    Text("Choose a File!",style:TextStyle(color: Colors.grey[700],
                                        fontFamily:'Poppins',fontSize: 16))
                                  ],
                                )
                            ),
                          ),
                        ),


                        Padding(padding: EdgeInsets.only(top: 20)),

                        GestureDetector(
                          onTap: () async{

                            int hlev; if(halfLeave == "Select")hlev=0;
                            else if(halfLeave == "AM") hlev = 4;
                            else hlev = 7;
                            String lev;
                            if ( leaveType == null )lev = "1&Annual Leave";
                            else lev = leaveType!;

                            print("selectFile");print(selectFile);
                            if( selectFile == null )
                            {
                              _stfLevApplyBloc.add(StfLevApply(
                                applied_date: applyDate, leave_type: lev,
                                reason: _reasonController.text, from_date: fromDate,to_date: toDate,
                                leavedate: leaveDate, half_leave: hlev,

                              ));
                            }

                            else{
                              _stfLevApplyBloc.add(StfLevApplyWithFile(
                                applied_date: applyDate, leave_type: lev,
                                reason: _reasonController.text, from_date: fromDate,to_date: toDate,
                                leavedate: leaveDate, half_leave: hlev,
                                userfile: File(file!.path),
                              ));
                            }



                            print('apply');print(applyDate);print(lev);
                            print(_reasonController.text);print(fromDate);print(toDate);
                            print(leaveDate);print(hlev);

                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 10,right: 10),
                            height: 55,
                            decoration: BoxDecoration(
                                color: ColorConstant.purple900,
                                borderRadius: BorderRadius.circular(5.0)
                            ),
                            child: Center(child: Text('Apply',
                              style: TextStyle(fontSize: 20,fontFamily: 'Rasa',color: Colors.white),),),
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
