import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smk/ui/auth/login.dart';

import '../data/sharedpreference/shared_preference_helper.dart';
import '../di/components/service_locator.dart';
import '../figma/core/utils/color_constant.dart';
import 'home.dart';

class Splash extends StatefulWidget {
  static const String route = '/splash_screen';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {


  void initState() {
    super.initState();
    var sharedPreference=getIt<SharedPreferenceHelper>();
    String teacherId = sharedPreference.getTeacherId.toString();
    print('before');
    print(teacherId);

    if( teacherId != null ){
      Timer(Duration(seconds: 3),
              ()=>Navigator.pushReplacement(context,
              MaterialPageRoute(builder:
                  (context) =>
              teacherId =="null" ? Login() : Home(tabIndex: 0,)
              )
          )
      );
    }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
         color: ColorConstant.purple900
        ),
        child: Center(
          child: Container(
           height: 700,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                image: AssetImage("assets/images/vector_up1.png",),


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
                      width: 150,
                      height: 150,
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
                     Text('Staff App',style: TextStyle(
                        fontSize: 25,
                       color: ColorConstant.orangeA100,
                    ),)
                  ],
                ),
              )

          
          ),
        ) /* add child content here */,
      ),
    );
  }
}


