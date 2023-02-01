import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smk/ui/dashboard/dashboard.dart';
import 'package:smk/ui/home.dart';
import 'package:smk/ui/staff/staff_dir_home.dart';
import '../../data/network/api/constants/endpoints.dart';
import '../../di/components/service_locator.dart';
import '../../figma/core/utils/color_constant.dart';
import '../../figma/core/utils/size_utils.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

class StaffDirDetail extends StatefulWidget {
  String id;String staff_no;String name,desgination;
  String dob, department, contact, email, gender, date_of_joining,image,path;

  StaffDirDetail({required this.id, required this.staff_no,required this.desgination, required this.name,
    required this.dob, required this.department, required this.contact ,required this.email,
    required this.gender, required this.date_of_joining, required this.image, required this.path});
  @override
  _StaffDirDetailState createState() => _StaffDirDetailState();
}

class _StaffDirDetailState extends State<StaffDirDetail> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      // Do something here

      Navigator.push(context,
          MaterialPageRoute(builder:  (BuildContext context) =>
              Home(tabIndex: 3,
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
          title: Text(
            'Staff Directory',
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
                      Home(tabIndex: 3)
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
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width,
                  child: header(),
                ),
                Expanded(child:
                Container(
                  color: ColorConstant.gray100,
                  child: footer(),
                )
                )
              ],
            ))));
  }

  footer() {
    return Container(
      color: ColorConstant.gray100,
      padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
      child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(padding: EdgeInsets.only(left: 25)),
                  Container(
                      width: MediaQuery.of(context).size.width / 2,
                      child: Text(
                        'Staff ID'
                            ,
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
                        widget.staff_no,
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
                        widget.dob,
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
                        'Department',
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
                        widget.department,
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
                        'Emergency Contact',
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
                  GestureDetector(
                      onTap: () {
                        // Navigator.pop(context);
                        UrlLauncher.launch('tel:${widget.contact}');

                      },
                    child: Expanded(
                        child: Text( widget.contact,
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: getFontSize(
                              20,
                            ),
                            fontFamily: 'ABeeZee',
                            fontWeight: FontWeight.w400,
                          ),
                        )),


                  ),

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
                        widget.email,
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
                        'Gender',
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
                        widget.gender,
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
                        'Date of Joining',
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
                        widget.date_of_joining,
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

            ],
          )),
    );
  }

  header() {
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
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  // image: Image.asset('assets/images/original_bg.png').image,
                  image:widget.image==''?
                  Image.asset('assets/images/person.jpg').image:
                  Image.network(Endpoints.imgbaseUrl+widget.path+widget.image).image,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),

            Text(
              widget.name,
              style: TextStyle(
                color: ColorConstant.whiteA700,
                fontSize: 22,
                fontFamily: 'ABeeZee',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text(
              widget.desgination,
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



}
