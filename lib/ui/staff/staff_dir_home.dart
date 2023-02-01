import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/bloc/staff/staff_bloc.dart';
import 'package:smk/bloc/staff/staff_event.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';
import 'package:smk/data/repository/staff_repository.dart';
import 'package:smk/ui/staff/staff_dir_detail.dart';

import '../../bloc/staff/staff_state.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import '../../figma/core/utils/size_utils.dart';


class StaffDirHome extends StatefulWidget {
  @override
  _StaffDirHomeState createState() => _StaffDirHomeState();
}

class _StaffDirHomeState extends State<StaffDirHome> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  String search = 'all';
  StaffBloc _staffBloc =  StaffBloc(getIt<StaffRepository>());

  @override
  void initState() {
    // TODO: implement initState
    _staffBloc.add(FetchStaff(search: search));
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20)),
            SearchContainer(),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 15, right: 15),
                child:
                BlocProvider<StaffBloc>(
                  create: (_) => StaffBloc(getIt<StaffRepository>()),
                  child: BlocBuilder<StaffBloc, StaffState>(
                      bloc:_staffBloc,
                      builder: (context,state){
                        if(state is StaffLoading) {
                          return SpinKitFadingFour(color: Color(0xff334A52),);
                        }
                        else if(state is StaffError){
                          return Container(
                              padding: EdgeInsets.only(top: 20,bottom: 20),
                              child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
                        }
                        else if(state is StaffLoaded){
                          return
                            ListView.builder(
                              scrollDirection: Axis.vertical,
                              // shrinkWrap: true,
                              // physics: ScrollPhysics(),
                              itemCount: state.staffModel.postData!.length,
                              itemBuilder: (BuildContext context, int index){
                                return
                                  Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        list(state,index),
                                        Padding(padding: EdgeInsets.only(top: 13)),

                                      ]);
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
        ));
  }

  SearchContainer() {
    return TextFormField(
      controller: searchController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term) {
        print('term');print(term);
        setState(() {
          if(term == '') search = 'all';
          else search = term;
          print(search);
          _staffBloc.add(FetchStaff(search: search));

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



  list(StaffLoaded state, int index) {
    return
      GestureDetector(
          onTap: () {
            // Navigator.pop(context);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StaffDirDetail(
                      id: state.staffModel.postData![index].id.toString(),
                      name: state.staffModel.postData![index].name.toString(),
                      desgination: state.staffModel.postData![index].designation.toString(),
                      staff_no: state.staffModel.postData![index].staff_no.toString(),
                      dob: state.staffModel.postData![index].dob.toString(),
                      department: state.staffModel.postData![index].department.toString(),
                      contact: state.staffModel.postData![index].emergency_contact_no.toString(),
                      email: state.staffModel.postData![index].email.toString(),
                      gender: state.staffModel.postData![index].gender.toString(),
                      date_of_joining: state.staffModel.postData![index].date_of_joining.toString(),
                      image: state.staffModel.postData![index].image.toString(),
                      path: state.staffModel.postData![index].path.toString(),
                      )));

          },

          child: Container(

            padding: EdgeInsets.only(top: 10,left: 10,bottom: 10),
            decoration: BoxDecoration(
              color: ColorConstant.gray200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: Image.asset('assets/images/original_bg.png').image,

                      image:state.staffModel.postData![index].image.toString()==''?
                      Image.asset('assets/images/person.jpg').image:
                      Image.network(Endpoints.imgbaseUrl+
                          state.staffModel.postData![index].path.toString()+
                          state.staffModel.postData![index].image.toString()).image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                Padding(padding: EdgeInsets.only(left: 15)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.staffModel.postData![index].name.toString(),
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: getFontSize(
                            22,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight:
                          FontWeight.w400,
                        ),),
                      Padding(padding: EdgeInsets.only(top: 14)),
                      Text(state.staffModel.postData![index].designation.toString(),
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight:
                          FontWeight.w100,
                        ),),
                    ],
                  ),
                )

              ],
            ),
          )
      );
  }
}
