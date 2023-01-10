import 'package:dph_tn/model/class_list_by_school_model.dart';
import 'package:dph_tn/view/school/student_list_class_page.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentReportPage extends StatelessWidget {
  final schoolId;
  final schoolName;

  StudentReportPage({this.schoolId, this.schoolName});

  @override
  Widget build(BuildContext context) {
    return StudentReportContent(
      schoolId: schoolId,
      schoolName: schoolName,
    );
  }
}

class StudentReportContent extends StatefulWidget {
  final schoolId;
  final schoolName;

  StudentReportContent({this.schoolId, this.schoolName});

  @override
  _StudentReportContentState createState() => _StudentReportContentState();
}

class _StudentReportContentState extends State<StudentReportContent> {
  var mwidth;
  var mHeight;
  var token;

  String endDateApi = "";
  String fromDateApi = "";

  var selectedFromDate = "",
      showFromDateInText = "DD/MM/YYYY",
      selectedToDate = "",
      showToDateInText = "DD/MM/YYYY";

  DateTime? _kFromDatePicker, _kToDatePicker;

  var differenceInDays;
  DateTime? realDates;

  Future<ClassListBySchoolModel>? futureClassListSchool;

  Future<ClassListBySchoolModel> getClassListBySchool() async {
    var prefs = await SharedPreferences.getInstance();
    token = prefs.getString("mToken");

    ClassListBySchoolModel classListBySchool = await injector
        .classListBySchoolRepo
        .fetchClassListBySchool("api/class/list/" + widget.schoolId);
    if (classListBySchool.success == true) {
      print("SchoolListEmp Response: " + classListBySchool.message!);

      return classListBySchool;
    } else {
      print("SchoolListEmp Response: " + classListBySchool.message!);
      throw Exception('OrderDetail Failed to load ');
    }
  }

  @override
  void initState() {
    futureClassListSchool = getClassListBySchool();
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

        fromDateApi = _kFromDatePicker!.year.toString() +
            "-" +
            _kFromDatePicker!.month.toString() +
            "-" +
            _kFromDatePicker!.day.toString();
      });

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
          endDateApi = realDates!.year.toString() +
              "-" +
              realDates!.month.toString() +
              "-" +
              realDates!.day.toString();
        });
        // futureAttendanceReport = fetchFutureAttendanceReport();
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
          endDateApi = realDates!.year.toString() +
              "-" +
              realDates!.month.toString() +
              "-" +
              realDates!.day.toString();
        });
        // futureAttendanceReport = fetchFutureAttendanceReport();
      }
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

        endDateApi = _kToDatePicker!.year.toString() +
            "/" +
            _kToDatePicker!.month.toString() +
            "/" +
            _kToDatePicker!.day.toString();
      });
      // futureAttendanceReport = fetchFutureAttendanceReport();
    }
  }

  @override
  Widget build(BuildContext context) {
    mwidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<ClassListBySchoolModel>(
          future: futureClassListSchool,
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
                                            Color(GetColor().getColorHexFromStr(
                                                MyColor.primaryColor)),
                                            Color(GetColor().getColorHexFromStr(
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
                                                          Radius.circular(8))),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 16),
                                              width: mwidth,
                                              child: _attendanceReportList(
                                                  snapshot.data!.data!),
                                            ),
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
                      child: Text("No Data Found",
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
    );
  }

  Widget _attendanceReportList(List<Data> data) {
    return Column(
      children: [
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
                  Text("From"),
                  TextButton.icon(
                      onPressed: () {
                        getDateFunc();
                      },
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      label: Text(showFromDateInText,
                          style: TextStyle(color: Colors.black)))
                  // Text(showFromDateInText)
                ],
              ),
              Column(
                children: [
                  Text("To"),
                  TextButton.icon(
                      onPressed: () {
                        getToDateFunc();
                      },
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      label: Text(showToDateInText,
                          style: TextStyle(color: Colors.black)))
                  // Text(showToDateInText)
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No of Schools Screened",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Null",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w700))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No of Students Screened",
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Null",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w700))
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No of Students with Conditions found",
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text("Null",
                        style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w700))
                  ],
                ),
              )
            ],
          ),
        ),
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
                    "Student Name",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "School Name",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Class",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Condition",
                    textAlign: TextAlign.center,
                  )),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    var schoolItem = data[index];
                    return Container(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            schoolItem.classNm! != null
                                ? schoolItem.classNm!
                                : "Null",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: Text(
                            schoolItem.section! != null
                                ? schoolItem.section!
                                : "Null",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: Text(
                            schoolItem.lastScreenedDate! != null
                                ? schoolItem.lastScreenedDate!
                                : "Null",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => StudentListClassPage(
                                        schoolId: schoolItem.schoolId,
                                        schoolName: widget.schoolName,
                                      )));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text(
                                "Screen",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white),
                              ),
                            ),
                          )),
                        ],
                      ),
                    );
                  }),
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
