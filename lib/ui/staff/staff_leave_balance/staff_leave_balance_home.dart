import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smk/bloc/staff_leave/staff_leave_balance_list/staff_leave_balance_list_bloc.dart';
import 'package:smk/bloc/staff_leave/staff_leave_balance_list/staff_leave_balance_list_event.dart';
import 'package:smk/data/repository/staff_leave_balance_list_repository.dart';
import 'package:smk/ui/staff/staff_leave_balance/staff_leave_apply.dart';

import '../../../bloc/staff_leave/staff_leave_balance/staff_leave_balance_bloc.dart';
import '../../../bloc/staff_leave/staff_leave_balance/staff_leave_balance_event.dart';
import '../../../bloc/staff_leave/staff_leave_balance/staff_leave_balance_state.dart';
import '../../../bloc/staff_leave/staff_leave_balance_list/staff_leave_balance_list_state.dart';
import '../../../data/repository/staff_leave_balance_repository.dart';
import '../../../di/components/service_locator.dart';
import '../../../figma/core/utils/color_constant.dart';
import '../../../figma/core/utils/size_utils.dart';
import '../../home.dart';

class StaffLeaveBalanceHome extends StatefulWidget {
  @override
  _StaffLeaveBalanceHomeState createState() => _StaffLeaveBalanceHomeState();
}

class _StaffLeaveBalanceHomeState extends State<StaffLeaveBalanceHome> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  StaffLeaveBalanceBloc _staffLeaveBalanceBloc =
  StaffLeaveBalanceBloc(getIt<StaffLeaveBalanceRepository>());
  StfLevBalListBloc _classSectionsBloc =
  StfLevBalListBloc(getIt<StfLevBalListRepository>());

  @override
  void initState() {
    // TODO: implement initState
    _staffLeaveBalanceBloc.add(FetchStaffLeaveBalance());
    _classSectionsBloc.add(FetchStfLevBalList());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstant.gray100,
        appBar: AppBar(
          brightness: Brightness.dark,
          backgroundColor: ColorConstant.gray100,
          elevation: 0.0,
          toolbarHeight: 95,
          toolbarOpacity: 0.8,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          title: Text('Leave/Leave Balance'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 30,
            ),
            tooltip: 'Back Icon',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Home(
                        tabIndex: 0,
                      )));
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
          child: Column(
            children: [
              addButton(),
              attTypeContainer(),
              listHeaderContainer(),
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(bottom: 25, top: 10),
                      child: BlocProvider<StfLevBalListBloc>(
                        create: (_) =>
                            StfLevBalListBloc(getIt<StfLevBalListRepository>()),
                        child:
                        BlocBuilder<StfLevBalListBloc, StfLevBalListState>(
                            bloc: _classSectionsBloc,
                            builder: (context, state) {
                              if (state is StfLevBalListLoading) {
                                return SpinKitFadingFour(
                                  color: Color(0xff334A52),
                                );
                              } else if (state is StfLevBalListError) {
                                return Container(
                                    padding: EdgeInsets.only(
                                        top: 20, bottom: 20),
                                    child: Center(
                                        child: Text(
                                          state.errorMessage,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 15),
                                        )));
                              } else if (state is StfLevBalListLoaded) {

                                return ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  // shrinkWrap: true,
                                  // physics: ScrollPhysics(),
                                  itemCount: state.stfLevBalListModel.listData!.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Divider(
                                          thickness: 1,
                                        ),
                                        listBodyContainer(state,index)
                                      ],
                                    );
                                  },
                                );
                              }
                              return SpinKitFadingFour(
                                color: Color(0xff334A52),
                              );
                            }),
                      ))),
            ],
          ),
        ));
  }

  listBodyContainer(StfLevBalListLoaded state,int index) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 12, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.24,
            child: Text(
              state.stfLevBalListModel.listData![index].type.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 15,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.26,
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              state.stfLevBalListModel.listData![index].leave_from.toString()
                  +'-'+state.stfLevBalListModel.listData![index].leave_to.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 15,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              state.stfLevBalListModel.listData![index].leave_days.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 15,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.18,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              state.stfLevBalListModel.listData![index].date.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 15,
                fontFamily: 'Open Sans',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          Container(
              width: MediaQuery.of(context).size.width * 0.17,
              color: (state.stfLevBalListModel.listData![index].status.toString() == "approve")?
              Colors.green[700]:
              (state.stfLevBalListModel.listData![index].status.toString() == "pending")?
              Colors.yellow[800]:Colors.red[500],
              height: 30,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  (state.stfLevBalListModel.listData![index].status.toString() == "approve")? 'Approved':
                  (state.stfLevBalListModel.listData![index].status.toString() == "pending")? 'Pending':'Disapprove',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: ColorConstant.gray200,
                    fontSize: 14,
                    fontFamily: 'Abril Fatface',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  listHeaderContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 10, right: 10, top: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Text(
              'Leave Type',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 17,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.26,
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              'Leave Date',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 17,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.1,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              'Days',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 17,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.2,
            padding: EdgeInsets.only(right: 5),
            child: Text(
              'Apply Date',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 17,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.14,
            child: Text(
              'Status',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorConstant.gray700,
                fontSize: 17,
                fontFamily: 'Abril Fatface',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  attTypeContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      child: BlocProvider<StaffLeaveBalanceBloc>(
        create: (_) =>
            StaffLeaveBalanceBloc(getIt<StaffLeaveBalanceRepository>()),
        child: BlocBuilder<StaffLeaveBalanceBloc, StaffLeaveBalanceState>(
            bloc: _staffLeaveBalanceBloc,
            builder: (context, state) {
              if (state is StaffLeaveBalanceLoading) {
                return SpinKitFadingFour(
                  color: Color(0xff334A52),
                );
              } else if (state is StaffLeaveBalanceError) {
                return Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Center(
                        child: Text(
                          state.errorMessage,
                          style: TextStyle(color: Colors.red, fontSize: 15),
                        )));
              } else if (state is StaffLeaveBalanceLoaded) {
                int length = state.staffLeaveBalanceModel.postData!.length;
                double divide = (length / 2);
                int res = divide.ceil();
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  // shrinkWrap: true,
                  // physics: ScrollPhysics(),
                  itemCount: res,
                  itemBuilder: (BuildContext context, int index) {
                    int length = state.staffLeaveBalanceModel.postData!.length;

                    return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          firContainer(state, index),
                          Padding(padding: EdgeInsets.only(right: 13)),
                          secContainer(state, index),
                        ]);
                  },
                );
              }
              return SpinKitFadingFour(
                color: Color(0xff334A52),
              );
            }),
      ),
    );
  }

  addButton() {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(right: 10, top: 15),
        child: GestureDetector(
          onTap: () {
            print('save');

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => StfLevApplyPage(

                    )));

            // print(selectedClass + "   " + selectedSection + "   " + pickDate);
          },
          child: Align(
            alignment: Alignment.bottomRight,
            child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: ColorConstant.purple900,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    Text('Add Leave',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                  ],
                )),
          ),
        ));
  }

  firContainer(StaffLeaveBalanceLoaded state, int index) {
    int firIndex = index + index;
    String type = state.staffLeaveBalanceModel.postData![firIndex].type
        .toString();
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: 130,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: (type == "Annual Leave")?ColorConstant.annual:
          (type == "Hospitalisation Leave")?ColorConstant.hostpital:
          (type == "Maternity Leave")?ColorConstant.materinity:
          (type == "Medical Leave")?ColorConstant.medical:
          ColorConstant.unpaid,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 13,
                top: 4,
                right: 13,
              ),
              child: Text(
                state.staffLeaveBalanceModel.postData![firIndex].type
                    .toString() +
                    " (" +
                    state
                        .staffLeaveBalanceModel.postData![firIndex].alloted_days
                        .toString() +
                    ")",
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: (type == "Annual Leave")?ColorConstant.black900:
                  (type == "Medical Leave")?ColorConstant.black900:ColorConstant.black900,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: getPadding(
                  left: 12,
                  top: 7,
                  right: 12,
                  bottom: 11,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: getHorizontalSize(
                        100,
                      ),
                      margin: getMargin(
                        top: 25,
                      ),
                      child: Text(
                        "Used (" +
                            state
                                .staffLeaveBalanceModel.postData![firIndex].used
                                .toString() +
                            ")\nAvailable (" +
                            state.staffLeaveBalanceModel.postData![firIndex]
                                .avaliable
                                .toString() +
                            ")",
                        maxLines: null,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: (type == "Annual Leave")?ColorConstant.black900:
                          (type == "Medical Leave")?ColorConstant.black900:ColorConstant.black900,
                          fontSize: getFontSize(
                            16,
                          ),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        bottom: 21,
                      ),
                      child: SvgPicture.asset(
                        "assets/images/img_airplane.svg", //asset location
                        //svg color
                        semanticsLabel: 'SVG From asset folder.',
                        width: 25,
                        height: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  secContainer(StaffLeaveBalanceLoaded state, int index) {
    int secIndex = index + index + 1;
    int length = state.staffLeaveBalanceModel.postData!.length;

    return secIndex == length
        ? Container()
        : Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        height: 130,
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Annual Leave")?ColorConstant.annual:
          (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Hospitalisation Leave")?ColorConstant.hostpital:
          (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Maternity Leave")?ColorConstant.materinity:
          (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Medical Leave")?ColorConstant.medical:
          ColorConstant.unpaid,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: 13,
                top: 4,
                right: 13,
              ),
              child: Text(
                state.staffLeaveBalanceModel.postData![secIndex].type
                    .toString() +
                    " (" +
                    state.staffLeaveBalanceModel.postData![secIndex]
                        .alloted_days
                        .toString() +
                    ")",
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
                style: TextStyle(
                  color: (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Annual Leave")?
                  ColorConstant.whiteA700:
                (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Medical Leave")?
                ColorConstant.black900:ColorConstant.black900,
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: getPadding(
                  left: 12,
                  top: 7,
                  right: 12,
                  bottom: 11,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: getHorizontalSize(
                        100,
                      ),
                      margin: getMargin(
                        top: 25,
                      ),
                      child: Text(
                        "Used (" +
                            state.staffLeaveBalanceModel
                                .postData![secIndex].used
                                .toString() +
                            ")\nAvailable (" +
                            state.staffLeaveBalanceModel
                                .postData![secIndex].avaliable
                                .toString() +
                            ")",
                        maxLines: null,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Annual Leave")?ColorConstant.black900:
                          (state.staffLeaveBalanceModel.postData![secIndex].type.toString() == "Medical Leave")?ColorConstant.black900:ColorConstant.black900,
                          fontSize: getFontSize(
                            16,
                          ),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Padding(
                      padding: getPadding(
                        bottom: 21,
                      ),
                      child: SvgPicture.asset(
                        "assets/images/img_airplane.svg", //asset location
                        //svg color
                        semanticsLabel: 'SVG From asset folder.',
                        width: 25,
                        height: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
