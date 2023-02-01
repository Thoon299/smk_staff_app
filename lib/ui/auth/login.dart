import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/ui/home.dart';

import '../../bloc/auth/login/login_bloc.dart';
import '../../bloc/auth/login/login_event.dart';
import '../../bloc/auth/login/login_state.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';

class Login extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return WillPopScope(
      onWillPop: () async {
    // Do something here
    print("After clicking the Android Back Button");
    SystemNavigator.pop();


    return false;
  },
  child:Scaffold(

    body: InputArea(),
  ));
}
}

class InputArea extends StatefulWidget {
  @override
  _InputAreaState createState() => _InputAreaState();
}

class _InputAreaState extends State<InputArea> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading=false;
  bool hidePassword=true;
  LoginBloc _LoginBloc=LoginBloc(LoginInitialized());
  String isTouching = "false";
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _LoginBloc.add(LoginStart());
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    var sharedPreference=getIt<SharedPreferenceHelper>();
    String teacherId = sharedPreference.getTeacherId.toString();
    if(teacherId != 'null'){
      Navigator.pop(context);
    }
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status '+ e.toString());
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: BlocProvider<LoginBloc>(
          create:(_) {
            return LoginBloc(LoginInitialized());
          },
          child:

              BlocListener<LoginBloc,LoginState>(
                bloc: _LoginBloc,
                listener: (context,state){
                  if(state is LoginLoading){
                    showDialog(
                        barrierDismissible: false,
                        barrierColor: Color(0x00ffffff),
                        context: context,
                        builder: (BuildContext context){
                          return
                            Material(
                              type: MaterialType.transparency,
                              child: Center(
                                  child: SpinKitFadingFour(color: Color(0xff334A52),)
                              ),
                            );
                        }
                    );
                  }
                  else if(state is LoginError){
                    Navigator.pop(context);
                    setState(() {
                      isTouching = "false";
                    });
                    String con = _connectionStatus.toString();
                    if( con == "ConnectivityResult.none" ){
                      showDig();
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(state.errorMessage)));
                    }

                  }
                  else if(state is LoginSuccess){
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return AlertDialog(
                              title: Text(
                                  'Login Success',style: TextStyle(fontSize: 20,fontFamily: 'Rasa')
                              ),
                              content:
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                      'You are now accessible.',style: TextStyle(fontSize: 18,fontFamily: 'Rasa')
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 30)),
                                  GestureDetector(
                                    onTap: (){
                                      print("verify tokne");
                                      print(state.verify_token);
                                      var sharedPreference=getIt<SharedPreferenceHelper>();

                                      String verify_token = state.verify_token.toString();
                                      List<String> list = verify_token.split("&");
                                      sharedPreference.setTeacherId(list[0].trim());
                                      sharedPreference.setTeacherFcmId(list[1].trim());


                                      Navigator.pop(context);

                                      Navigator.pushReplacement(context,
                                          MaterialPageRoute(builder: (BuildContext context) =>
                                              Home(tabIndex: 0,)));
                                      // Navigator.pop(context);
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
                },
                child:
                Form(
                  key: _key,
                  child: SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: header()
                            ),
                            Expanded(
                                child: footer()
                            ),
                          ],
                        ),
                      )
                  )
                ),
              )
          )

    );
  }

  header(){
    return Container(
      decoration: BoxDecoration(
          color: ColorConstant.purple900,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(45.0),
          )

      ),
      child: Center(
        child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/vector_up1.png"),
                fit: BoxFit.fill,
              ),
            ),
            child:
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Container(
                width: 120,
                height: 120,
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: Image.asset('assets/images/original_bg.png').image,
                    image: Image.asset('assets/images/smk_app_icon.png').image,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
                  Padding(padding: EdgeInsets.only(top: 8)),

                  Text('SMK Staff App',style: TextStyle(
                      fontSize: 20,
                    color: ColorConstant.orangeA100,
                  ),),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Text('Sing In',style: TextStyle(color: Colors.white,
                      fontSize: 30),),

                ],
              ),
            )


        ),
      ) /* add child content here */,
    );
  }

  footer(){
    return Container(
        color:ColorConstant.purple900,
        child:  Container(
          padding: EdgeInsets.only(left: 40,right: 40,top: 50),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(45.0),
              )),
          child:SingleChildScrollView(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child:  Text('Email',style: TextStyle(fontSize: 18),),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorConstant.gray100, width: 5.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorConstant.gray100, width: 5.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),

                  fillColor: ColorConstant.gray100,
                  filled: true,

                  prefixIcon: Icon(Icons.email,color: Colors.black),

                ),
                validator: (value) {
                  if(value!.length < 1 ) {
                    return 'Enter Email';
                  }
                },

              ),
              Padding(padding: EdgeInsets.only(top: 15)),

              Align(
                alignment: Alignment.topLeft,
                child:  Text('Password',style: TextStyle(fontSize: 18),),
              ),
              Padding(padding: EdgeInsets.only(top: 15)),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorConstant.gray100, width: 5.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: ColorConstant.gray100, width: 5.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),

                  fillColor: ColorConstant.gray100,
                  filled: true,

                  prefixIcon: Icon(Icons.lock,color: Colors.black),

                ),

                validator: (value) {
                  if(value!.length < 1 ) {
                    return 'Enter Password';
                  }
                },

              ),
              Padding(padding: EdgeInsets.only(top: 50)),
              GestureDetector(
                  onTap: () async{
                    setState(() {
                      isTouching = "true";
                    });

                      var sharedPreference=getIt<SharedPreferenceHelper>();
                      String oldFcmToken = sharedPreference.getFcmToken.toString();
                      FirebaseMessaging.instance.getToken().then((token){
                        print("login fcm token");
                        sharedPreference.setFcmToken(token!);
                        print(token);
                        _LoginBloc.add(LoginPressedButton(
                          email: emailController.text, password: passwordController.text,
                          deviceToken: token!,
                          oldFcmToken : "not see",
                        ));
                      });
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: isTouching == "false" ? ColorConstant.purple900 : ColorConstant.gray200,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        )),
                    child: Center(child: Text(
                      "Sign In",style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    ),),
                  )
              ),

            ],

          ),
          ),
        )
    );
  }

  showDig(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: Text(
                  'Internet Connectivity',textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20,fontFamily: 'Rasa')
              ),
              content:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                      'You are now Offline.',style: TextStyle(fontSize: 18,fontFamily: 'Rasa')
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
