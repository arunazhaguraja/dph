import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dph_tn/helper/database_helper.dart';
import 'package:dph_tn/model/attendance_report_db_model.dart';
import 'package:dph_tn/model/out_time_model.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/custom_camera/camera_screen.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart' as Loc;

class AttendanceInPage extends StatelessWidget {
  final type;

  AttendanceInPage({this.type});

  @override
  Widget build(BuildContext context) {
    return AttendanceInContent(type: type);
  }
}

class AttendanceInContent extends StatefulWidget {
  final type;

  AttendanceInContent({this.type});

  @override
  _AttendanceInContentState createState() => _AttendanceInContentState();
}

class _AttendanceInContentState extends State<AttendanceInContent> {
  //
  var mwidth;
  var mHeight;
  var buildContext;
  //
  PickedFile? imageURI;
  var _permissionGranted;
  final ImagePicker _picker = ImagePicker();
  String img64 = "";
  String currentDate = "";
  String currentTime = "";
  String currentLatitude = "13.051080106337883";
  String currentLongitude = "80.2527520994065";
  SharedPreferences? prefs;
  var empId = "", empName = "";
  //
  String? formattedDateOffline, formattedTimeOffline;
  DataBaseHelper db = new DataBaseHelper();

  String? imagePath;
  var _kPath = "";
  bool isCameraActivated = false;

  Future getImageFromGallery() async {
    var image = await _picker.getImage(
      source: ImageSource.gallery,
    );
    File f = File(image!.path);

    var fileLength = await f.length();
    if (fileLength > 2000000) {
      showValidation(
          "Kindly choose image less than 2mb", "Image size exceed", context);
    } else {
      var bytes = await f.readAsBytes();
      img64 = base64Encode(bytes);
      print("Image base64: " + img64);

      setState(() {
        imageURI = image;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentDateandTime();
  }

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
    prefs = await SharedPreferences.getInstance();

    print("Date: " + formattedDateOffline! + " Time: " + formattedTimeOffline!);

    setState(() {
      empId = prefs!.getString(Consts.EMP_ID)!;
      empName = prefs!.getString(Consts.USER_NAME)!;
      currentDate = formatted;
      currentTime = formattedTime;
    });
    isLocationServiceEnabled();
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

  @override
  void dispose() {
    super.dispose();
  }

  DataBaseHelper databaseHelper = DataBaseHelper();

  @override
  Widget build(BuildContext context) {
    mwidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(Consts.APP_NAME),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints:
              BoxConstraints.loose(Size(double.infinity, double.infinity)),
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Stack(
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
                                  bottomLeft: Radius.circular(25),
                                  bottomRight: Radius.circular(25))),
                          width: mwidth,
                          height: mHeight / 2.5,
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[],
                            ),
                          )),
                      Container(
                          padding: EdgeInsets.only(top: 150),
                          // color: Colors.brown,
                          width: mwidth,
                          // height: mHeight / 1.3,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              // Padding(
                              //   padding: const EdgeInsets.only(left: 10, right: 10),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Expanded(
                              //         child: Text(
                              //           "Emp Name : " + empName,
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //               fontSize: 18,
                              //               color: Colors.white,
                              //               fontWeight: FontWeight.w800),
                              //         ),
                              //       ),
                              //       Expanded(
                              //         child: Text(
                              //           "Emp ID : " + empId,
                              //           textAlign: TextAlign.center,
                              //           style: TextStyle(
                              //               fontSize: 18,
                              //               color: Colors.white,
                              //               fontWeight: FontWeight.w800),
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(
                              //   height: 16,
                              // ),
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
                                          color: Color(GetColor()
                                              .getColorHexFromStr(
                                                  MyColor.secondaryColor)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      width: mwidth,
                                      child: _profile()

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
                            Image.asset("images/Dph-Logo.png",
                                height: 88, width: 88),
                            Image.asset("images/Tn-Logo.png",
                                height: 150, width: mwidth / 3),
                            Image.asset("images/Nhm-Logo.png",
                                height: 120, width: 120),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _profile() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                  // color: Colors.red
                  ),
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 16),
              child: CircleAvatar(
                backgroundColor: Colors.grey[300],
                maxRadius: 50,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: CircleAvatar(
                    // backgroundImage: _kPath != ""
                    //     ? FileImage(File(_kPath))
                    //     : ExactAssetImage("images/User.png"),
                    backgroundImage: FileImage(File(_kPath)),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(
                          Icons.camera_alt,
                          color: Color(GetColor()
                              .getColorHexFromStr(MyColor.focusMaroon)),
                        )),
                    // child: imageURI != null
                    //     ? Image.file(File(imageURI.path))
                    //     : Text("")),
                    radius: 47,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
            MaterialButton(
              color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
              onPressed: () async {
                if (await Permission.storage.request().isGranted) {
                  print("Status: isGranted");
                  //getImageFromGallery();
                  // _onCapturePressed();
                  final result = await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CameraScreen()));
                  print("Image Path: " + result);
                  if (result != null) {
                    setState(() {
                      _kPath = result;
                    });
                  } else {
                    print("Image Empty");
                  }
                } else if (await Permission.storage.request().isDenied) {
                  print("Status: isDenied");
                }
              },
              child: Text(
                "Capture",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 24,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1, child: Text("Time: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(formattedTimeOffline!,
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 1,
                child: Text(
                  "Date: ",
                  style: TextStyle(fontSize: 16),
                )),
            Expanded(
                child: Text(
                    formattedDateOffline!.split("-")[2] +
                        "-" +
                        formattedDateOffline!.split("-")[1] +
                        "-" +
                        formattedDateOffline!.split("-")[0],
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Text("Latitude: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(currentLatitude,
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Text("Longitude: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(currentLongitude,
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 16,
        ),
        MaterialButton(
          color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
          onPressed: () async {
            if (widget.type == "Out") {
              var res = await db.fetchAttendanceInByDate(formattedDateOffline!);
              if (res.length == 0) {
                showValidation(
                    "Attendance", "Please enter your Attendance In", context);
              } else {
                if (_kPath.isNotEmpty) {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    // Online
                    var _kEncoded = json.encode({
                      "EmpId": empId,
                      "Lattitude": "",
                      "Longtitude": "",
                      "Altitude": "",
                      "InternetStatus": "",
                      "AddressDate": currentDate,
                      "InTime": currentTime
                    });
                    print("Check attendance: " + _kEncoded);
                    var response = await injector.attendanceStatusRepo
                        .fetchAttendanceStatusResponse(_kEncoded);
                    if (response.success == true) {
                      if (response.data![0].attendanceId == 0) {
                        showValidation("Attendance",
                            "Please enter your Attendance In", context);
                      } else {
                        getCurrentDateandTime();
                        var attendanceId =
                            response.data![0].attendanceId.toString();
                        // var res = await databaseHelper.insertAttendanceIn(
                        //     AttendanceReportDbModel(
                        //         empId: empId,
                        //         image: img64,
                        //         lattitude: currentLatitude,
                        //         longtitude: currentLongitude,
                        //         altitude: "",
                        //         internetStatus: "Yes",
                        //         addressDate: formattedDateOffline,
                        //         inTime: formattedTimeOffline,
                        //         attendType: "Out"));

                        var res = await db.updateOutTime(OutTimeModel(
                            date: formattedDateOffline!,
                            outTime: formattedTimeOffline!,
                            attendType: "Out",
                            internetStatus: "Yes",
                            outTimeStatus: "Yes"));

                        if (res > 0) {
                          print("Attendance Out inserted successfully");
                          var encoded = json.encode({
                            "Attendance_Id": attendanceId,
                            "EmpId": empId,
                            "Image": img64,
                            "Lattitude": currentLatitude,
                            "Longtitude": currentLongitude,
                            "Altitude": "",
                            "InternetStatus": "Yes",
                            "AddressDate": currentDate,
                            "InTime": currentTime
                          });
                          submitUserDetails(
                              context, encoded, "api/attendance/employeeout");
                        } else {
                          print("Failed: to update item");
                        }
                      }
                    } else {
                      print("");
                      showValidation(
                          "Attendace", "Error in attendance", context);
                    }
                  } else {
                    // Offline
                    // var res = await databaseHelper
                    //     .insertAttendanceIn(AttendanceReportDbModel(
                    //         empId: empId,
                    //         image: img64,
                    //         lattitude: currentLatitude,
                    //         longtitude: currentLongitude,
                    //         altitude: "",
                    //         internetStatus: "No",
                    //         addressDate: formattedDateOffline,
                    //         //  addressDate: "2012-12-24",
                    //         inTime: formattedTimeOffline,
                    //         attendType: "Out"));

                    var res = await db.updateOutTime(OutTimeModel(
                        date: formattedDateOffline!,
                        outTime: formattedTimeOffline!,
                        attendType: "Out",
                        internetStatus: "No",
                        outTimeStatus: "No"));

                    if (res > 0) {
                      print("Attendance Out inserted successfully");
                      showValidation(
                          "Attendance", "Submitted Successfully", context);
                    } else {
                      print("Failed: to update item");
                    }
                  }
                }
                // without image
                else {
                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    // Online
                    var _kEncoded = json.encode({
                      "EmpId": empId,
                      "Lattitude": "",
                      "Longtitude": "",
                      "Altitude": "",
                      "InternetStatus": "",
                      "AddressDate": currentDate,
                      "InTime": currentTime
                    });
                    print("Check attendance: " + _kEncoded);
                    var response = await injector.attendanceStatusRepo
                        .fetchAttendanceStatusResponse(_kEncoded);
                    if (response.success == true) {
                      if (response.data![0].attendanceId == 0) {
                        showValidation("Attendance",
                            "Please enter your Attendance In", context);
                      } else {
                        getCurrentDateandTime();
                        // var res = await databaseHelper.insertAttendanceIn(
                        //     AttendanceReportDbModel(
                        //         empId: empId,
                        //         image: "",
                        //         lattitude: currentLatitude,
                        //         longtitude: currentLongitude,
                        //         altitude: "",
                        //         internetStatus: "Yes",
                        //         addressDate: formattedDateOffline,
                        //         inTime: formattedTimeOffline,
                        //         attendType: "Out"));

                        var res = await db.updateOutTime(OutTimeModel(
                            date: formattedDateOffline!,
                            outTime: formattedTimeOffline!,
                            attendType: "Out",
                            internetStatus: "Yes",
                            outTimeStatus: "Yes"));

                        if (res > 0) {
                          print("Attendance Out inserted successfully");
                          var attendanceId =
                              response.data![0].attendanceId.toString();
                          var encoded = json.encode({
                            "Attendance_Id": attendanceId,
                            "EmpId": empId,
                            "Image": "",
                            "Lattitude": currentLatitude,
                            "Longtitude": currentLongitude,
                            "Altitude": "",
                            "InternetStatus": "Yes",
                            "AddressDate": currentDate,
                            "InTime": currentTime
                          });
                          submitUserDetails(
                              context, encoded, "api/attendance/employeeout");
                        } else {
                          print("Failed: to update item");
                        }
                      }
                    } else {
                      print("");
                      showValidation(
                          "Attendace", "Error in attendance", context);
                    }
                  } else {
                    // Offline
                    // var res = await databaseHelper
                    //     .insertAttendanceIn(AttendanceReportDbModel(
                    //         empId: empId,
                    //         image: "",
                    //         lattitude: currentLatitude,
                    //         longtitude: currentLongitude,
                    //         altitude: "",
                    //         internetStatus: "No",
                    //         addressDate: formattedDateOffline,
                    //         //  addressDate: "2012-12-24",
                    //         inTime: formattedTimeOffline,
                    //         attendType: "Out"));

                    var res = await db.updateOutTime(OutTimeModel(
                        date: formattedDateOffline!,
                        outTime: formattedTimeOffline!,
                        attendType: "Out",
                        internetStatus: "No",
                        outTimeStatus: "No"));

                    if (res > 0) {
                      print("Attendance Out inserted successfully");
                      showValidation(
                          "Attendance", "Submitted Successfully", context);
                    } else {
                      print("Failed: to update item");
                    }
                  }
                }
              }
            } else {
              // Attendance IN
              print("Today Date: " + formattedDateOffline!);
              var res = await db.fetchAttendanceInByDate(formattedDateOffline!);
              if (res.length == 0) {
                print("Insert entry");
                if (_kPath.isNotEmpty) {
                  File f = File(_kPath);

                  var fileLength = await f.length();
                  if (fileLength > 2000000) {
                    showValidation("Kindly choose image less than 2mb",
                        "Image size exceed", context);
                  } else {
                    var bytes = await f.readAsBytes();
                    img64 = base64Encode(bytes);
                  }
                  var encoded = json.encode({
                    "EmpId": empId,
                    "Image": img64,
                    "Lattitude": currentLatitude,
                    "Longtitude": currentLongitude,
                    "Altitude": "",
                    "InternetStatus": "Yes",
                    "AddressDate": currentDate,
                    "InTime": currentTime
                  });

                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    //Online
                    var res = await databaseHelper.insertAttendanceIn(
                        AttendanceReportDbModel(
                            empId: empId,
                            image: img64,
                            lattitude: currentLatitude,
                            longtitude: currentLongitude,
                            altitude: "",
                            internetStatus: "Yes",
                            addressDate: formattedDateOffline!,
                            inTime: formattedTimeOffline!,
                            attendType: "In",
                            outTime: "--:--",
                            inTimeStatus: "Yes",
                            outTimeStatus: "-"));

                    if (res > 0) {
                      print("AttendanceIn inserted successfully");
                      submitUserDetails(
                          context, encoded, "api/attendance/employeein");
                    } else {
                      print("Failed: to update item");
                    }
                  } else {
                    //Offline
                    var res = await databaseHelper
                        .insertAttendanceIn(AttendanceReportDbModel(
                            empId: empId,
                            image: img64,
                            lattitude: currentLatitude,
                            longtitude: currentLongitude,
                            altitude: "",
                            internetStatus: "No",
                            addressDate: formattedDateOffline!,
                            //  addressDate: "2012-12-24",
                            inTime: formattedTimeOffline!,
                            attendType: "In",
                            outTime: "--:--",
                            inTimeStatus: "No",
                            outTimeStatus: "-"));

                    if (res > 0) {
                      print("AttendanceIn inserted successfully");
                      showValidation(
                          "Attendance", "Submitted Successfully", context);
                    } else {
                      print("Failed: to update item");
                    }
                  }
                } else {
                  var encoded = json.encode({
                    "EmpId": empId,
                    "Image": "",
                    "Lattitude": currentLatitude,
                    "Longtitude": currentLongitude,
                    "Altitude": "",
                    "InternetStatus": "Yes",
                    "AddressDate": currentDate,
                    "InTime": currentTime
                  });

                  var connectivityResult =
                      await (Connectivity().checkConnectivity());
                  if (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi) {
                    // Online
                    var res = await databaseHelper.insertAttendanceIn(
                        AttendanceReportDbModel(
                            empId: empId,
                            image: img64,
                            lattitude: currentLatitude,
                            longtitude: currentLongitude,
                            altitude: "",
                            internetStatus: "Yes",
                            addressDate: formattedDateOffline!,
                            inTime: formattedTimeOffline!,
                            attendType: "In",
                            outTime: "--:--",
                            inTimeStatus: "Yes",
                            outTimeStatus: "-"));

                    if (res > 0) {
                      print("AttendanceIn inserted successfully");
                      submitUserDetails(
                          context, encoded, "api/attendance/employeein");
                    } else {
                      print("Failed: to update item");
                    }
                  } else {
                    //Offline
                    var res = await databaseHelper
                        .insertAttendanceIn(AttendanceReportDbModel(
                            empId: empId,
                            image: img64,
                            lattitude: currentLatitude,
                            longtitude: currentLongitude,
                            altitude: "",
                            internetStatus: "No",
                            addressDate: formattedDateOffline!,
                            // addressDate: "2020-12-29",
                            inTime: formattedTimeOffline!,
                            attendType: "In",
                            outTime: "--:--",
                            inTimeStatus: "No",
                            outTimeStatus: "-"));

                    if (res > 0) {
                      print("AttendanceIn inserted successfully");
                      showValidation(
                          "Attendance", "Submitted Successfully", context);
                    } else {
                      print("Failed: to update item");
                    }
                  }
                }
              } else {
                print("Entry exists");
                showValidation(
                    "Attendance In",
                    "Employee already have attendance entry for today.",
                    context);
              }
            }
          },
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }

  _imageSelected(bool isSelected) async {
    if (isSelected) {
      File f = File(_kPath);

      var fileLength = await f.length();
      if (fileLength > 2000000) {
        showValidation(
            "Kindly choose image less than 2mb", "Image size exceed", context);
      } else {
        var bytes = await f.readAsBytes();
        img64 = base64Encode(bytes);
      }
      var res = await databaseHelper.insertAttendanceIn(AttendanceReportDbModel(
          empId: empId,
          image: img64,
          lattitude: currentLatitude,
          longtitude: currentLongitude,
          altitude: "",
          internetStatus: "Yes",
          addressDate: formattedDateOffline!,
          inTime: formattedTimeOffline!));

      if (res > 0) {
        print("AttendanceIn inserted successfully");
        var encoded = json.encode({
          "EmpId": empId,
          "Image": img64,
          "Lattitude": currentLatitude,
          "Longtitude": currentLongitude,
          "Altitude": "",
          "InternetStatus": "Yes",
          "AddressDate": currentDate,
          "InTime": currentTime
        });
        submitUserDetails(context, encoded, "");
      } else {
        print("Failed: to update item");
      }
    } else {
      var res = await databaseHelper.insertAttendanceIn(AttendanceReportDbModel(
          empId: empId,
          image: "",
          lattitude: currentLatitude,
          longtitude: currentLongitude,
          altitude: "",
          internetStatus: "Yes",
          addressDate: formattedDateOffline!,
          inTime: formattedTimeOffline!));

      if (res > 0) {
        print("AttendanceIn inserted successfully");
        var encoded = json.encode({
          "EmpId": empId,
          "Image": "",
          "Lattitude": currentLatitude,
          "Longtitude": currentLongitude,
          "Altitude": "",
          "InternetStatus": "Yes",
          "AddressDate": currentDate,
          "InTime": currentTime
        });
        submitUserDetails(context, encoded, "");
      } else {
        print("Failed: to update item");
      }
    }
  }
}
