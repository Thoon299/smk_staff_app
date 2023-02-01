import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:smk/bloc/announcements/announcement_event.dart';

import '../../bloc/announcements/announcement_bloc.dart';
import '../../bloc/announcements/announcement_state.dart';
import '../../data/repository/announcement_repository.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

class AnnouncementDeatil extends StatefulWidget {
  String id;


  AnnouncementDeatil({required this.id});
  @override
  _AnnouncementDeatilState createState() => _AnnouncementDeatilState();
}

class _AnnouncementDeatilState extends State<AnnouncementDeatil> {
  AnnouncementBloc _announcementBloc=AnnouncementBloc(getIt<AnnouncementRepository>());

  @override
  void initState() {
    _announcementBloc.add(FetchAnnDetail(id: widget.id));
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
          title: Text('Announcement'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            tooltip: 'Back Icon',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(45),
              ),
              color: ColorConstant.purple900,
            ),
          ),
        ),
        body: Container(
            color: ColorConstant.gray100,
            child: Container(
                color: ColorConstant.purple900,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      color: ColorConstant.gray100,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(45.0),
                      )),
                  child:BlocBuilder<AnnouncementBloc,AnnouncementState>(
                    bloc: _announcementBloc,
                    builder: (context, state){
                      if(state is AnnDetailLoading){
                        return SpinKitFadingFour(color: Color(0xff334A52),);
                      }
                      else if(state is AnnDetailError){
                        return Container(
                            padding: EdgeInsets.only(top: 20,bottom: 20),
                            child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
                      }
                      else if(state is AnnDetailLoaded){
                        return
                          Column(
                            children: [
                              Text(state.annDetailModel.title.toString(), textAlign: TextAlign.center,
                                  style:  TextStyle(fontFamily: 'Rasa', fontSize: 20,color: Colors.black)),
                              Divider(thickness: 1,),
                              Expanded(child:
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Html(
                                      data: state.annDetailModel.message.toString(),
                                      tagsList: Html.tags,
                                      style: {
                                        "table": Style(
                                          backgroundColor: Color.fromARGB(0x50, 0xee, 0xee, 0xee),
                                        ),
                                        "tr": Style(
                                          border: Border(bottom: BorderSide(color: Colors.grey)),
                                        ),
                                        "th": Style(
                                          padding: EdgeInsets.all(6),
                                          backgroundColor: Colors.grey,
                                        ),
                                        "td": Style(
                                          padding: EdgeInsets.all(6),
                                          alignment: Alignment.topLeft,
                                        ),
                                        'h5': Style(maxLines: 2, textOverflow: TextOverflow.ellipsis),
                                        "body": Style(
                                          fontSize: FontSize(17.0),
                                          fontFamily: 'Rasa', color: ColorConstant.gray800,
                                          lineHeight: LineHeight.number(1.5),
                                        ),
                                        "p": Style(
                                          fontSize: FontSize(17.0),
                                          fontFamily: 'Rasa', color: ColorConstant.gray800,
                                          lineHeight: LineHeight.number(1.5),
                                        ),
                                      },

                                    ),
                                  ],
                                ),

                              )
                              )
                            ],
                          );
                      }
                      return SpinKitFadingFour(color: Color(0xff334A52));
                    },
                  )



                )

            )),
      bottomNavigationBar:
      GestureDetector(
        onTap: () async{

        },
        child: BlocBuilder<AnnouncementBloc,AnnouncementState>(
          bloc: _announcementBloc,
          builder: (context, state){
            if(state is AnnDetailLoading){
              return SpinKitFadingFour(color: Color(0xff334A52),);
            }
            else if(state is AnnDetailError){
              return Container(
                  padding: EdgeInsets.only(top: 20,bottom: 20),
                  child: Center(child: Text(state.errorMessage,style: TextStyle(color: Colors.red,fontSize: 15),)));
            }
            else if(state is AnnDetailLoaded){

              return
                Container(
                    margin: EdgeInsets.only(left: 10),
                    height: 50,
                    child:
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.calendar_month),
                            Text(state.annDetailModel.publish_date.toString(),
                                style:  TextStyle(fontFamily: 'Rasa', fontSize: 16,color: Colors.black)),
                          ],
                        ),


                      ],

                    )
                );
            }
            return SpinKitFadingFour(color: Color(0xff334A52));
          },
        )
      ),
    );
  }
}
