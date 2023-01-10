import 'package:dph_tn/model/student_conditions_model.dart' as StudentCondition;
import 'package:dph_tn/model/student_list_by_class_model.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/school/student_condition_report_page.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentListClassPage extends StatelessWidget {
  final schoolId;
  final schoolName;
  final classId;

  StudentListClassPage({this.schoolId, this.schoolName, this.classId});

  @override
  Widget build(BuildContext context) {
    return StudentListClassContent(
      schoolId: schoolId,
      schoolName: schoolName,
      classId: classId,
    );
  }
}

class StudentListClassContent extends StatefulWidget {
  final schoolId;
  final schoolName;
  final classId;

  StudentListClassContent({this.schoolId, this.schoolName, this.classId});

  @override
  _StudentListClassContentState createState() =>
      _StudentListClassContentState();
}

class _StudentListClassContentState extends State<StudentListClassContent> {
  var mwidth;
  var mHeight;
  var token;
  bool _checkbox = false;

  Future<StudentListByClassModel>? futureStudentListClass;

  Future<StudentListByClassModel> getStudentListClass() async {
    var prefs = await SharedPreferences.getInstance();
    token = prefs.getString("mToken");

    StudentListByClassModel classListBySchool = await injector
        .studentListClassRepo
        .fetchStudentListByClass("api/student/list/" +
            widget.schoolId.toString() +
            "/" +
            widget.classId.toString());
    if (classListBySchool.success == true) {
      print("StudentListByClass Response: " + classListBySchool.message!);

      return classListBySchool;
    } else {
      print("StudentListByClass Response: " + classListBySchool.message!);
      throw Exception('StudentListByClass Failed to load ');
    }
  }

  @override
  void initState() {
    futureStudentListClass = getStudentListClass();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mwidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: FutureBuilder<StudentListByClassModel>(
          future: futureStudentListClass,
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
        Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.schoolName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
        // Container(
        //   padding: EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //       color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
        //       borderRadius: BorderRadius.all(Radius.circular(8))),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: [

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
                    "Student Name",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Attendance Status",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Report",
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
                            schoolItem.firstName! != null
                                ? schoolItem.firstName!
                                : "Null",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          SizedBox(width: 8),
                          schoolItem.attendance == true
                              ? Expanded(
                                  child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.green[700],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Text(
                                      "Present",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                ))
                              : Expanded(
                                  child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 8, right: 8, top: 5, bottom: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.red[700],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Text(
                                      "Absent",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white),
                                    ),
                                  ),
                                )),
                          SizedBox(width: 8),
                          Expanded(
                              child: InkWell(
                            onTap: () {
                              //fetchStudentConditions();
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      StudentConditionReportPage()));
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
                                "Report",
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

  Future<StudentCondition.StudentConditionsModel> fetchLeaveDetailss() async {
    StudentCondition.StudentConditionsModel res = await injector
        .studentConditionsRepo
        .fetchStudentConditions("api/student/screencondition");
    if (res.success!) {
      print("StudentCondition : Success");
      return res;
    } else {
      print("StudentCondition : Failure");
      return res;
    }
  }

  Future<Null> fetchStudentConditions() async {
    return showDialog<Null>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 0.0,
            insetPadding: EdgeInsets.all(0),
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)), //this right here
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
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: new BoxDecoration(
                            color: Color(GetColor()
                                .getColorHexFromStr(MyColor.primaryColor)),
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: const Offset(0.0, 10.0),
                              ),
                            ],
                          ),
                          child: FutureBuilder<
                                  StudentCondition.StudentConditionsModel>(
                              future: fetchLeaveDetailss(),
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
                                      return Container(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Screening Conditions",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(height: 10),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount:
                                                  snapshot.data!.data!.length,
                                              itemBuilder: (context, index) {
                                                var item =
                                                    snapshot.data!.data![index];
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Checkbox(
                                                        value: _checkbox,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _checkbox = true;
                                                          });
                                                        },
                                                      ),
                                                      Flexible(
                                                        child: Text(
                                                          item.name!,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 4,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    } else if (snapshot.hasError) {
                                      if (snapshot.error
                                              .toString()
                                              .split(":")[0] ==
                                          "SocketException") {
                                        return Center(
                                            child: Text(
                                                "Whoops!\nConnection Error" +
                                                    snapshot.hasError
                                                        .toString()));
                                      } else {
                                        return Center(
                                            child:
                                                Text("oh Snap!\nServer Error"));
                                      }
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                }
                              }),
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.topRight,
                          child: CircleAvatar(
                            backgroundColor: Color(GetColor()
                                .getColorHexFromStr(MyColor.primaryColor)),
                            radius: 16,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.white,
                                child: Center(
                                    child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.clear,
                                    color: Colors.brown[700],
                                  ),
                                ))),
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
