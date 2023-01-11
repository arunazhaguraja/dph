import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:dph_tn/helper/database_helper.dart';
import 'package:dph_tn/model/attendance_report_db_model.dart';
import 'package:dph_tn/model/class_list_by_emp_db_model.dart';
import 'package:dph_tn/model/class_list_by_school_model.dart';
import 'package:dph_tn/model/master_attendance_report.dart';
import 'package:dph_tn/model/school_emp_model.dart';
import 'package:dph_tn/model/school_list_db_model.dart';
import 'package:dph_tn/model/student_list_by_class_model.dart';
import 'package:dph_tn/model/student_list_by_emp_db_model.dart';
import 'package:dph_tn/model/validate_user_model.dart';
import 'package:dph_tn/repository/ValidateUserRepository.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/home/homepage.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoginPageContent();
  }
}

class LoginPageContent extends StatefulWidget {
  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  bool isLoading = false;
  // final _textMobile = TextEditingController()..text = "9092644858";
  final _textMobile = TextEditingController();
  final textMobileRef = TextEditingController();
  //
  final _textUserNameOtp = TextEditingController();
  final _textUserOtpValue = TextEditingController();
  FocusNode textUserNameOtpFocusNode = new FocusNode();
  FocusNode textUserOtpValueFocusNode = new FocusNode();
  //
  final _textForgetMobile = TextEditingController();
  final _textForgetMobileOTP = TextEditingController();
  FocusNode _textForgetMobileFocusNode = new FocusNode();
  FocusNode _textForgetMobileOTPFocusNode = new FocusNode();
  //
  final _textForgetNewPassword = TextEditingController();
  final _textForgetConfirmPassword = TextEditingController();
  FocusNode _textForgetNewPasswordFocusNode = new FocusNode();
  FocusNode _textForgetConfirmPasswordFocusNode = new FocusNode();
  //
  final _textUsernameorMobile = TextEditingController();
  final _textUserPassword = TextEditingController();

  FocusNode mobileNumberFocusNode = new FocusNode();
  BuildContext? buildContext;
  bool _value2 = false;
  void _value2Changed(bool value) => setState(() => _value2 = value);
  String loginType = "0";
  String labelType = "0";
  String labelTitle = "";
  var userNameOtp = "";
  var _kTextForgetMobile = "";
  var id = "";
  DataBaseHelper db = new DataBaseHelper();
  //

  ValidateUserRepository? validateUserRepository;

  void fetLogResp(BuildContext context, String username, String password,
      String type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("Connected to Network");
      progressDialog(context, "Loading ...");
      // Pattern pattern = "[1-9][0-9]{9}";
      var prefs = await SharedPreferences.getInstance();
      // RegExp regex = new RegExp(pattern);

      var encoded = json.encode({"UserName": username, "Password": password});
      ValidateUserModel res =
          await injector.validateRepo.fetchValidateUserResponse(encoded, type);

      if (res.success == true) {
        prefs.setString(Consts.USER_TOKEN, res.data!.token.toString());
        prefs.setString(Consts.USER_ID, res.data!.userAccessId.toString());
        prefs.setString(Consts.USER_NAME, res.data!.name.toString());
        prefs.setString(Consts.District_Id, res.data!.districtId.toString());
        prefs.setString(Consts.HUD_Id, res.data!.hUDId.toString());
        prefs.setString(Consts.Block_Id, res.data!.blockId.toString());
        prefs.setString(Consts.PHC_Id, res.data!.pHCId.toString());
        prefs.setString(Consts.HSC_Id, res.data!.hSCId.toString());
        prefs.setString(Consts.RoleName, res.data!.roleName.toString());
        prefs.setString(Consts.EMP_ID, res.data!.id.toString());
        prefs.setString(
            Consts.EmpFullName, res.data!.employeeFullName.toString());
        prefs.setString(Consts.MOBILE_NO, res.data!.mobileNo.toString());
        prefs.setString(Consts.InternalId, res.data!.internalId.toString());
        prefs.setString(
            Consts.EmployeeTypeName, res.data!.employeeTypeName.toString());
        prefs.setString(
            Consts.EmpInstitutionTyp, res.data!.empInstitutionTyp.toString());

        prefs.setBool(Consts.ISLOGGED, true);

        if (res.data!.screenFlag == 1) {
          prefs.setBool(Consts.ISSCHOOLAVAILABLE, true);
        } else {
          prefs.setBool(Consts.ISSCHOOLAVAILABLE, false);
        }

        var r = await db.fetchAttendanceIn();
        Navigator.pop(buildContext!);
        if (r.length > 0) {
          Navigator.pop(buildContext!);
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (Route<dynamic> route) => false);
          setState(() {
            _textUsernameorMobile.text = "";
            _textUserPassword.text = "";
          });
        } else {
          progressDialog(context, "Fetching user details ...");
          MasterAttendanceReportModel masterAttendanceReportModel =
              await injector.userMasterAttendRepo
                  .fetchUserMasterAttendanceResponse(res.data!.id!.toString());
          if (masterAttendanceReportModel.success!) {
            for (var item in masterAttendanceReportModel.data!) {
              var res1 = await db.insertAttendanceIn(AttendanceReportDbModel(
                  empId: res.data!.id.toString(),
                  image: "",
                  lattitude: "",
                  longtitude: "",
                  altitude: "",
                  internetStatus: "Yes",
                  addressDate: item.attendanceDate!.split("-")[2] +
                      "-" +
                      item.attendanceDate!.split("-")[1] +
                      "-" +
                      item.attendanceDate!.split("-")[0],
                  inTime: item.attendanceInTime != null
                      ? item.attendanceInTime
                      : "--:--",
                  attendType: "In",
                  outTime: item.attendanceOutTime != null
                      ? item.attendanceOutTime
                      : "--:--",
                  inTimeStatus: "Yes",
                  outTimeStatus: "Yes",
                  workStatus: item.attenanceStatus,
                  dayStatus: item.holidayFlag));
              if (res1 > 0) {
                print("Inserting into db : " + item.attendanceDate!);
              } else {
                print("Failed to insert in db");
              }
            }
            //
            SchoolEmpModel schoolListEmpModel = await injector.schoolListEmpRepo
                .fetchSchoolListEmp("Emp_Id=" +
                    res.data!.id.toString() +
                    "&From_Date=21-01-2021&To_Date=21-01-2021");
            if (schoolListEmpModel.success == true) {
              print("SchoolListEmpDB Response: " + schoolListEmpModel.message!);
              for (var item in schoolListEmpModel.data!.schoolList!) {
                // var _kAttendance = item.attendace.toString();
                print("_kAttendance: " + item.attendace.toString());
                var result = await db.insertSchoolList(SchoolListDbModel(
                    schoolId: item.schoolId,
                    schoolName: item.schoolName,
                    attendance: item.attendace.toString(),
                    attendanceStatus: item.attendanceStatus,
                    lastScreenDate: item.lastScreenedDate.toString()));
                if (result > 1) {
                  print("Inserting school list into db : Success");
                } else {
                  print("Inserting school list into db : Failed");
                }
              }
            } else {
              print("SchoolListEmpDB Response: " + schoolListEmpModel.message!);
              throw Exception('SchoolListEmpDB Failed to load ');
            }
            //
            ClassListBySchoolModel classListBySchool =
                await injector.classListBySchoolRepo.fetchClassListBySchool(
                    "api/class/all_list/" + res.data!.id.toString());
            if (classListBySchool.success == true) {
              print("ClassListByEmpDB Response: " + classListBySchool.message!);
              for (var item in classListBySchool.data!) {
                var result = await db.insertClassList(ClassListByEmpDbModel(
                    schoolId: item.schoolId,
                    classId: item.classId,
                    classNm: item.classNm,
                    section: item.section,
                    attendanceStatus: item.attendanceStatus,
                    lastScreenedDate: item.lastScreenedDate,
                    studentCount: item.studentCount,
                    uDISECode: item.uDISECode));
                if (result > 1) {
                  print("Inserting class list into db : Success");
                } else {
                  print("Inserting class list into db : Failed");
                }
              }
            } else {
              print("ClassListByEmpDB Response: " + classListBySchool.message!);
              throw Exception('ClassListByEmpDB Failed to load ');
            }
            //
            StudentListByClassModel studentListByEmp =
                await injector.studentListClassRepo.fetchStudentListByClass(
                    "api/student/all_list/" + res.data!.id.toString());
            if (studentListByEmp.success == true) {
              print(
                  "StudentListByEmpDB Response: " + studentListByEmp.message!);
              for (var item in studentListByEmp.data!) {
                var result = await db.insertStudentList(StudentListByEmpDbModel(
                    schoolId: item.schoolId,
                    classId: item.classId,
                    studentId: item.studentId,
                    uDISECode: item.uDISECode,
                    attendance: item.attendance,
                    bldGrp: item.bldGrp,
                    dOB: item.dOB,
                    firstName: item.firstName,
                    mobileNo: item.mobileNo,
                    screeningId: item.screeningId,
                    studentUniqueId: item.studentUniqueId));
                if (result > 1) {
                  print("Inserting student list into db : Success");
                } else {
                  print("Inserting student list into db : Failed");
                }
              }
            } else {
              print(
                  "StudentListByEmpDB Response: " + studentListByEmp.message!);
              throw Exception('StudentListByEmpDB Failed to load ');
            }
            //
            Navigator.pop(buildContext!);
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => HomePage()),
                (Route<dynamic> route) => false);
            setState(() {
              _textUsernameorMobile.text = "";
              _textUserPassword.text = "";
            });
          } else {
            print("Error : In user attendance report");
          }
        }
      } else {
        Navigator.pop(buildContext!);
        print("Response" + res.toString());
        showValidation(res.message!, res.errors![0], context);
      }
    } else {
      showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  void validatePasswordOTP(BuildContext context, String username,
      String password, String type) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("Connected to Network");
      progressDialog(context, "Loading ...");
      // Pattern pattern = "[1-9][0-9]{9}";
      // var prefs = await SharedPreferences.getInstance();
      // RegExp regex = new RegExp(pattern);

      var encoded = json.encode({"UserName": username, "Password": password});
      ValidateUserModel res =
          await injector.validateRepo.fetchValidateUserResponse(encoded, type);

      if (res.success == true) {
        Navigator.pop(buildContext!);
        setState(() {
          id = res.data!.id.toString();
          _textForgetMobile.text = "";
          _textForgetMobileOTP.text = "";
          loginType = "5";
        });
      } else {
        Navigator.pop(buildContext!);
        print("Response" + res.toString());
        showValidation(res.message!, res.errors![0], context);
      }
    } else {
      showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  _setLabelType(String name) {
    setState(() {
      labelTitle = name;
    });
  }

  @override
  void initState() {
    // getTermsAndConditions();
    super.initState();
  }

  @override
  void dispose() {
    _textMobile.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mHeight = MediaQuery.of(context).size.height;
    var mwidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async {
        if (loginType == "1") {
          setState(() {
            loginType = "0";
          });
        } else if (loginType == "2") {
          setState(() {
            loginType = "0";
            labelType = "0";
          });
        } else if (loginType == "3") {
          setState(() {
            loginType = "1";
          });
        } else if (loginType == "4") {
          setState(() {
            loginType = "2";
            labelType = "1";
          });
        } else if (loginType == "6") {
          setState(() {
            loginType = "4";
          });
        } else if (loginType == "8") {
          setState(() {
            loginType = "7";
            labelType = "2";
          });
        } else if (loginType == "7") {
          setState(() {
            loginType = "0";
            labelType = "0";
          });
        } else if (loginType == "0") {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Consts.APP_NAME),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
              Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
        ),
        backgroundColor: Colors.grey[300],
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
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
                      height: mHeight / 1.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            labelType == "2"
                                ? "Help"
                                : labelType == "1"
                                    ? "Forget Password"
                                    : "Login",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
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
                                      color: Color(GetColor()
                                          .getColorHexFromStr(
                                              MyColor.secondaryColor)),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  margin: EdgeInsets.symmetric(horizontal: 48),
                                  width: mwidth,
                                  child: loginType == "1"
                                      ? _alternativeLogin()
                                      : loginType == "2"
                                          ? _forgotPassword()
                                          : loginType == "3"
                                              ? _otpLogin()
                                              : loginType == "4"
                                                  ? _forgetPasswordOtpLogin()
                                                  : loginType == "5"
                                                      ? _forgetConfirmPassword()
                                                      : loginType == "6"
                                                          ? _forgetPasswordRaiseRequest()
                                                          : loginType == "7"
                                                              ? _help()
                                                              : loginType == "8"
                                                                  ? _helpDetails()
                                                                  : _defaultLogin()
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
          ),
        ),
      ),
    );
  }

  Widget _helpDetails() {
    return Container(
      padding: EdgeInsets.only(top: 32, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          //
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                "Contact Person:",
                style: TextStyle(),
                textAlign: TextAlign.end,
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text("Lorem")),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                "Role:",
                style: TextStyle(),
                textAlign: TextAlign.end,
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text("Lorem")),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                "Institution:",
                style: TextStyle(),
                textAlign: TextAlign.end,
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text("Lorem")),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                  child: Text(
                "Mobile Number:",
                style: TextStyle(),
                textAlign: TextAlign.end,
              )),
              SizedBox(
                width: 10,
              ),
              Expanded(child: Text("Lorem")),
            ],
          ),
          SizedBox(
            height: 16,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {},
            child: Text(
              "Call the Officers",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          //
        ],
      ),
    );
  }

  Widget _help() {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            focusNode: mobileNumberFocusNode,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _textMobile,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.black),
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: true),
            maxLength: 10,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              counter: SizedBox(),
              hintText: "Emp ID/ Mobile Number",
              // border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              //focusedBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
          //
          SizedBox(height: 16),
          //
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {
              setState(() {
                setState(() {
                  loginType = "8";
                });
              });
            },
            child: Text(
              "Submit",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          //
        ],
      ),
    );
  }

  void forgetPasswordReset(
      BuildContext context, String id, String confirmPassword) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("Connected to Network");
      progressDialog(context, "Loading ...");
      // Pattern pattern = "[1-9][0-9]{9}";
      // RegExp regex = new RegExp(pattern);

      var encoded = json.encode({"Id": id, "Password": confirmPassword});
      var res = await injector.commonRepo
          .fetchCommonUserResponse(encoded, "api/user/pwdreset");

      if (res.success == true) {
        Navigator.pop(buildContext!);
        showValidation("Password", "Reset Done Successfully", context);
        setState(() {
          loginType = "0";
        });
      } else {
        Navigator.pop(buildContext!);
        print("Response" + res.toString());
        showValidation(res.message!, res.errors![0], context);
      }
    } else {
      showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  Widget _forgetConfirmPassword() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          focusNode: _textForgetNewPasswordFocusNode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textForgetNewPassword,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: true),
          maxLength: 10,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "New Password",
            // border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            //focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        //
        TextFormField(
          focusNode: _textForgetConfirmPasswordFocusNode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textForgetConfirmPassword,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: true),
          maxLength: 10,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "Confirm Password",
            // border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            //focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),

        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
          minWidth: MediaQuery.of(context).size.width,
          color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
          onPressed: () {
            var newPassword = _textForgetNewPassword.text.toString().trim();
            var confirmPassword =
                _textForgetConfirmPassword.text.toString().trim();
            if (newPassword.length > 5 && confirmPassword.length > 5) {
              if (newPassword == confirmPassword) {
                forgetPasswordReset(context, id, confirmPassword);
              } else {
                showValidation(
                    "Password Reset", "Password must be same", context);
              }
            } else {
              showValidation(
                  "Password Reset", "Password minimun length 6 ", context);
            }
          },
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _forgetPasswordRaiseRequest() {
    return Container(
      padding: EdgeInsets.only(top: 24, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            focusNode: mobileNumberFocusNode,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _textMobile,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.black),
            keyboardType:
                TextInputType.numberWithOptions(decimal: false, signed: true),
            maxLength: 10,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              counter: SizedBox(),
              hintText: "Emp ID/ Mobile Number",
              // border: InputBorder.none,
              filled: true,
              fillColor: Colors.grey[300],
              //focusedBorder: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
            ),
          ),
          //
          SizedBox(
            height: 16,
          ),
          //
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {},
            child: Text(
              "Raise a Request",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          //
        ],
      ),
    );
  }

  Widget _forgetPasswordOtpLogin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          focusNode: _textForgetMobileFocusNode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textForgetMobile,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: true),
          maxLength: 10,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "Mobile number",
            // border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            //focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        //
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
          minWidth: MediaQuery.of(context).size.width,
          color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
          onPressed: () {
            _kTextForgetMobile = _textForgetMobile.text.toString().trim();
            if (_kTextForgetMobile.isNotEmpty) {
              if (_kTextForgetMobile.length == 10) {
                fetchOtp(context, _kTextForgetMobile);
              } else {
                showValidation("Forget Password",
                    "Please enter valid mobile number", context);
              }
            } else {
              showValidation("Forget Password",
                  "Please enter your mobile number", context);
            }
          },
          child: Text(
            "Generate Otp",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        //
        TextFormField(
          focusNode: _textForgetMobileOTPFocusNode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textForgetMobileOTP,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: true),
          maxLength: 10,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "Enter Otp",
            filled: true,
            fillColor: Colors.grey[300],
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),

        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
          minWidth: MediaQuery.of(context).size.width,
          color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
          onPressed: () {
            if (_kTextForgetMobile.isNotEmpty &&
                _textForgetMobileOTP.text.toString().trim().isNotEmpty) {
              var forgetOtp = _textForgetMobileOTP.text.toString().trim();

              if (forgetOtp.length == 6) {
                validatePasswordOTP(context, _kTextForgetMobile, forgetOtp,
                    "api/user/validatepwdotp");
              } else {
                showValidation(
                    "Forget Password", "Please enter valid OTP", context);
              }
            } else {
              showValidation("Forget Password", "Plese enter the OTP", context);
            }
          },
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  void fetchOtp(BuildContext context, String mobileNumber) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      print("Connected to Network");
      progressDialog(context, "Loading ...");
      // Pattern pattern = "[1-9][0-9]{9}";
      // RegExp regex = new RegExp(pattern);

      var encoded = json.encode({"MobileNo": mobileNumber});
      var res = await injector.commonRepo
          .fetchCommonUserResponse(encoded, "api/user/sendotp");

      if (res.success == true) {
        Navigator.pop(buildContext!);
        showValidation("OTP", "Sent Successfully", context);
        fieldFocusChange(
            context, textUserNameOtpFocusNode, textUserOtpValueFocusNode);
      } else {
        Navigator.pop(buildContext!);
        print("Response" + res.toString());
        showValidation(res.message!, res.errors![0], context);
      }
    } else {
      showValidation(Consts.CONNECTION_TITLE, Consts.CONNECTION_MSG, context);
      print("Unable to connect. Please Check Internet Connection");
    }
  }

  Widget _otpLogin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          focusNode: textUserNameOtpFocusNode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textUserNameOtp,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: true),
          maxLength: 10,
          onFieldSubmitted: (_) {
            fieldFocusChange(
                context, textUserNameOtpFocusNode, textUserOtpValueFocusNode);
          },
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "Mobile number",
            // border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            //focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        //
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
          minWidth: MediaQuery.of(context).size.width,
          color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
          onPressed: () {
            userNameOtp = _textUserNameOtp.text.toString().trim();
            if (userNameOtp.isNotEmpty) {
              if (userNameOtp.length == 10) {
                fetchOtp(context, userNameOtp);
              } else {
                showValidation(
                    "OTP", "Please enter valid mobile number", context);
              }
            } else {
              showValidation("OTP", "Please enter your mobile number", context);
            }
          },
          child: Text(
            "Generate Otp",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),

        TextButton(
            onPressed: () {
              userNameOtp = _textUserNameOtp.text.toString().trim();
              if (userNameOtp.isNotEmpty) {
                if (userNameOtp.length == 10) {
                  fetchOtp(context, userNameOtp);
                } else {
                  showValidation(
                      "OTP", "Please enter valid mobile number", context);
                }
              } else {
                showValidation(
                    "OTP", "Please enter your mobile number", context);
              }
            },
            child: Text("Resend OTP")),
        //
        TextFormField(
          focusNode: textUserOtpValueFocusNode,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textUserOtpValue,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: true),
          maxLength: 6,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "Enter Otp",
            // border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            //focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),

        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
          minWidth: MediaQuery.of(context).size.width,
          color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
          onPressed: () {
            if (userNameOtp.isNotEmpty &&
                _textUserOtpValue.text.toString().trim().isNotEmpty) {
              var userOtp = _textUserOtpValue.text.toString().trim();

              if (userOtp.length == 6) {
                fetLogResp(
                    context, userNameOtp, userOtp, "api/user/validateotp");
              } else {
                showValidation("OTP", "Please enter valid OTP", context);
              }
            } else {
              showValidation("OTP", "Plese enter the OTP", context);
            }
          },
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 8,
        ),
      ],
    );
  }

  Widget _defaultLogin() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextFormField(
          // focusNode: mobileNumberFocusNode,
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textUsernameorMobile,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          keyboardType:
              TextInputType.numberWithOptions(decimal: false, signed: true),
          maxLength: 10,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "Username",
            // border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            //focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        //
        TextFormField(
          // focusNode: mobileNumberFocusNode,
          // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          controller: _textUserPassword,
          textAlign: TextAlign.start,
          textInputAction: TextInputAction.done,
          style: TextStyle(color: Colors.black),
          obscureText: true,
          keyboardType: TextInputType.emailAddress,
          maxLength: 10,
          decoration: InputDecoration(
            contentPadding:
                EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
            counter: SizedBox(),
            hintText: "Password",
            // border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[300],
            //focusedBorder: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  loginType = "2";
                  labelType = "1";
                });
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.green[900],
                    fontSize: 12),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8,
        ),
        MaterialButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          elevation: 0,
          minWidth: MediaQuery.of(context).size.width,
          color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
          onPressed: () {
            var username = _textUsernameorMobile.text.toString().trim();
            var password = _textUserPassword.text.toString().trim();

            if (username.isNotEmpty && password.isNotEmpty) {
              fetLogResp(context, username, password, "api/user/validateuser");
            } else {
              showValidation("Login", "All fields are mandatory", context);
            }

            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (context) => HomePage()));
          },
          child: Text(
            "Submit",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 8,
        ),
        InkWell(
            onTap: () {
              setState(() {
                loginType = "1";
              });
            },
            child: Text(
              "Alternative Login",
              style: TextStyle(fontSize: 10, color: Colors.black),
            )),
        SizedBox(
          height: 8,
        ),
        InkWell(
            onTap: () {
              setState(() {
                loginType = "7";
                labelType = "2";
              });
            },
            child: Text(
              "Need Help",
              style: TextStyle(fontSize: 10, color: Colors.black),
            )),
      ],
    );
  }

  Widget _forgotPassword() {
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
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             RegisterPage()));
              setState(() {
                loginType = "4";
              });
            },
            child: Text(
              "Reset by OTP",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 24),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {
              setState(() {
                loginType = "6";
              });
            },
            child: Text(
              "Raise a Request to Block",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
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
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             RegisterPage()));
              setState(() {
                loginType = "3";
              });
            },
            child: Text(
              "OTP Based  Login",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             RegisterPage()));
            },
            child: Text(
              "Finger Print Login",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          MaterialButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            elevation: 0,
            minWidth: MediaQuery.of(context).size.width,
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {
              // Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //         builder: (context) =>
              //             RegisterPage()));
            },
            child: Text(
              "Face ID Login",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void progressDialog(BuildContext context, String msg) {
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
                  child: Text(
                    msg,
                    style: TextStyle(),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        });
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
