import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dph_tn/helper/database_helper.dart';
import 'package:dph_tn/model/attendance_report_db_model.dart';
import 'package:dph_tn/model/employee_role_model.dart';
import 'package:dph_tn/model/out_time_model.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/attendance/attendance_page.dart';
import 'package:dph_tn/view/attendance/attendance_report.dart';
import 'package:dph_tn/view/attendance/attendance_report_offline.dart';
import 'package:dph_tn/view/auth/login.dart';
import 'package:dph_tn/view/leave/leave_request_page.dart';
import 'package:dph_tn/view/profile/user_details_page.dart';
import 'package:dph_tn/view/school/school_list_emp_page.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as Loc;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return HomePageContent();
  }
}

class HomePageContent extends StatefulWidget {
  @override
  _HomePageContentState createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent>
    with WidgetsBindingObserver {
  var mwidth;
  SharedPreferences? prefs;
  var empId = "",
      empName = "",
      attendanceStatus = "",
      attendanceId = "",
      attendanceStatusValue = "",
      empRole = "",
      empType = "",
      empFullName = "",
      empInternalId = "",
      empMobile = "",
      inTime = "-- : --",
      outTime = "-- : --";
  var buildContext;
  String? formattedDateOffline, formattedTimeOffline;
  String currentDate = "";
  String currentTime = "";
  String currentLatitude = "13.051080106337883";
  String currentLongitude = "80.2527520994065";
  String displayDate = "";
  DataBaseHelper db = new DataBaseHelper();
  //
  Future<EmployeeRoleModel>? futureEmployeeRole;
  Future<List<AttendanceReportDbModel>>? _futureOfflineAttendance;
  var userType = "";
  bool? isSchoolAvab;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _futureOfflineAttendance = _fOfflineAttendance();
    // futureEmployeeRole = fFutureEmployeeRole();

    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("didChangeAppLifecycleState: OnResumed");
    }
  }

  Future<List<AttendanceReportDbModel>> _fOfflineAttendance() async {
    isLocationServiceEnabled();
   // final FirebaseMessaging? _firebaseMessaging = FirebaseMessaging.instance;
  //  _firebaseMessaging!.getToken().then((token) => print("FCM :" + token!));
    prefs = await SharedPreferences.getInstance();

    setState(() {
      empId = prefs!.getString(Consts.EMP_ID)!;
      empName = prefs!.getString(Consts.USER_NAME)!;
      empRole = prefs!.getString(Consts.RoleName)!;
      empFullName = prefs!.getString(Consts.EmpFullName)!;
      empMobile = prefs!.getString(Consts.MOBILE_NO)!;
      empInternalId = prefs!.getString(Consts.InternalId)!;
      empType = prefs!.getString(Consts.EmployeeTypeName)!;
      isSchoolAvab = prefs!.getBool(Consts.ISSCHOOLAVAILABLE);
    });
    getCurrentDateandTime();

    print("Current Date: " + formattedDateOffline!);
    var res = await db.fetchAttendanceInByDate(formattedDateOffline!);
    if (res.length == 0) {
      setState(() {
        attendanceStatus = "0";
        attendanceStatusValue = "Kindly check in your attendance";
      });
    } else {
      print("Report: Not");
      var res1 = await db.fetchAttendanceOutByDate(formattedDateOffline!);
      setState(() {
        inTime = res[0].getInTime;
        attendanceStatus = "1";
        attendanceStatusValue = "Kindly check out your attendance";
      });
      if (res1.length == 0) {
      } else {
        outTime = res1[0].getOutTime;
      }
    }
    return res;
  }

  isLocationServiceEnabled() async {
    Loc.Location location = new Loc.Location();

    bool _serviceEnabled;
    Loc.PermissionStatus _permissionGranted;
    Loc.LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      print("Not Location Service enable");
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        print("Not Location Service enable");
        return;
      } else {
        print(" Location Service enable");
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == Loc.PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != Loc.PermissionStatus.granted) {
            return;
          }
        }

        _locationData = await location.getLocation();
        print("Latitude: " + _locationData.latitude.toString());
        print("Longitude: " + _locationData.longitude.toString());
      }
    } else {
      print(" Location Service enable");
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == Loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != Loc.PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();
      setState(() {
        currentLatitude = _locationData.latitude.toString();
        currentLongitude = _locationData.longitude.toString();
      });
      print("Latitude: " + _locationData.latitude.toString());
      print("Longitude: " + _locationData.longitude.toString());
    }
  }

  // Future<EmployeeRoleModel> fFutureEmployeeRole() async {
  //   var response = await injector.empRoleRepo
  //       .fetchEmpRoleResponse("api/employee/useraccess/" + empId);
  //   if (response.success == true) {
  //     for (var item in response.data) {
  //       if (item.id == 1) {
  //         userType = "1";
  //       }
  //       if (item.id == 2) {
  //         userType = "2";
  //       }
  //       if (item.id == 1 && item.id == 2) {
  //         userType = "1,2";
  //       }
  //     }

  //     fetchAttendanceStatus("", "");
  //     return response;
  //   } else {
  //     return response;
  //   }
  // }

  void progressDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          buildContext = context;
          return AlertDialog(
            content: Row(
              children: <Widget>[
                new CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Loading..."),
                ),
              ],
            ),
          );
        });
  }

  getCurrentDateandTime() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat formatterOffline = DateFormat('yyyy-MM-dd');
    final DateFormat formatterTime = DateFormat('HH:mm:ss');
    final DateFormat formatterTimeOffline = DateFormat('h:mm a');
    final String formatted = formatter.format(now);
    formattedDateOffline = formatterOffline.format(now);
    formattedTimeOffline = formatterTimeOffline.format(now);
    final String formattedTime = formatterTime.format(now);
    final DateFormat displayFormat = DateFormat('MMMEd');
    displayDate = displayFormat.format(now);

    print("Date: " + formattedDateOffline! + " Time: " + formattedTimeOffline!);

    setState(() {
      currentDate = formatted;
      currentTime = formattedTime;
    });
  }

  fetchAttendanceStatus(String e, String url) async {
    var encoded = json.encode({
      "EmpId": empId,
      "Lattitude": "",
      "Longtitude": "",
      "Altitude": "",
      "InternetStatus": "",
      "AddressDate": currentDate,
      "InTime": currentTime
    });
    print("Check Request: " + encoded.toString());
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var res = await injector.attendanceStatusRepo
          .fetchAttendanceStatusResponse(encoded);
      print("Attendance Status Api Response" + res.toString());
      if (res.success == true) {
        if (res.data![0].attendanceId == 0) {
          setState(() {
            attendanceStatus = "0";
            attendanceStatusValue = "Kinldy check in your attendance";
          });

          print("Attendance not done");
        } else {
          setState(() {
            attendanceStatus = "1";
            attendanceStatusValue = "Attendance checked in";
            attendanceId = res.data![0].attendanceId.toString();
          });

          print("Attendance done");
        }
      } else {}
    } else {
      // showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
      var res = await db.fetchAttendanceInByDate(formattedDateOffline!);
      if (res.length == 0) {
        setState(() {
          attendanceStatus = "0";
          attendanceStatusValue = "Kinldy check in your attendance";
        });
      } else {
        setState(() {
          attendanceStatus = "1";
          attendanceStatusValue = "Attendance checked in";
        });
      }
    }
  }

  void submitUserDetails(
      BuildContext context, String encoded, String url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("Connected to Network");
      progressDialog(context);

      var res = await injector.commonRepo.fetchCommonUserResponse(encoded, url);

      if (res.success == true) {
        Navigator.pop(buildContext);
        showValidation("Attendance", "Submitted Successfully", context);
      } else {
        Navigator.pop(buildContext);
        print("Response" + res.toString());
        showValidation(res.message!, res.errors![0], context);
      }
    } else {
      showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  void submitUserDetailsINN(
      BuildContext context, String encoded, String url) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("Connected to Network");
      progressDialog(context);

      var res = await injector.commonRepo.fetchCommonUserResponse(encoded, url);

      if (res.success == true) {
        Navigator.pop(buildContext);
        showValidation("Attendance", "Submitted Successfully", context);
        setState(() {
          attendanceStatus = "1";
          attendanceStatusValue = "Attendance checked in";
        });
      } else {
        Navigator.pop(buildContext);
        print("Response" + res.toString());
        showValidation(res.message!, res.errors![0], context);
      }
    } else {
      showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    mwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 100,
        leading: Image.asset("images/Dph-Logo.png", height: 50, width: 50),
        title: Image.asset(
          'images/Tn-Logo.png',
          height: 75,
          width: 100,
          fit: BoxFit.contain,
        ),
        actions: [Image.asset("images/Nhm-Logo.png", height: 80, width: 80)],
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
            // gradient: LinearGradient(
            //   colors: [
            //     // Color.fromRGBO(108, 189, 69, 1),
            //     // Color.fromRGBO(0, 144, 196, 1),
            //     Color(GetColor().getColorHexFromStr(MyColor.daileBlue)),
            //     Color(GetColor().getColorHexFromStr(MyColor.daileGreen)),
            //   ],
            //   begin: Alignment.topRight,
            //   end: Alignment.bottomLeft,
            // ),
          ),
        ),
      ),
      backgroundColor:
          Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
      body: FutureBuilder<List<AttendanceReportDbModel>>(
          future: _futureOfflineAttendance,
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
                          children: [
                            Expanded(
                              flex: 0,
                              child: Container(
                                margin: EdgeInsets.all(8),
                                width: mwidth,
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UserDetailsPage()));
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16),
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
                                                    color: Colors.white,
                                                    fontSize: 16)),
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
                                                    color: Colors.white,
                                                    fontSize: 16)),
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
                                                    color: Colors.white,
                                                    fontSize: 16)),
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
                                                    color: Colors.white,
                                                    fontSize: 16)),
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
                                                    color: Colors.white,
                                                    fontSize: 16)),
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
                                                    color: Colors.white,
                                                    fontSize: 16)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(displayDate,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8, right: 8),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.access_time,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(inTime,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text("In time",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              Icon(
                                                Icons.access_time_rounded,
                                                color: Colors.white,
                                                size: 16,
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(outTime,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18)),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text("Out time",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(attendanceStatusValue,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18)),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 8, right: 8),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          color: Color(GetColor()
                                              .getColorHexFromStr(
                                                  MyColor.daileWhite)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Container(
                                          //   width: 76.0,
                                          //   height: 76.0,
                                          //   padding: EdgeInsets.only(
                                          //       left: 8.0, right: 8.0),
                                          //   child: Center(
                                          //       child: new Image.asset(
                                          //     "images/log-in.png",
                                          //     width: 42.0,
                                          //     height: 42.0,
                                          //   )),
                                          //   decoration: BoxDecoration(
                                          //     boxShadow: [
                                          //       BoxShadow(
                                          //           color: Colors.black45,
                                          //           blurRadius: 1.5)
                                          //     ],
                                          //     shape: BoxShape.circle,
                                          //     gradient: LinearGradient(
                                          //       colors: [
                                          //         Color(0xff568E91),
                                          //         Color(0xff44CE88),
                                          //       ],
                                          //       begin: FractionalOffset.topRight,
                                          //       end: FractionalOffset.bottomLeft,
                                          //     ),
                                          //   ),
                                          // ),

                                          attendanceStatus == "0"
                                              ? InkWell(
                                                  onTap: () async {
                                                    // Attendance In
                                                    getCurrentDateandTime();
                                                    var connectivityResult =
                                                        await (Connectivity()
                                                            .checkConnectivity());
                                                    if (connectivityResult ==
                                                            ConnectivityResult
                                                                .mobile ||
                                                        connectivityResult ==
                                                            ConnectivityResult
                                                                .wifi) {
                                                      var res1 = await db.insertAttendanceIn(
                                                          AttendanceReportDbModel(
                                                              empId: empId,
                                                              image: "",
                                                              lattitude:
                                                                  currentLatitude,
                                                              longtitude:
                                                                  currentLongitude,
                                                              altitude: "",
                                                              internetStatus:
                                                                  "Yes",
                                                              addressDate:
                                                                  formattedDateOffline!,
                                                              inTime:
                                                                  formattedTimeOffline!,
                                                              attendType: "In",
                                                              outTime: "--:--",
                                                              inTimeStatus:
                                                                  "Yes",
                                                              outTimeStatus:
                                                                  "-"));

                                                      if (res1 > 0) {
                                                        setState(() {
                                                          inTime =
                                                              formattedTimeOffline!;
                                                        });
                                                        print(
                                                            "AttendanceIn inserted successfully");
                                                        var encoded =
                                                            json.encode({
                                                          "EmpId": empId,
                                                          "Image": "",
                                                          "Lattitude":
                                                              currentLatitude,
                                                          "Longtitude":
                                                              currentLongitude,
                                                          "Altitude": "",
                                                          "InternetStatus":
                                                              "Yes",
                                                          "AddressDate":
                                                              currentDate,
                                                          "InTime": currentTime
                                                        });
                                                        submitUserDetailsINN(
                                                            context,
                                                            encoded,
                                                            "api/attendance/employeein");
                                                      } else {
                                                        print(
                                                            "Failed: to update item");
                                                      }
                                                    } else {
                                                      // Offline
                                                      var res = await db.insertAttendanceIn(
                                                          AttendanceReportDbModel(
                                                              empId: empId,
                                                              image: "",
                                                              lattitude:
                                                                  currentLatitude,
                                                              longtitude:
                                                                  currentLongitude,
                                                              altitude: "",
                                                              internetStatus:
                                                                  "No",
                                                              addressDate:
                                                                  formattedDateOffline!,
                                                              inTime:
                                                                  formattedTimeOffline!,
                                                              attendType: "In",
                                                              outTime: "--:--",
                                                              inTimeStatus:
                                                                  "No",
                                                              outTimeStatus:
                                                                  "-"));

                                                      if (res > 0) {
                                                        setState(() {
                                                          inTime =
                                                              formattedTimeOffline!;
                                                        });
                                                        print(
                                                            "AttendanceIn inserted successfully");
                                                        showValidation(
                                                            "Attendance",
                                                            "Submitted Successfully",
                                                            context);
                                                        setState(() {
                                                          attendanceStatus =
                                                              "1";
                                                          attendanceStatusValue =
                                                              "Attendance checked in";
                                                        });
                                                      } else {
                                                        print(
                                                            "Failed: to update item");
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                          "images/log-in.png",
                                                          height: 75,
                                                          width: 75),
                                                      Text("Attendance In")
                                                    ],
                                                  ),
                                                )
                                              : InkWell(
                                                  onTap: () async {
                                                    // Attendance Out
                                                    getCurrentDateandTime();
                                                    var connectivityResult =
                                                        await (Connectivity()
                                                            .checkConnectivity());
                                                    if (connectivityResult ==
                                                            ConnectivityResult
                                                                .mobile ||
                                                        connectivityResult ==
                                                            ConnectivityResult
                                                                .wifi) {
                                                      // var res1 = await db.insertAttendanceIn(
                                                      //     AttendanceReportDbModel(
                                                      //         empId: empId,
                                                      //         image: "",
                                                      //         lattitude:
                                                      //             currentLatitude,
                                                      //         longtitude:
                                                      //             currentLongitude,
                                                      //         altitude: "",
                                                      //         internetStatus: "Yes",
                                                      //         addressDate:
                                                      //             formattedDateOffline,
                                                      //         inTime:
                                                      //             formattedTimeOffline,
                                                      //         attendType: "Out"));
                                                      var res1 = await db
                                                          .updateOutTime(OutTimeModel(
                                                              date:
                                                                  formattedDateOffline!,
                                                              outTime:
                                                                  formattedTimeOffline!,
                                                              attendType: "Out",
                                                              internetStatus:
                                                                  "Yes",
                                                              outTimeStatus:
                                                                  "Yes"));
                                                      if (res1 > 0) {
                                                        setState(() {
                                                          outTime =
                                                              formattedTimeOffline!;
                                                        });
                                                        var encodeds =
                                                            json.encode({
                                                          "EmpId": empId,
                                                          "Lattitude": "",
                                                          "Longtitude": "",
                                                          "Altitude": "",
                                                          "InternetStatus": "",
                                                          "AddressDate":
                                                              currentDate,
                                                          "InTime": currentTime
                                                        });
                                                        var res = await injector
                                                            .attendanceStatusRepo
                                                            .fetchAttendanceStatusResponse(
                                                                encodeds);
                                                        print(
                                                            "Attendance Status Api Response" +
                                                                res.toString());
                                                        if (res.success ==
                                                            true) {
                                                          if (res.data![0]
                                                                  .attendanceId ==
                                                              0) {
                                                            setState(() {
                                                              attendanceStatus =
                                                                  "0";
                                                              attendanceStatusValue =
                                                                  "Kinldy check in your attendance";
                                                            });

                                                            print(
                                                                "Attendance not done");
                                                          } else {
                                                            setState(() {
                                                              attendanceStatus =
                                                                  "1";
                                                              attendanceStatusValue =
                                                                  "Attendance checked in";
                                                              attendanceId = res
                                                                  .data![0]
                                                                  .attendanceId
                                                                  .toString();
                                                            });

                                                            print(
                                                                "Attendance done");
                                                          }
                                                        }

                                                        var encoded =
                                                            json.encode({
                                                          "Attendance_Id":
                                                              attendanceId,
                                                          "EmpId": empId,
                                                          "Image": "",
                                                          "Lattitude":
                                                              currentLatitude,
                                                          "Longtitude":
                                                              currentLongitude,
                                                          "Altitude": "",
                                                          "InternetStatus":
                                                              "Yes",
                                                          "AddressDate":
                                                              currentDate,
                                                          "InTime": currentTime
                                                        });
                                                        print(
                                                            "attendance out: " +
                                                                encoded
                                                                    .toString());
                                                        submitUserDetails(
                                                            context,
                                                            encoded,
                                                            "api/attendance/employeeout");
                                                      } else {
                                                        print(
                                                            "Failed: to update item");
                                                      }
                                                    } else {
                                                      // Offline
                                                      // var res = await db.insertAttendanceIn(
                                                      //     AttendanceReportDbModel(
                                                      //         empId: empId,
                                                      //         image: "",
                                                      //         lattitude:
                                                      //             currentLatitude,
                                                      //         longtitude:
                                                      //             currentLongitude,
                                                      //         altitude: "",
                                                      //         internetStatus: "No",
                                                      //         addressDate:
                                                      //             formattedDateOffline,
                                                      //         //  addressDate: "2012-12-24",
                                                      //         inTime:
                                                      //             formattedTimeOffline,
                                                      //         attendType: "Out"));
                                                      var res = await db
                                                          .updateOutTime(OutTimeModel(
                                                              date:
                                                                  formattedDateOffline!,
                                                              outTime:
                                                                  formattedTimeOffline!,
                                                              attendType: "Out",
                                                              internetStatus:
                                                                  "No",
                                                              outTimeStatus:
                                                                  "No"));

                                                      if (res > 0) {
                                                        setState(() {
                                                          outTime =
                                                              formattedTimeOffline!;
                                                        });
                                                        print(
                                                            "Attendance Out inserted successfully");
                                                        showValidation(
                                                            "Attendance",
                                                            "Submitted Successfully",
                                                            context);
                                                      } else {
                                                        print(
                                                            "Failed: to update item");
                                                      }
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Image.asset(
                                                          "images/log-out.png",
                                                          height: 75,
                                                          width: 75),
                                                      Text("Attendance Out")
                                                    ],
                                                  ),
                                                ),
                                          SizedBox(
                                            width: 24,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var connectivityResult =
                                                  await (Connectivity()
                                                      .checkConnectivity());
                                              if (connectivityResult ==
                                                      ConnectivityResult
                                                          .mobile ||
                                                  connectivityResult ==
                                                      ConnectivityResult.wifi) {
                                                final result = await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            LeaveRequestPage()));
                                                if (result == "Done") {
                                                  print("Done");
                                                  _fOfflineAttendance();
                                                }
                                              } else {
                                                showValidation(
                                                    Consts.CONNECTION_TITLE,
                                                    Consts.CONNECTION_MSG,
                                                    context);
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                    "images/out-of-stock.png",
                                                    height: 75,
                                                    width: 75),
                                                Text("Leave Request")
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 0,
                              child: Container(
                                padding: EdgeInsets.only(left: 16, right: 16),
                                //color: Colors.teal[300],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {},
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              final result = await Navigator.of(
                                                      context)
                                                  .push(MaterialPageRoute(
                                                      builder: (context) =>
                                                          AttendancePage()));
                                              if (result == "Done") {
                                                print("Executed: ");
                                                _fOfflineAttendance();
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "images/immigration.png",
                                                  height: 75,
                                                  width: 75,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text("Attendance",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 0.5,
                                            height: 120,
                                            color: Colors.white,
                                          ),
                                          InkWell(
                                            onTap: () async {
                                              var connectivityResult =
                                                  await (Connectivity()
                                                      .checkConnectivity());
                                              if (connectivityResult ==
                                                      ConnectivityResult
                                                          .mobile ||
                                                  connectivityResult ==
                                                      ConnectivityResult.wifi) {
                                                print("Online: ");
                                                Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            AttendanceReport()));
                                              } else {
                                                print("Offline: ");
                                                final result = await Navigator
                                                        .of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            AttendanceReportOffline()));
                                                if (result == "Done") {
                                                  print("Previous Executed: ");
                                                  _fOfflineAttendance();
                                                }
                                              }
                                            },
                                            child: Column(
                                              children: [
                                                Image.asset(
                                                  "images/business-report.png",
                                                  height: 75,
                                                  width: 75,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text("Attendance Reports",
                                                    style: TextStyle(
                                                        color: Colors.white)),
                                                SizedBox(
                                                  height: 10,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    isSchoolAvab == true
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  var connectivityResult =
                                                      await (Connectivity()
                                                          .checkConnectivity());
                                                  if (connectivityResult ==
                                                          ConnectivityResult
                                                              .mobile ||
                                                      connectivityResult ==
                                                          ConnectivityResult
                                                              .wifi) {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                SchoolListEmpPage()));
                                                  } else {
                                                    print("Offline: ");
                                                  }
                                                },
                                                child: Column(
                                                  children: [
                                                    Image.asset(
                                                      "images/medical-history.png",
                                                      height: 75,
                                                      width: 75,
                                                      color: Colors.white,
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("School",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    SizedBox(
                                                      height: 10,
                                                    )
                                                  ],
                                                ),
                                              ),
                                              // Container(
                                              //   width: 0.5,
                                              //   height: 120,
                                              //   color: Colors.white,
                                              // ),
                                              // InkWell(
                                              //   onTap: () async {
                                              //     var connectivityResult =
                                              //         await (Connectivity()
                                              //             .checkConnectivity());
                                              //     if (connectivityResult ==
                                              //             ConnectivityResult.mobile ||
                                              //         connectivityResult ==
                                              //             ConnectivityResult.wifi) {
                                              //       Navigator.of(context).push(
                                              //           MaterialPageRoute(
                                              //               builder: (context) =>
                                              //                   AttendanceReport()));
                                              //     } else {
                                              //       print("Offline: ");
                                              //     }
                                              //   },
                                              //   child: Column(
                                              //     children: [
                                              //       Image.asset(
                                              //         "images/business-report.png",
                                              //         height: 75,
                                              //         width: 75,
                                              //         color: Colors.white,
                                              //       ),
                                              //       SizedBox(
                                              //         height: 10,
                                              //       ),
                                              //       Text("School Reports",
                                              //           style: TextStyle(
                                              //               color: Colors.white)),
                                              //       SizedBox(
                                              //         height: 10,
                                              //       )
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          )
                                        : SizedBox(),
                                    TextButton(
                                        onPressed: () {
                                          logout();
                                        },
                                        child: Text(
                                          "Sign Out",
                                          style: TextStyle(color: Colors.white),
                                        ))
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: " + snapshot.data.toString(),
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

  logout() async {
    var prefs = await SharedPreferences.getInstance();
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Logout"),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4))),
            content: Text("Do you want to logout?"),
            actions: <Widget>[
  TextButton(                  onPressed: () async {
                    Navigator.of(context).pop();
                    // prefs.setString("isLogged", "notLogged");
                    progressDialog(context);
                    var res = await db.deleteUserData(empId);

                    if (res > 0) {
                      print("data available Db");
                      Navigator.pop(buildContext);
                      prefs.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    } else {
                      Navigator.pop(buildContext);
                      print("Db null");
                      prefs.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => LoginPage()),
                          (Route<dynamic> route) => false);
                    }
                  },
                  child: Text(Consts.OK)),
  TextButton(                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("CANCEL")),
            ],
          );
        });
  }
}
