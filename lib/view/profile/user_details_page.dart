import 'dart:io';
import 'package:dph_tn/model/userdetailsmodel.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/profile/user_details_update_page.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserDetailsContent();
  }
}

class UserDetailsContent extends StatefulWidget {
  @override
  _UserDetailsContentState createState() => _UserDetailsContentState();
}

class _UserDetailsContentState extends State<UserDetailsContent> {
  //
  var mwidth;
  var mHeight;
  var empId = "";
  var empName = "";
  var _kPath = "";

  Future<UserDetailsModel>? fUserDetails;

  Future<UserDetailsModel> fetchUserDetails() async {
    var prefs = await SharedPreferences.getInstance();
    empId = prefs.getString(Consts.EMP_ID)!;
    //
    UserDetailsModel userDetailsModelList = await injector.userDetailsRepo
        .fetchUserDetailsResponse("api/employee/detail/" + empId);
    //
    if (userDetailsModelList.success == true) {
      print("UserDetails Response: " + userDetailsModelList.message!);

      return userDetailsModelList;
    } else {
      print("UserDetails Response: " + userDetailsModelList.message!);
      throw Exception('UserDetails Failed to load ');
    }
  }

  @override
  void initState() {
    fUserDetails = fetchUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    mwidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("DPHTN"),
        centerTitle: true,
        elevation: 0,
        backgroundColor:
            Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
      ),
      body: FutureBuilder<UserDetailsModel>(
          future: fUserDetails,
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
                                                            Radius.circular(
                                                                8))),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16),
                                                width: mwidth,
                                                child: _profileDetails(
                                                    snapshot.data!.data!)),
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
    );
  }

  Widget _profileDetails(Data data) {
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserDetailsUpdatePage(
                          name: data.name,
                          mobile: data.mobileNo,
                          address: "",
                          age: "",
                        )));
              },
              child: Text(
                "Edit",
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
                flex: 1,
                child: Text(
                  "Employee ID: ",
                  style: TextStyle(fontSize: 16),
                )),
            Expanded(
                child: Text(data.employeeId!,
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 1, child: Text("Name: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(data.name!,
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Text("Mobile: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(data.mobileNo!,
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                flex: 1, child: Text("Role: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(data.role! != null ? data.role! : "-",
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Text("Type of Institution: ",
                    style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(data.instType! == null ? "-" : data.instType!,
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child:
                    Text("Employee ID Type: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(data.empIdType! != null ? data.empIdType! : "-",
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Expanded(
                flex: 1,
                child: Text("Gender: ", style: TextStyle(fontSize: 16))),
            Expanded(
                child: Text(data.gender == "1" ? "Male" : "Female",
                    textAlign: TextAlign.start, style: TextStyle(fontSize: 16)))
          ],
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
