import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dph_tn/di/dependency_injection.dart';
import 'package:dph_tn/helper/database_helper.dart';
import 'package:dph_tn/model/attendance_report_db_model.dart';
import 'package:dph_tn/model/internet_status_model.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/auth/login.dart';
import 'package:dph_tn/view/home/homepage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Injector injector = Injector();

Future<bool> checkConnection() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    return true;
  } else {
    return false;
  }
}

enum LoginType { defaults, alternative, forget, fingerprint }

// BuildContext progressDialog(BuildContext context) {
//   var buildContext;
//   showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         buildContext = context;
//         return AlertDialog(
//           content: Row(
//             children: <Widget>[
//               new CircularProgressIndicator(),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text("Loading..."),
//               ),
//             ],
//           ),
//         );
//       });
//   return buildContext;
// }

void showValidation(String title, String msg, BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4))),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(Consts.OK))
          ],
        );
      });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DaileFresh',
      theme: ThemeData(
          fontFamily: 'OpenSans',
          unselectedWidgetColor: Colors.white,
          textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Color(GetColor().getColorHexFromStr(MyColor.daileBlue)),
                fontSize: 16,
                fontWeight: FontWeight.w800),
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
 

 

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DataBaseHelper _dataBaseHelper = new DataBaseHelper();
  //
  Future<Timer> loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var isKeyAvailable = prefs.containsKey(Consts.ISLOGGED);
    if (isKeyAvailable) {
      if (isKeyAvailable == true) {
        var connectivityResult = await (Connectivity().checkConnectivity());
        if (connectivityResult == ConnectivityResult.mobile ||
            connectivityResult == ConnectivityResult.wifi) {
          return new Timer(Duration(seconds: 1), goToInsertAttendancePage);
        } else {
          return new Timer(Duration(seconds: 1), goToHomePage);
        }
      } else {
        return new Timer(Duration(seconds: 1), goToLoginPage);
      }
    } else {
      return new Timer(Duration(seconds: 1), goToLoginPage);
    }
  }

  void submitUserDetails(String encoded, String addressDate, String url,
      String aType, String aStatus) async {
    print("Attendance Post Request: " + encoded);
    print("Attendance Url: " + url);
    print("Attendance Type: " + aType);
    print("Attendance Status: " + aStatus);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      var res = await injector.commonRepo.fetchCommonUserResponse(encoded, url);

      if (res.success == true) {
        print("Splash Response " + res.message.toString());
        if (aType == "In") {
          int result = await _dataBaseHelper.updateInternetStatus(
              InternetStatusModel(
                  internetStatus: "Yes",
                  date: addressDate,
                  inTimeStatus: "Yes",
                  outTimeStatus: aStatus));
          if (result != 0) {
            print("Updated Successfully");
          } else {
            print("Error in Update");
          }
        } else {
          int result = await _dataBaseHelper.updateInternetStatus(
              InternetStatusModel(
                  internetStatus: "Yes",
                  date: addressDate,
                  inTimeStatus: aStatus,
                  outTimeStatus: "Yes"));
          if (result != 0) {
            print("Updated Successfully");
          } else {
            print("Error in Update");
          }
        }
      } else {
        print("Splash Response" + res.errors![0]);
      }
    } else {
      // showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  goToLoginPage() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  goToHomePage() async {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  goToInsertAttendancePage() async {
    List<AttendanceReportDbModel> attendanceReport =
        await _dataBaseHelper.fetchAttendanceInReportOffline("No");
    if (attendanceReport.length == 0) {
    } else {
      print("Updated lenght In: " + attendanceReport.length.toString());
      for (var item in attendanceReport) {
        var encodeds = json.encode({
          "EmpId": item.empId,
          "Lattitude": "",
          "Longtitude": "",
          "Altitude": "",
          "InternetStatus": "",
          "AddressDate": item.addressDate,
          "InTime": item.inTime
        });
        var res = await injector.attendanceStatusRepo
            .fetchAttendanceStatusResponse(encodeds);
        if (res.success == true) {
          if (res.data![0].attendanceId == 0) {
            var encoded = json.encode({
              "EmpId": item.empId,
              "Image": item.image != null ? item.image : "",
              "Lattitude":
                  item.lattitude.toString != null ? item.lattitude : "",
              "Longtitude":
                  item.longtitude.toString != null ? item.longtitude : "",
              "Altitude": "",
              "InternetStatus": "Yes",
              "AddressDate": item.addressDate,
              "InTime": item.inTime
            });
            print("Attendance In API: " + encoded.toString());
            submitUserDetails(encoded, item.addressDate!,
                "api/attendance/employeein", "In", item.getOutTimeStatus);

            print("Attendance not done");
          } else {
            var attendanceId = res.data![0].attendanceId.toString();
            var encoded = json.encode({
              "Attendance_Id": attendanceId,
              "EmpId": item.empId,
              "Image": item.image != null ? item.image : "",
              "Lattitude":
                  item.lattitude.toString != null ? item.lattitude : "",
              "Longtitude":
                  item.longtitude.toString != null ? item.longtitude : "",
              "Altitude": "",
              "InternetStatus": "Yes",
              "AddressDate": item.addressDate,
              "InTime": item.outTime
            });
            print("Attendance Out API: " + encoded.toString());
            submitUserDetails(encoded, item.addressDate!,
                "api/attendance/employeeout", "Out", item.getInTimeStatus);
          }
        } else {
          print("Api Error check in and out");
        }
      }
    }

    List<AttendanceReportDbModel> attendanceReportOut =
        await _dataBaseHelper.fetchAttendanceOutReportOffline("No");
    if (attendanceReportOut.length == 0) {
    } else {
      print("Updated lenght Out: " + attendanceReportOut.length.toString());
      print("Out Time:");
      for (var item in attendanceReportOut) {
        var encodeds = json.encode({
          "EmpId": item.empId,
          "Lattitude": "",
          "Longtitude": "",
          "Altitude": "",
          "InternetStatus": "",
          "AddressDate": item.addressDate,
          "InTime": item.inTime
        });
        var res = await injector.attendanceStatusRepo
            .fetchAttendanceStatusResponse(encodeds);
        if (res.success == true) {
          if (res.data![0].attendanceId == 0) {
            var encoded = json.encode({
              "EmpId": item.empId,
              "Image": item.image != null ? item.image : "",
              "Lattitude":
                  item.lattitude.toString != null ? item.lattitude : "",
              "Longtitude":
                  item.longtitude.toString != null ? item.longtitude : "",
              "Altitude": "",
              "InternetStatus": "Yes",
              "AddressDate": item.addressDate,
              "InTime": item.inTime
            });
            print("Attendance In API: " + encoded.toString());
            submitUserDetails(encoded, item.addressDate!,
                "api/attendance/employeein", "In", item.getOutTimeStatus);

            print("Attendance not done");
          } else {
            var attendanceId = res.data![0].attendanceId.toString();
            var encoded = json.encode({
              "Attendance_Id": attendanceId,
              "EmpId": item.empId,
              "Image": item.image != null ? item.image : "",
              "Lattitude":
                  item.lattitude.toString != null ? item.lattitude : "",
              "Longtitude":
                  item.longtitude.toString != null ? item.longtitude : "",
              "Altitude": "",
              "InternetStatus": "Yes",
              "AddressDate": item.addressDate,
              "InTime": item.outTime
            });
            print("Attendance Out API: " + encoded.toString());
            submitUserDetails(encoded, item.addressDate!,
                "api/attendance/employeeout", "Out", item.getInTimeStatus);
          }
        } else {
          print("Api Error check in and out");
        }
      }
    }
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(GetColor().getColorHexFromStr(MyColor.gColor)),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            // Color.fromRGBO(108, 189, 69, 1),
            // Color.fromRGBO(0, 144, 196, 1)
            Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
            Color(GetColor().getColorHexFromStr(MyColor.primaryColor))
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        )),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "images/Tn-Logo.png",
                height: 150,
                width: 150,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                Consts.APP_NAME,
                style: TextStyle(fontSize: 20, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
