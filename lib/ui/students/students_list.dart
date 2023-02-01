import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/bloc/students/student_list/student_list_bloc.dart';
import 'package:smk/bloc/students/student_list/student_list_event.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';
import 'package:smk/data/repository/student_repository.dart';
import 'package:smk/ui/dashboard/dashboard.dart';
import 'package:smk/ui/home.dart';
import 'package:smk/ui/students/student_detail.dart';
import 'package:smk/ui/students/students_home.dart';

import '../../bloc/students/student_list/student_list_state.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';

class StudentsList extends StatefulWidget {
  String class_id;
  String section_id;
  String classs;
  String section;
  StudentsList({required this.class_id,required this.section_id, required this.classs, required this.section});

  @override
  _StudentsListState createState() => _StudentsListState();

}

class _StudentsListState extends State<StudentsList> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  StudentListBloc _studentListBloc=StudentListBloc(getIt<StudentRepository>());
  var sharedPreference=getIt<SharedPreferenceHelper>();
  String search = "all";


  @override
  void initState() {
    // TODO: implement initState
    _studentListBloc.add(FetchStudentList(class_id: widget.class_id, section_id: widget.section_id,search: search));
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Do something here

          Navigator.push(context,
              MaterialPageRoute(builder:  (BuildContext context) =>
                  Home(tabIndex: 2,
                  )
              ));

          return false;
        },
        child: Scaffold(
            backgroundColor: ColorConstant.gray100,
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: ColorConstant.bluegray200,
              elevation: 0.0,
              toolbarHeight: 95,
              toolbarOpacity: 0.8,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              title: Text('Students Directory'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back,size: 30,),
                tooltip: 'Back Icon',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder:  (BuildContext context) =>
                          Home(tabIndex: 2,)
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
                    headContainer(),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    SearchContainer(),
                    Padding(padding: EdgeInsets.only(top: 20)),
                    Expanded(
                      child:Container(
                        margin: EdgeInsets.only(top: 15,left: 17,right: 17,bottom: 8),
                        child: BlocProvider<StudentListBloc>(
                          create: (_) => StudentListBloc(getIt<StudentRepository>()),
                          child: BlocBuilder<StudentListBloc, StudentListState>(
                              bloc:_studentListBloc,
                              builder: (context,state){
                                if(state is StudentListLoading) {
                                  return SpinKitFadingFour(color: Color(0xff334A52),);
                                }
                                else if(state is StudentListError){
                                  return Container(
                                      padding: EdgeInsets.only(top: 20,bottom: 20),
                                      child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
                                }
                                else if(state is StudentListLoaded){
                                  int length = state.aList.postData!.length;
                                  double divide = (length / 2) ;
                                  int res = divide.ceil();
                                  return
                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      // shrinkWrap: true,
                                      // physics: ScrollPhysics(),
                                      itemCount: res,
                                      itemBuilder: (BuildContext context, int index){
                                        int length = state.aList.postData!.length;
                                        return
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                firCard(state,index),
                                                Padding(padding: EdgeInsets.only(right: 12)),
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



  firCard(StudentListLoaded state ,int index){
    int firIndex =  index + index;
    return  GestureDetector(
        onTap: () {
          print('fi');
          Navigator.push(
              context,
              MaterialPageRoute(builder:  (BuildContext context) =>
                  StudentDetail(student_id: state.aList.postData![firIndex].id.toString(),
                    name: state.aList.postData![firIndex].firstname.toString(),
                    gender: state.aList.postData![firIndex].gender.toString(),
                    admission_no: state.aList.postData![firIndex].admission_no.toString(),
                    image: state.aList.postData![firIndex].image.toString(),
                    classs: widget.classs,section: widget.section,
                    class_id: widget.class_id, section_id: widget.section_id,
                  )
              )
          );

        },
        child:
        Card(
          color: ColorConstant.bluegray200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            //set border radius more than 50% of height and width to make circle
          ),
          child: Container(

            width: MediaQuery.of(context).size.width * 0.43,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: Image.asset('assets/images/original_bg.png').image,
                      image:state.aList.postData![firIndex].image.toString()==''?
                      Image.asset('assets/images/person.jpg').image:
                      Image.network(Endpoints.imgbaseUrl+state.aList.postData![firIndex].image.toString()).image,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),

                ),
                Padding(padding: EdgeInsets.only(top: 13)),
                Text(
                  state.aList.postData![firIndex].admission_no.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.aList.postData![firIndex].firstname.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.aList.postData![firIndex].gender.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
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

  secCard(StudentListLoaded state , int index){
    int secIndex = index + index + 1;
    int length = state.aList.postData!.length;

    return secIndex == length ? Container(): GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder:  (BuildContext context) =>
                  StudentDetail(student_id: state.aList.postData![secIndex].id.toString(),
                    name: state.aList.postData![secIndex].firstname.toString(),
                    gender: state.aList.postData![secIndex].gender.toString(),
                    admission_no: state.aList.postData![secIndex].admission_no.toString(),
                    image: state.aList.postData![secIndex].image.toString(),
                    classs: widget.classs,section: widget.section,
                    class_id: widget.class_id, section_id: widget.section_id,
                  )
              )
          );
        },
        child:
        Card(
          color: ColorConstant.bluegray200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            //set border radius more than 50% of height and width to make circle
          ),
          child: Container(

            width: MediaQuery.of(context).size.width * 0.43,
            height: 200,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      // image: Image.asset('assets/images/original_bg.png').image,
                      image:state.aList.postData![secIndex].image.toString()==''?
                      Image.asset('assets/images/person.jpg').image:
                      Image.network(Endpoints.imgbaseUrl+state.aList.postData![secIndex].image.toString()).image,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),

                ),
                Padding(padding: EdgeInsets.only(top: 13)),
                Text(
                  state.aList.postData![secIndex].admission_no.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.aList.postData![secIndex].firstname.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Myanmar3',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  state.aList.postData![secIndex].gender.toString(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
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

  SearchContainer(){
    return TextFormField(
      controller: searchController,
      textInputAction: TextInputAction.next,
      onFieldSubmitted: (term){
        print('term');print(term);
        setState(() {
          if(term == '') search = 'all';
          else search = term;
          print(search);
          _studentListBloc.add(FetchStudentList
            (class_id: widget.class_id, section_id: widget.section_id,search: search));
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


        prefixIcon: Icon(Icons.search,color: Colors.black),
        suffixIcon:  InkWell(
          onTap: () {
            searchController.clear();
            setState(() {
              search = "all";
            });
          },
          child: Icon(Icons.clear,color: Colors.black)
          ,
        ),


      ),
      validator: (value) {
        if(value!.length < 1 ) {
          return 'Enter Text';
        }
      },

    );
  }
  headContainer(){
    return
      Container(
        color: ColorConstant.bluegray200,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 15,bottom: 15,left: 10,right: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(

              child: Text(
                widget.classs+"  ("+widget.section+")",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Myanmar3',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          ],
        ),
      );
  }

}


