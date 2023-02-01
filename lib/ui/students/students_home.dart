import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/bloc/students/student_home/student_home_bloc.dart';
import 'package:smk/bloc/students/student_home/student_home_event.dart';
import 'package:smk/bloc/students/student_home/student_home_state.dart';
import 'package:smk/data/repository/student_repository.dart';
import 'package:smk/ui/students/students_list.dart';
import 'package:smk/ui/students/students_list_forallclass.dart';

import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';

class StudentHome extends StatefulWidget {
  @override
  _StudentHomeState createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  String search = 'all';
  StudentHomeBloc _studentHomeBloc =
      StudentHomeBloc(getIt<StudentRepository>());

  @override
  void initState() {
    // TODO: implement initState
    _studentHomeBloc.add(FetchStudentHome(search: search));
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
            Padding(padding: EdgeInsets.only(top: 20)),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 25, left: 8, right: 8),
                child: BlocProvider<StudentHomeBloc>(
                  create: (_) =>
                      StudentHomeBloc(getIt<StudentRepository>()),
                  child: BlocBuilder<StudentHomeBloc,
                          StudentHomeState>(
                      bloc: _studentHomeBloc,
                      builder: (context, state) {
                        if (state is StudentHomeLoading) {
                          return SpinKitFadingFour(
                            color: Color(0xff334A52),
                          );
                        } else if (state is StudentHomeError) {
                          return Container(
                              padding: EdgeInsets.only(top: 20, bottom: 20),
                              child: Center(
                                  child: Text(
                                state.errorMessage,
                                style:
                                    TextStyle(color: Colors.red, fontSize: 15),
                              )));
                        } else if (state is StudentHomeLoaded) {
                          return state.aList.postData!.length == 0
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
                              :
                          ListView.builder(
                            scrollDirection: Axis.vertical,
                            // shrinkWrap: true,
                            // physics: ScrollPhysics(),
                            itemCount: state.aList.postData!.length,
                            itemBuilder: (BuildContext context, int index) {
                              print('leng');print(state.aList.postData!.length);

                              return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    list(state,index),
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
          else {
            search = term;
            print(search);
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StudentsListForAllClass(
                      search: search,
                      )));
          }
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
        hintText: "Search Name of Student",
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



  list(StudentHomeLoaded state, int index) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width*0.28,
          child: Text(
            state.aList.postData![index].classs.toString(),
            style: TextStyle(color: Colors.black,fontSize: 18,fontFamily: 'ABeeZee',
            ),
          ),
        ),
        Text(
          '-',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontFamily: 'ABeeZee',
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.27,
          child: Text(
            state.aList.postData![index].section.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'ABeeZee',
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.29,
          child: Text(
            "("+state.aList.postData![index].students.toString()+" Students)",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontFamily: 'ABeeZee',
            ),
          ),
        ),
        GestureDetector(
            onTap: () {
              // Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => StudentsList(
                        class_id: state.aList.postData![index].class_id.toString(),
                      section_id: state.aList.postData![index].section_id.toString(),
                      classs: state.aList.postData![index].classs.toString(),
                      section: state.aList.postData![index].section.toString(),)));
            },
            child: Icon(Icons.arrow_forward_ios, color: Colors.black)),
      ],
    );
  }
}
