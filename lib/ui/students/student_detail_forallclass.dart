import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';
import 'package:smk/ui/students/students_list_forallclass.dart';
import '../../bloc/students/student_detail/student_detail_bloc.dart';
import '../../bloc/students/student_detail/student_detail_event.dart';
import '../../bloc/students/student_detail/student_detail_state.dart';
import '../../data/repository/student_repository.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import '../../figma/core/utils/size_utils.dart';

class StudentDetailForAllClass extends StatefulWidget {
  String student_id;
  String name, gender, admission_no; String image;String search;
  StudentDetailForAllClass({required this.student_id, required this.name, required this.gender,
    required this.admission_no ,required this.image,required this.search});
  @override
  _StudentDetailForAllClassState createState() => _StudentDetailForAllClassState();
}

class _StudentDetailForAllClassState extends State<StudentDetailForAllClass> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  StudentDetailBloc _studentDetailBloc=StudentDetailBloc(getIt<StudentRepository>());


  @override
  void initState() {
    // TODO: implement initState
    _studentDetailBloc.add(FetchStudentDetailForAllClass(student_id: widget.student_id));
    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
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
                  StudentsListForAllClass(search: widget.search)
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
              title: Text(
                'Students Directory',
                style: TextStyle(
                    color: ColorConstant.whiteA700,
                    fontSize: getFontSize(
                      25,
                    ),
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w400),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
                tooltip: 'Back Icon',
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder:  (BuildContext context) =>
                          StudentsListForAllClass(search: widget.search)
                      ));
                },
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  color: ColorConstant.purple900,
                ),
              ),
            ),
            body: Container(
                padding: EdgeInsets.only(bottom: 10),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: ColorConstant.gray100,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(45.0),
                    )),
                child: BlocBuilder<StudentDetailBloc,StudentDetailState>(
                  bloc: _studentDetailBloc,
                  builder: (context, state){
                    if(state is StudentDetailForAllClassLoading){
                      return SpinKitFadingFour(color: Color(0xff334A52),);
                    }
                    else if(state is StudentDetailForAllClassError){
                      return Container(
                          padding: EdgeInsets.only(top: 20,bottom: 20),
                          child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
                    }
                    else if(state is StudentDetailForAllClassLoaded){
                      return
                        Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.28,
                              width: MediaQuery.of(context).size.width,
                              child: header(state),
                            ),
                            Padding(padding: EdgeInsets.only(top: 15)),
                            Expanded(child: customTab(state))
                          ],
                        );
                    }
                    return SpinKitFadingFour(color: Color(0xff334A52));
                  },
                ),)));
  }

  customTab(StudentDetailForAllClassLoaded state) {
    return DefaultTabController(
      length: 2,
      child: Container(
        color: ColorConstant.gray100,
        child: Column(
          children: <Widget>[
            TabBar(
              indicatorColor: ColorConstant.purple900,
              labelColor: Colors.black,
              tabs: <Widget>[
                Tab(
                  child: Container(
                      child: Center(
                        child: Text(
                          'Personal',
                          style: TextStyle(
                              fontSize: getFontSize(
                                22,
                              ),
                              fontFamily: 'ABeeZee',
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                ),
                Tab(
                  child: Container(
                      child: Center(
                        child: Text(
                          'Parents',
                          style: TextStyle(
                              fontSize: getFontSize(
                                22,
                              ),
                              fontFamily: 'ABeeZee',
                              fontWeight: FontWeight.w400),
                        ),
                      )),
                )
              ],
            ),
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  footer(state),
                  footerParents(state),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  header(StudentDetailForAllClassLoaded state) {
    return Container(
      decoration: BoxDecoration(
          color: ColorConstant.purple900,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45.0),
          )

      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 90,
              decoration: BoxDecoration(
                image: DecorationImage(
                  // image: Image.asset('assets/images/original_bg.png').image,
                  image:widget.image==''?
                  Image.asset('assets/images/person.jpg').image:
                  Image.network(Endpoints.imgbaseUrl+widget.image).image,
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Text(
              widget.admission_no+" ("+
                  state.studentDetailForAllClassModel.class_name.toString()+" - "+
                  state.studentDetailForAllClassModel.section_name.toString()+")",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.whiteA700,
                fontSize: 25,
                fontFamily: 'ABeeZee',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 15)),
            Text(
              widget.name,
              style: TextStyle(
                color: ColorConstant.whiteA700,
                fontSize: 18,
                fontFamily: 'ABeeZee',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              widget.gender,
              style: TextStyle(
                color: ColorConstant.whiteA700,
                fontSize: 18,
                fontFamily: 'ABeeZee',
              ),
            ),

            // Text("",style: TextStyle(color: Colors.white,
            //     fontSize: 15, fontFamily: 'ABeeZee',),),
          ],
        ),
      ),
      /* add child content here */
    );
  }

  footerParents(StudentDetailForAllClassLoaded state) {
    return Container(
      color: ColorConstant.gray100,
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
      child: SingleChildScrollView(
          child: new Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 160,
                    child: Column(
                      children: [
                        Text(
                          'Father',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 21,
                              fontFamily: 'ABeeZee',
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              // image: Image.asset('assets/images/original_bg.png').image,
                              image: Image.asset('assets/images/person.jpg').image,
                              fit: BoxFit.fill,
                            ),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Row(
                          children: [
                            Icon(Icons.person),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Expanded(
                              child: Text(
                                state.studentDetailForAllClassModel.father_name.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Row(
                          children: [
                            Icon(Icons.phone),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Expanded(
                              child: Text(
                                state.studentDetailForAllClassModel.father_phone.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),
                        Padding(padding: EdgeInsets.only(top: 10)),
                        Row(
                          children: [
                            Icon(Icons.bookmark_added_sharp),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Expanded(
                              child: Text(
                                state.studentDetailForAllClassModel.father_occupation.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'ABeeZee',
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
              Divider(thickness: 1,),
              motherRow(state),
              Divider(thickness: 1,),
              guardianRow(state),
              Divider(thickness: 1,),
              pickUpPersonRow(state),
            ],
          )),
    );
  }
  pickUpPersonRow(StudentDetailForAllClassLoaded state){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          child: Column(
            children: [
              Text(
                'Pick Up Person',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w500),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: Image.asset('assets/images/original_bg.png').image,
                    image: Image.asset('assets/images/person.jpg').image,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 25)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.person),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.pickup_person_name.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.phone),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.pickup_person_phno.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.pickup_person_address.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.bookmark_added_sharp),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.pickup_person_relationship.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.insert_invitation),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.pickup_person_nric.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }

  guardianRow(StudentDetailForAllClassLoaded state){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          child: Column(
            children: [
              Text(
                'Guardian',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w500),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: Image.asset('assets/images/original_bg.png').image,
                    image: Image.asset('assets/images/person.jpg').image,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 25)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.person),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.guardian_name.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.phone),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.guardian_phone.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.email),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.guardian_email.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.location_on),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.guardian_address.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.bookmark_added_sharp),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.guardian_relation.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.bookmark_added_sharp),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.guardian_relation.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }

  motherRow(StudentDetailForAllClassLoaded state){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 160,
          child: Column(
            children: [
              Text(
                'Mother',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 21,
                    fontFamily: 'ABeeZee',
                    fontWeight: FontWeight.w500),
              ),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: Image.asset('assets/images/original_bg.png').image,
                    image: Image.asset('assets/images/person.jpg').image,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 25)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.person),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.mother_name.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.phone),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.mother_phone.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Row(
                children: [
                  Icon(Icons.bookmark_added_sharp),
                  Padding(padding: EdgeInsets.only(left: 10)),
                  Expanded(
                    child: Text(
                      state.studentDetailForAllClassModel.mother_occupation.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),

            ],
          ),
        ),
      ],
    );
  }

  footer(StudentDetailForAllClassLoaded state) {
    return Container(
      color: ColorConstant.gray100,
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
      child: SingleChildScrollView(
          child: new Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Roll No',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.roll_no.toString(),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Admission Date',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.admission_date.toString(),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Mobile Number',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.mobileno.toString(),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(thickness: 1,),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Date of Birth',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.dob.toString(),
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),

              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Email',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.email.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Religion',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.religion.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Cast',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.cast.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Current Address',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.current_address.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Permanent Address',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.permanent_address.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),

              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Height',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.height.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Weight',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.weight.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Divider(
                thickness: 1,
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'As On Date',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                  Expanded(
                      child: Text(
                        state.studentDetailForAllClassModel.measurement_date.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant.black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight: FontWeight.w400,
                        ),
                      ))
                ],
              ),
            ],
          )),
    );
  }
}
