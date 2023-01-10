import 'package:connectivity/connectivity.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/attendance/attendance_in_page.dart';
import 'package:dph_tn/view/attendance/attendance_report.dart';
import 'package:dph_tn/view/attendance/attendance_report_offline.dart';
import 'package:dph_tn/view/leave/leave_request_page.dart';
import 'package:dph_tn/view/profile/user_details_page.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AttendancePageContent();
  }
}

class AttendancePageContent extends StatefulWidget {
  @override
  _AttendancePageContentState createState() => _AttendancePageContentState();
}

class _AttendancePageContentState extends State<AttendancePageContent> {
  SharedPreferences? prefs;
  var mwidth;
  var mHeight;
  var empId = "",
      empName = "",
      empRole = "",
      empType = "",
      empFullName = "",
      empInternalId = "",
      empMobile = "";

  @override
  void initState() {
    getUserDetails();
    super.initState();
  }

  void getUserDetails() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      empId = prefs!.getString(Consts.EMP_ID)!;
      empName = prefs!.getString(Consts.USER_NAME)!;
      empRole = prefs!.getString(Consts.RoleName)!;
      empFullName = prefs!.getString(Consts.EmpFullName)!;
      empMobile = prefs!.getString(Consts.MOBILE_NO)!;
      empInternalId = prefs!.getString(Consts.InternalId)!;
      empType = prefs!.getString(Consts.EmployeeTypeName)!;
    });
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
        body: Container(
          child: Stack(
            children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      // color: Color(
                      //     GetColor().getColorHexFromStr(MyColor.gColor)),
                      gradient: LinearGradient(
                        colors: [
                          // Color.fromRGBO(108, 189, 69, 1),
                          // Color.fromRGBO(0, 144, 196, 1)
                          Color(GetColor()
                              .getColorHexFromStr(MyColor.primaryColor)),
                          Color(GetColor()
                              .getColorHexFromStr(MyColor.primaryColor)),
                        ],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                  width: mwidth,
                  height: mHeight / 1.65,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[],
                    ),
                  )),
              Container(
                  // color: Colors.brown,
                  width: mwidth,
                  height: mHeight / 1.2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserDetailsPage()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text("Name",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )),
                              ),
                              Text(": ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                              Expanded(
                                flex: 2,
                                child: Text(empFullName,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Employee ID",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                            Text(": ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                            Expanded(
                              flex: 2,
                              child: Text(empInternalId,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Mobile",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                            Text(": ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                            Expanded(
                              flex: 2,
                              child: Text(empMobile,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text("Designation ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                            Text(": ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                            Expanded(
                              flex: 2,
                              child: Text(empRole,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        "",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 32,
                      ),
                      //
                      Column(
                        children: [
                          Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Color(GetColor().getColorHexFromStr(
                                      MyColor.secondaryColor)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              margin: EdgeInsets.symmetric(horizontal: 48),
                              width: mwidth,
                              child: _alternativeLogin()

                              //
                              ),
                        ],
                      )
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset("images/Dph-Logo.png", height: 88, width: 88),
                    Image.asset("images/Tn-Logo.png",
                        height: 150, width: mwidth / 3),
                    Image.asset("images/Nhm-Logo.png", height: 120, width: 120),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alternativeLogin() {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AttendanceInPage(type: "In")));
            },
            child: Text(
              "Attendance In",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // SizedBox(
          //   height: 16,
          // ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AttendanceInPage(type: "Out")));
            },
            child: Text(
              "Attendance Out",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () async {
              var connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.mobile ||
                  connectivityResult == ConnectivityResult.wifi) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LeaveRequestPage()));
              } else {
                showValidation(
                    Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
              }
            },
            child: Text(
              "Leave Request",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          // SizedBox(
          //   height: 10,
          // ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () async {
              var connectivityResult =
                  await (Connectivity().checkConnectivity());
              if (connectivityResult == ConnectivityResult.mobile ||
                  connectivityResult == ConnectivityResult.wifi) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AttendanceReport()));
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => AttendanceReportOffline()));
              } else {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AttendanceReportOffline()));
              }
            },
            child: Text(
              "Attendance Report",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
