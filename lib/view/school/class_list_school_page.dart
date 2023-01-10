import 'package:dph_tn/model/class_list_by_school_model.dart';
import 'package:dph_tn/view/school/student_list_class_page.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ClassListSchoolPage extends StatelessWidget {
  final schoolId;
  final schoolName;

  ClassListSchoolPage({this.schoolId, this.schoolName});

  @override
  Widget build(BuildContext context) {
    return ClassListSchoolContent(
      schoolId: schoolId,
      schoolName: schoolName,
    );
  }
}

class ClassListSchoolContent extends StatefulWidget {
  final schoolId;
  final schoolName;

  ClassListSchoolContent({this.schoolId, this.schoolName});

  @override
  _ClassListSchoolContentState createState() => _ClassListSchoolContentState();
}

class _ClassListSchoolContentState extends State<ClassListSchoolContent> {
  var mwidth;
  var mHeight;
  var token;

  Future<ClassListBySchoolModel>? futureClassListSchool;

  Future<ClassListBySchoolModel> getClassListBySchool() async {
    var prefs = await SharedPreferences.getInstance();
    token = prefs.getString("mToken");

    ClassListBySchoolModel classListBySchool = await injector
        .classListBySchoolRepo
        .fetchClassListBySchool("api/class/list/" + widget.schoolId);
    if (classListBySchool.success == true) {
      print("ClassListEmp Response: " + classListBySchool.message!);

      return classListBySchool;
    } else {
      print("ClassListEmp Response: " + classListBySchool.message!);
      throw Exception('OrderDetail Failed to load ');
    }
  }

  @override
  void initState() {
    futureClassListSchool = getClassListBySchool();
    super.initState();
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
                    "Class",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Section",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Last Screened Date",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Screen",
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
                                        classId: schoolItem.classId,
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
