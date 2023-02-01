
import 'package:flutter/widgets.dart';
import 'package:smk/ui/splash_screen.dart';

import '../ui/auth/login.dart';
import '../ui/home.dart';

class Routes {
  Routes._();


  static const String splash = '/splash_screen';
  static const String home = '/home';
  static const String login = '/login';



  static final routes = <String, WidgetBuilder> {
   // blog_posts: (BuildContext context) => BlogPosts(),
    home: (BuildContext context) => Home(tabIndex: 0,),
    login: (BuildContext context) => Login(),
    splash: (BuildContext context) => Splash(),

  };


}
