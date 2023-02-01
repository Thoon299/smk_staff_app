import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smk/bloc/announcements/announcementsList/announcement_list_event.dart';
import 'package:smk/models/announcements/announcement_list_model.dart';

import '../../bloc/announcements/announcement_bloc.dart';
import '../../bloc/announcements/announcementsList/announcement_list_bloc.dart';
import '../../bloc/announcements/announcementsList/announcement_lsit_state.dart';
import '../../data/repository/announcement_repository.dart';
import '../../data/sharedpreference/shared_preference_helper.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import 'dart:math';

import 'announcement_detail.dart';

class Sticky {
  final String note;
  static List color = [
    ColorConstant.teal50,
    ColorConstant.lightBlue50,
    ColorConstant.red100,
  ];
  static List seccolor = [
    ColorConstant.lightBlue50,
    ColorConstant.teal50,
    ColorConstant.red100,
  ];

  Sticky({required this.note});
  static Color getColorItem() => (color.toList()..indexOf(0)).first;
  static Color getSecColorItem() => (seccolor.toList()..shuffle()).first;
}


class AnnouncementListPage extends StatefulWidget {
  @override
  _AnnouncementListState createState() => _AnnouncementListState();



}

class _AnnouncementListState extends State<AnnouncementListPage> {
  AnnouncementListBloc _announcementListBloc=AnnouncementListBloc(getIt<AnnouncementRepository>());
  List colors = [ColorConstant.teal50, ColorConstant.red100, ColorConstant.lightBlue50];
  List secColors = [ ColorConstant.lightBlue50, ColorConstant.teal50, ColorConstant.red100 ];
  Random random = new Random();
  var sharedPreference=getIt<SharedPreferenceHelper>();


  int cindex = 0;      GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {

    _announcementListBloc.add(FetchAnnouncementList());
    sharedPreference.setColorRandom(0);sharedPreference.setColorRandom2(0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.gray100,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: ColorConstant.gray100,
        elevation: 0.0,
        toolbarHeight: 100,
        toolbarOpacity: 0.8,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text("Announcements"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,size: 30,),
          tooltip: 'Back Icon',
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(45),),
            color: ColorConstant.purple900,
          ),
        ),
      ),
      body:  Container(
        color: ColorConstant.gray100,
        child:Container(
        color: ColorConstant.purple900,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: ColorConstant.gray100,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(45.0),
              )), // background color
          child: BlocProvider<AnnouncementListBloc>(
            create: (_) => AnnouncementListBloc(getIt<AnnouncementRepository>()),
            child: BlocBuilder<AnnouncementListBloc, AnnouncementListState>(
                bloc:_announcementListBloc,
                builder: (context,state){
                  if(state is AnnouncementListLoading) {
                    return SpinKitFadingFour(color: Color(0xff334A52),);
                  }
                  else if(state is AnnouncementListError){
                    return Container(
                        padding: EdgeInsets.only(top: 20,bottom: 20),
                        child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
                  }
                  else if(state is AnnouncementListLoaded){
                    int length = state.data.postData!.length;
                    double divide = (length / 2) ;
                    int res = divide.ceil();
                    print('ceil');print(res);
                    return
                      ListView.builder(
                        scrollDirection: Axis.vertical,
                        // shrinkWrap: true,
                        // physics: ScrollPhysics(),
                        itemCount: res,
                        itemBuilder: (BuildContext context, int index){
                          int length = state.data.postData!.length;

                          return
                            Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  firCard(state,index),
                                  Padding(padding: EdgeInsets.only(right: 8)),
                                  (index+index+1  == length) ? Container(

                                  ):SecCard(state,index),

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
      ),
    ));
  }

  firCard(AnnouncementListLoaded state, int index){
    int firIndex =  index + index;
    int? colorIndex = sharedPreference.getColorRandom;
    colorIndex == 2? sharedPreference.setColorRandom(0) : sharedPreference.setColorRandom(colorIndex!+1);

    String imgRes =  getImageLink(state,firIndex);
    return  GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder:  (BuildContext context) =>
                AnnouncementDeatil(
                    id: state.data.postData![firIndex].id.toString())
            ));
      },
      child:
      Card(
        color: colors[colorIndex!],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          //set border radius more than 50% of height and width to make circle
        ),
        child: Container(

          width: MediaQuery.of(context).size.width * 0.43,
          height: 220,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 73,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: Image.asset('assets/images/original_bg.png').image,
                    image:imgRes=="null"?
                    Image.asset('assets/images/ann.jpg').image:
                    Image.network(imgRes!).image,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),

              ),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child:Container(
                    height: 93,

                    child:  Text(
                      state.data.postData![firIndex].title.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Myanmar3',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    height: 20,
                    child: Text(
                      state.data.postData![firIndex].publish_date.toString(),
                      style: TextStyle(
                        fontSize: 15,

                      ),
                    ),
                  )
              )
            ],
          ),
          padding: EdgeInsets.all(12),
        ),
      )
    );
  }
  getImageLink(AnnouncementListLoaded state, int index){
    String str = state.data.postData![index].message.toString();
    String substring = "img";String imgRes;
    if( str.contains(substring)){
      const start = 'src="';
      const end = '">';

      final startIndex = str.indexOf(start);
      final endIndex = str.indexOf(end, startIndex + start.length);
      imgRes = str.substring(startIndex + start.length, endIndex);
      return imgRes;
    }
    else
    {
      imgRes  =  "null";return imgRes;
    }
  }

  SecCard(AnnouncementListLoaded state, int index){
    int secIndex = index + index + 1;
    int length = state.data.postData!.length;

    int? colorIndex2 = sharedPreference.getColorRandom2;
    colorIndex2 == 2? sharedPreference.setColorRandom2(0) : sharedPreference.setColorRandom2(colorIndex2!+1);

    String imgRes =  getImageLink(state,secIndex);

    return  GestureDetector(
        onTap: () {
      Navigator.push(context,
          MaterialPageRoute(builder:  (BuildContext context) =>
              AnnouncementDeatil(
                  id: state.data.postData![secIndex].id.toString(),)
          ));
    },
      child: Card(
        color: secColors[colorIndex2!],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          //set border radius more than 50% of height and width to make circle
        ),
        child: Container(

          width: MediaQuery.of(context).size.width * 0.43,
          height: 220,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50)
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 73,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // image: Image.asset('assets/images/original_bg.png').image,
                    image:imgRes=="null"?
                    Image.asset('assets/images/ann.jpg').image:
                    Image.network(imgRes!).image,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),

              ),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child:Container(
                    height: 93,

                    child:  Text(
                      state.data.postData![secIndex].title.toString(),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Myanmar3',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Container(
                    height: 20,
                    child: Text(
                      state.data.postData![secIndex].publish_date.toString(),
                      style: TextStyle(
                        fontSize: 15,

                      ),
                    ),
                  )
              )
            ],
          ),
          padding: EdgeInsets.all(12),
        ),
      ),
    );
  }
}