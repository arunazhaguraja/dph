import 'package:dph_tn/helper/database_helper.dart';
import 'package:dph_tn/model/attendance_report_db_model.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceReportOffline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AttendanceReportOfflineContent();
  }
}

class AttendanceReportOfflineContent extends StatefulWidget {
  @override
  _AttendanceReportOfflineContentState createState() =>
      _AttendanceReportOfflineContentState();
}

class _AttendanceReportOfflineContentState
    extends State<AttendanceReportOfflineContent> {
  var mwidth;
  var mHeight;
  var empId = "";
  var empName = "";
  var toDate = "";
  var fromDate = "";
  String endDateApi = "";
  String fromDateApi = "";
  SharedPreferences? prefs;
  DataBaseHelper db = DataBaseHelper();
  var presentDays = "0", workingDays = "26", absentDays = "";

  DateTime? _kFromDatePicker, _kToDatePicker;
  var differenceInDays;
  DateTime? realDates;

  var selectedFromDate = "",
      showFromDateInText = "DD/MM/YYYY",
      selectedToDate = "",
      showToDateInText = "DD/MM/YYYY";

  Future<List<AttendanceReportDbModel>>? fAttendanceReport;

  Future<List<AttendanceReportDbModel>> fetchAttendanceReport() async {
    var res = await db.fetchAttendanceIn();
    setState(() {
      presentDays = res.length.toString();
    });
    return db.fetchAttendanceIn();
  }

  @override
  void initState() {
    fAttendanceReport = fetchAttendanceReport();
    fetchUserDetails();
    getCurrentDateandTime();

    super.initState();
  }

  getCurrentDateandTime() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    final DateFormat formatterM = DateFormat('dd-MM-yyyy');
    //
    final DateFormat endDateFormat = DateFormat('yyyy-MM-dd');
    endDateApi = endDateFormat.format(now);
    var fromYearApi = endDateApi.split("-")[0];
    var fromMonthApi = endDateApi.split("-")[1];
    fromDateApi = fromYearApi + "-" + fromMonthApi + "-" + "01";

    final String formattedToDate = formatter.format(now);
    final String formattedFromDate = formatterM.format(now);

    var fromMonth = formattedFromDate.split("-")[1];
    var fromYear = formattedFromDate.split("-")[2];

    setState(() {
      showToDateInText = formattedToDate;
      showFromDateInText = "01-" + fromMonth + "-" + fromYear;
    });
  }

  fetchUserDetails() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      empId = prefs!.getString(Consts.EMP_ID)!;
      print("Emp Id: " + empId);
      empName = prefs!.getString(Consts.USER_NAME)!;
    });
  }

  getDateFunc() async {
    _kFromDatePicker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (_kFromDatePicker != null) {
      setState(() {
        selectedFromDate = _kFromDatePicker!.month.toString() +
            "/" +
            _kFromDatePicker!.day.toString() +
            "/" +
            _kFromDatePicker!.year.toString();

        showFromDateInText = _kFromDatePicker!.day.toString() +
            "/" +
            _kFromDatePicker!.month.toString() +
            "/" +
            _kFromDatePicker!.year.toString();
      });
      // differenceInDays = _kFromDatePicker.difference(DateTime.now()).inDays;
      differenceInDays = DateTime.now().difference(_kFromDatePicker!).inDays;
      var totalDays = differenceInDays;
      print("Days Different: " + differenceInDays.toString());
      if (totalDays > 30) {
        realDates = _kFromDatePicker!.add(new Duration(days: 30));
        setState(() {
          selectedToDate = realDates!.month.toString() +
              "/" +
              realDates!.day.toString() +
              "/" +
              realDates!.year.toString();
          showToDateInText = realDates!.day.toString() +
              "/" +
              realDates!.month.toString() +
              "/" +
              realDates!.year.toString();
        });
      } else {
        realDates = _kFromDatePicker!.add(new Duration(days: totalDays));
        setState(() {
          selectedToDate = realDates!.month.toString() +
              "/" +
              realDates!.day.toString() +
              "/" +
              realDates!.year.toString();
          showToDateInText = realDates!.day.toString() +
              "/" +
              realDates!.month.toString() +
              "/" +
              realDates!.year.toString();
        });
      }

      // for (var i = 0; i < differenceInDays + 1; i++) {
      //   DateTime realDates = _kFromDatePicker.add(new Duration(days: i));
      // }
    }
  }

  getToDateFunc() async {
    _kToDatePicker = await showDatePicker(
      context: context,
      initialDate: _kFromDatePicker!,
      firstDate: _kFromDatePicker!,
      lastDate: realDates!,
    );
    if (_kToDatePicker != null) {
      setState(() {
        selectedToDate = _kToDatePicker!.month.toString() +
            "/" +
            _kToDatePicker!.day.toString() +
            "/" +
            _kToDatePicker!.year.toString();

        showToDateInText = _kToDatePicker!.day.toString() +
            "/" +
            _kToDatePicker!.month.toString() +
            "/" +
            _kToDatePicker!.year.toString();
      });

      // final differenceInDays = tDate.difference(fDate).inDays;
      // print('$differenceInDays');
      // for (var i = 0; i < differenceInDays + 1; i++) {
      //   DateTime realDates = fDate.add(new Duration(days: i));
      //   var rs = realDates.year.toString() +
      //       "/" +
      //       realDates.month.toString() +
      //       "/" +
      //       realDates.day.toString();
      //   nDays.add(rs);
      //   print("Real Dates: " + rs.toString());
      // }
    }
  }

  previousPage() {
    Navigator.pop(context, "Done");
  }

  @override
  Widget build(BuildContext context) {
    mwidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
      onWillPop: () async {
        previousPage();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              previousPage();
            },
          ),
          title: Text(Consts.APP_NAME),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
              Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
        ),
        body: FutureBuilder<List<AttendanceReportDbModel>>(
            future: fAttendanceReport,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Center(child: Text("No Connection"));
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                default:
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      physics: ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints.loose(
                            Size(double.infinity, double.infinity)),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(
                                children: <Widget>[
                                  Container(
                                      decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(GetColor()
                                                  .getColorHexFromStr(
                                                      MyColor.primaryColor)),
                                              Color(GetColor()
                                                  .getColorHexFromStr(
                                                      MyColor.primaryColor)),
                                            ],
                                            begin: Alignment.topRight,
                                            end: Alignment.bottomLeft,
                                          ),
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(4),
                                              bottomRight: Radius.circular(4))),
                                      width: mwidth,
                                      height: mHeight / 2.5,
                                      child: Center(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[],
                                        ),
                                      )),
                                  Container(
                                      padding: EdgeInsets.only(top: 200),
                                      // color: Colors.brown,
                                      width: mwidth,
                                      // height: mHeight / 1.3,
                                      child: Column(
                                        // mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: [
                                              Container(
                                                  padding: EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                      color: Color(GetColor()
                                                          .getColorHexFromStr(
                                                              MyColor
                                                                  .secondaryColor)),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  8))),
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16),
                                                  width: mwidth,
                                                  child: _attendanceReportList(
                                                      snapshot.data!, toDate)),
                                            ],
                                          )
                                        ],
                                      )),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image.asset("images/Dph-Logo.png",
                                            height: 88, width: 88),
                                        Image.asset("images/Tn-Logo.png",
                                            height: 150, width: mwidth / 3),
                                        Image.asset("images/Nhm-Logo.png",
                                            height: 88, width: 88),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                        child: Text("Error: ",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )));
                  } else {
                    return Center(
                        child: Text("Attendance Not Availabe",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            )));
                  }
              }
            }),
      ),
    );
  }
  //

  Widget _attendanceReportList(
      List<AttendanceReportDbModel> reportList, String toDate) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                empName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w800),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("From", style: TextStyle(color: Colors.black)),
                  TextButton.icon(
                      onPressed: () {
                        getDateFunc();
                      },
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      label: Text(showFromDateInText,
                          style: TextStyle(color: Colors.black)))
                ],
              ),
              Column(
                children: [
                  Text(
                    "To",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton.icon(
                      onPressed: () {
                        getToDateFunc();
                      },
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      label: Text(showToDateInText,
                          style: TextStyle(color: Colors.black)))
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              Text(
                "No of days ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Working",
                          textAlign: TextAlign.center,
                        ),
                        Text(workingDays)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Present",
                          textAlign: TextAlign.center,
                        ),
                        Text(presentDays)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Absent",
                          textAlign: TextAlign.center,
                        ),
                        Text("0")
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        // Container(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [
        //       Expanded(
        //         child: Column(
        //           children: [
        //             Checkbox(
        //               value: false,
        //               onChanged: (v) {},
        //             ),
        //             Text(
        //               "Working days",
        //               textAlign: TextAlign.center,
        //             ),
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         child: Column(
        //           children: [
        //             Checkbox(value: false, onChanged: (v) {}),
        //             Text(
        //               "Absent",
        //               textAlign: TextAlign.center,
        //             ),
        //           ],
        //         ),
        //       ),
        //       Expanded(
        //         child: Column(
        //           children: [
        //             Checkbox(value: false, onChanged: (v) {}),
        //             Text(
        //               "Holiday",
        //               textAlign: TextAlign.center,
        //             ),
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        Container(
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.only(left: 10, right: 10, top: 10),
          decoration: BoxDecoration(
              color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: Text(
                    "Date",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )),
                  Expanded(
                      child: Text("InTime",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("OutTime",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Work Status",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Expanded(
                      child: Text("Day Status",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold)))
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: reportList.length,
                  itemBuilder: (context, index) {
                    var i = reportList[index];
                    return Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            i.addressDate!.split("-")[2].toString() +
                                "- " +
                                i.addressDate!.split("-")[1].toString() +
                                "- " +
                                i.addressDate!.split("-")[0].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: Text(
                            i.inTime!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: Text(
                            i.outTime!,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              _viewReport();
                            },
                            child: Text(
                              "Present",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          )),
                          Expanded(
                              child: Text(
                            "Working Day",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ))
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<Null> _viewReport() async {
    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0.0,
            insetPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)), //this right here
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints.loose(
                      Size(double.infinity, double.infinity)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          width: double.maxFinite,
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.all(8),
                          decoration: new BoxDecoration(
                            color: Color(GetColor()
                                .getColorHexFromStr(MyColor.secondaryColor)),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: const Offset(0.0, 10.0),
                              ),
                            ],
                          ),
                          child: Container(
                            child: Column(
                              children: [
                                Text("Date : 05-12-2020"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Work Status : Absent"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Type of Leave : SL"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Approved by : Karthik Mk"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Approved Role : Egmore PHC MO"),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Approved On : 05 Dec, 2020"),
                                SizedBox(
                                  height: 10,
                                ),
                                MaterialButton(
                                  color: Color(GetColor()
                                      .getColorHexFromStr(MyColor.greenColor)),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Close",
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        });
  }
}
