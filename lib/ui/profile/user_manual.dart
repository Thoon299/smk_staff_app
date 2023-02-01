import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:smk/data/network/api/constants/endpoints.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../figma/core/utils/color_constant.dart';


class UserManual extends StatefulWidget {

  @override
  _userManualState createState() => _userManualState();
}

class _userManualState extends State<UserManual> {
  bool isLoading=true;
  final _key = UniqueKey();

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    var link = Endpoints.imgbaseUrl+'usermanual/preview';
    WebViewController _controller;
    return Scaffold(
      backgroundColor: ColorConstant.whiteA700,
      appBar: AppBar(
        brightness: Brightness.dark,
        backgroundColor: ColorConstant.whiteA700,
        elevation: 0.0,
        toolbarHeight: 95,
        toolbarOpacity: 0.8,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text("User Manual"),
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
      body: Stack(
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: link,
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading ? Center( child: SpinKitFadingFour(color: Color(0xff334A52),))
              : Stack(),
        ],
      ),

    );
  }
}
