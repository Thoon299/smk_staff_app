import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:smk/routes/routes.dart';
import 'package:smk/services/local_noti_service.dart';
import 'package:smk/ui/home.dart';
import 'package:smk/ui/notification/notification_home.dart';
import 'package:smk/ui/splash_screen.dart';

import 'bloc/badge/badge.bloc.dart';
import 'bloc/badge/badge.event.dart';
import 'data/local/constants/translate_preferences.dart';
import 'data/repository/badge_repository.dart';
import 'data/sharedpreference/shared_preference_helper.dart';
import 'di/components/service_locator.dart';
import 'figma/core/utils/color_constant.dart';
import 'firebase_options.dart';


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();


  await Firebase.initializeApp(
    name: 'com.staff.smk',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);


  FirebaseMessaging.onMessageOpenedApp.listen((message) {

    print('main Message clicked!  '+message.notification!.body.toString());

  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('main Message listen!  '+message.notification!.body.toString());

  });




  AwesomeNotifications().initialize(
      'resource://drawable/notification',
      [            // notification icon
        NotificationChannel(
          channelGroupKey: 'basic_test',
          channelKey: 'basic',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          channelShowBadge: false,
          importance: NotificationImportance.High,
          enableVibration: true,
          locked: true,
        ),



        //add more notification type with different configuration

      ]
  );

  NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );

  //Local Notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("main This is notification !!!");

    RemoteNotification notification = message.notification!;
    AndroidNotification android = message.notification!.android!;

    print("This is notification ${notification.title} ${notification.body}");
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              icon: android?.smallIcon,
              // other properties...
            ),
          ));
    }
  });




  Bloc.observer = AppBlocObserver();

  var delegate= await LocalizationDelegate.create(
      preferences: TranslatePreferences(),
      basePath: 'assets/i18n/',
      fallbackLocale: 'my',
      supportedLocales: ['en', 'my']);

  await setPreferredOrientations();
  var sharedPreference=getIt<SharedPreferenceHelper>();
  String teacherId = sharedPreference.getTeacherId.toString();
  sharedPreference.setb("");




  print('before');
  print(teacherId);


  final MyApp myApp = MyApp(
    initialRoute: teacherId ==null ? '/home' : '/login',
  );
  HttpOverrides.global = new MyHttpOverrides();
  runApp(LocalizedApp(delegate, myApp));
}
Future<dynamic> _firebaseMessagingBackgroundHandler(RemoteMessage msg) async {

  print('main background msg');
  await Firebase.initializeApp(
    name: 'com.staff.smk',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String t = msg.notification!.title.toString();
  String b = msg.notification!.body.toString();
  DatabaseReference userRef = FirebaseDatabase.instance.ref('users');
  final snapshot = await userRef.child('changes').get();
  userRef.update({
    t: b,

  });



}

class MyApp extends StatefulWidget {
  String? initialRoute;
  MyApp({this.initialRoute});
  @override
  _MyAppState createState() => _MyAppState(initialRoute : initialRoute);
}
class _MyAppState extends State<MyApp> {
  // late AuthenticationBloc myAuthenticationBloc =getIt<AuthenticationBloc>();
  static final navigatorKey = new GlobalKey<NavigatorState>();
  String? initialRoute;
  _MyAppState({this.initialRoute});


  @override
  void initState() {
    // TODO: implement initState
    FirebaseMessaging.instance.getToken().then((token){
      print("main fcm token");


    });





    super.initState();
  }


  //late AuthenticationBloc myAuthenticationBloc =getIt<AuthenticationBloc>();


  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return
      LocalizationProvider(
        state: LocalizationProvider.of(context).state,

        child: MaterialApp(
          navigatorKey:navigatorKey ,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          debugShowCheckedModeBanner: false,
          builder: (context,widget) => ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            maxWidth: 1200,
            minWidth: 450,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(450, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(800, name: TABLET),
              const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
              const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
            ],
          ),
          theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
          routes: Routes.routes,
          initialRoute: Splash.route,
          //   home: BlogPosts(),
          // initialRoute:'/first_time',
          title: 'Flutter Demo',

        ),
      );
  }

}
class AppBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (bloc is Cubit) print(change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print(transition);
  }
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print(error);
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> setPreferredOrientations() {
  return SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
