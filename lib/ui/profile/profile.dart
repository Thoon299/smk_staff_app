import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/bloc/auth/logout/logout_event.dart';
import 'package:smk/ui/profile/user_manual.dart';

import '../../bloc/auth/logout/logout_bloc.dart';
import '../../bloc/profile/profile_bloc.dart';
import '../../bloc/profile/profile_event.dart';
import '../../bloc/profile/profile_state.dart';
import '../../data/repository/logout_repository.dart';
import '../../data/repository/profile_repository.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import '../../figma/core/utils/size_utils.dart';
import '../auth/login.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {

  ProfileBloc _profileBloc=ProfileBloc(getIt<ProfileRepository>());
  LogoutBloc _logoutBloc = LogoutBloc(getIt<LogoutRepository>());

  void initState(){
    var sharedPreference=getIt<SharedPreferenceHelper>();
    String teacherId = sharedPreference.getTeacherId.toString();
    _profileBloc.add(FetchProfile());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BlocBuilder<ProfileBloc,ProfileState>(
          bloc: _profileBloc,
          builder: (context, state){
            if(state is ProfileLoading){
              return SpinKitFadingFour(color: Color(0xff334A52),);
            }
            else if(state is ProfileError){
              return Container(
                  padding: EdgeInsets.only(top: 20,bottom: 20),
                  child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
            }
            else if(state is ProfileLoaded){
              return
               Column(
                 children: [
                   Container(
                     height: MediaQuery.of(context).size.height * 0.4,
                     color: ColorConstant.gray100,
                     child: header(state),
                   ),
                  Expanded(child: footer(state))

                 ],
               );
            }
            return SpinKitFadingFour(color: Color(0xff334A52));
          },
        )

      ),
      bottomNavigationBar:
      GestureDetector(
        onTap: () async{

        },
        child: Container(
          margin: EdgeInsets.only(left: 10),
            height: 80,
            child:
           Row(
             mainAxisAlignment: MainAxisAlignment.start,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [
                Container(
                   width: MediaQuery.of(context).size.width*0.2,
                   height: MediaQuery.of(context).size.height,
                   child: IconButton(onPressed: (){

                     showDig();

                     print('logout');
                   },
                       icon: Column(
                         children: [
                           Icon(Icons.logout,size: 35,),
                           Text('Log Out',style: TextStyle(fontSize: 18),),
                         ],
                       )),
                 ),

               Expanded(child: Container(
                 margin: EdgeInsets.only(right: 15),
                 child:  Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   crossAxisAlignment: CrossAxisAlignment.end,
                   children: [

                     Text('Version : V1.0.5 (UAT)',
                         style:  TextStyle(fontFamily: 'Rasa', fontSize: 16,color: Colors.black)),
                     Padding(padding: EdgeInsets.only(top: 10)),
                     Text('19/1/2023',
                         style:  TextStyle(fontFamily: 'Rasa', fontSize: 16,color: Colors.black)),
                     Padding(padding: EdgeInsets.only(top: 5)),
                     GestureDetector(
                         onTap: () async{

                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => UserManual()),
                           );

                         },
                         child:  Row(
                           mainAxisAlignment: MainAxisAlignment.end,
                           children: [
                             Icon(Icons.arrow_circle_right_rounded,color: Colors.blue,),
                             Text('User Manual',
                               style: TextStyle(fontSize: 18,fontFamily: 'Rasa',color: Colors.blue),)
                           ],
                         )
                     ),

                   ],

                 ),
               ))
             ],
           )
        ),
      ),

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
                      'Are you sure to log out?',style: TextStyle(fontSize: 20,fontFamily: 'Rasa')
                  ),
                  Padding(padding: EdgeInsets.only(top: 30)),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          var sharedPreference=getIt<SharedPreferenceHelper>();
                          String teacherId = sharedPreference.getTeacherId.toString();
                          sharedPreference.setTeacherId("null");
                          _logoutBloc.add(FetchLogout(
                              fcm_token: sharedPreference.getTeacherFcmId.toString()));
                          sharedPreference.setTeacherFcmId("null");

                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder:  (BuildContext context) =>
                                  Login()));

                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20,right: 20),
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                              color: Color(0xff334A52),
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Center(child: Text('OK',style: TextStyle(fontSize: 18,
                              fontFamily: 'Rasa',color: Colors.white),),),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.pop(context);

                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 20),
                          height: 40,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Color(0xff334A52),
                              borderRadius: BorderRadius.circular(5.0)
                          ),
                          child: Center(child: Text('Cancel',style: TextStyle(fontSize: 18,
                              fontFamily: 'Rasa',color: Colors.white),),),
                        ),
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                ],
              )
          );
        }
    );
  }

  header(ProfileLoaded state){
    return Container(

      decoration: BoxDecoration(
          color: ColorConstant.purple900,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45.0),
          )

      ),
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/vector_up1.png"),
                fit: BoxFit.cover,
              ),
            ),
            child:
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        // image: Image.asset('assets/images/original_bg.png').image,
                        image:state.profileModel.image.toString()==''?
                        Image.asset('assets/images/person.jpg').image:
                        Image.network(state.profileModel.image.toString()).image,
                        fit: BoxFit.fill,
                      ),
                      borderRadius: BorderRadius.circular(50),
                    ),

                  ),
                  Padding(padding: EdgeInsets.only(top: 18)),
                  Text(state.profileModel.name.toString(),style: TextStyle(color: Colors.white,
                      fontSize: 25, fontFamily: 'ABeeZee',),),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(state.profileModel.designation.toString(),style: TextStyle(color: Colors.white,
                    fontSize: 18, fontFamily: 'ABeeZee',),),
                  Padding(padding: EdgeInsets.only(top: 18)),
                 // Text("",style: TextStyle(color: Colors.white,
                 //     fontSize: 15, fontFamily: 'ABeeZee',),),

                ],
              ),
            )


        ),
      /* add child content here */
    );
  }

  footer(ProfileLoaded state){
    return Container(
      color:ColorConstant.purple900,
      child:  Container(
        padding: EdgeInsets.only(left: 15,right: 15,top: 40),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: ColorConstant.gray100,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(45.0),
            )),
        child:  SingleChildScrollView(
            child: new Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Container(
                        width: MediaQuery.of(context).size.width/2,
                      child: Text('Staff ID', textAlign: TextAlign.left,
                        style: TextStyle(
                          color: ColorConstant
                              .black900,
                          fontSize: getFontSize(
                            20,
                          ),
                          fontFamily: 'ABeeZee',
                          fontWeight:
                          FontWeight.w400,
                        ),)
                    ),

                    Expanded(
                        child: Text(state.profileModel.staff_no.toString(), textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    )],
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Divider(thickness: 1,),
                Padding(padding: EdgeInsets.only(top: 5)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text('Date of Birth', textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    ),
                    Expanded(
                        child: Text(state.profileModel.dob.toString(), textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    )],
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Divider(thickness: 1,),
                Padding(padding: EdgeInsets.only(top: 5)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text('Department', textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    ),
                    Expanded(
                        child: Text(state.profileModel.department.toString(), textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    )],
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Divider(thickness: 1,),
                Padding(padding: EdgeInsets.only(top: 5)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text('Emergency Contact', textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    ),
                    Expanded(
                        child: Text(state.profileModel.emergency_contact_no.toString(), textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    )],
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Divider(thickness: 1,),
                Padding(padding: EdgeInsets.only(top: 5)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text('Email', textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    ),
                    Expanded(
                        child: Text(state.profileModel.email.toString(), textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    )],
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Divider(thickness: 1,),
                Padding(padding: EdgeInsets.only(top: 5)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text('Gender', textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    ),
                    Expanded(
                        child: Text(state.profileModel.gender.toString(), textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    )],
                ),
                Padding(padding: EdgeInsets.only(top: 5)),
                Divider(thickness: 1,),
                Padding(padding: EdgeInsets.only(top: 5)),
                Row(
                  children: [
                    Padding(padding: EdgeInsets.only(left: 25)),
                    Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Text('Date of Joining', textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    ),
                    Expanded(
                        child: Text(state.profileModel.date_of_joining.toString(), textAlign: TextAlign.left,
                          style: TextStyle(
                            color: ColorConstant
                                .black900,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight:
                            FontWeight.w400,
                          ),)
                    )],
                ),
                   Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).size.height* 0.06)),





              ],
            )
        ),
      ),
    );
  }
}

