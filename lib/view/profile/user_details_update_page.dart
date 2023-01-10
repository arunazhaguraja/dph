import 'dart:io';

import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class UserDetailsUpdatePage extends StatelessWidget {
  final name, mobile, address, age;
  UserDetailsUpdatePage({this.name, this.mobile, this.address, this.age});

  @override
  Widget build(BuildContext context) {
    return UserDetailsUpdateContent(
      name: name,
      mobile: mobile,
      address: address,
      age: age,
    );
  }
}

class UserDetailsUpdateContent extends StatefulWidget {
  final name, mobile, address, age;

  UserDetailsUpdateContent({this.name, this.mobile, this.address, this.age});

  @override
  _UserDetailsUpdateContentState createState() =>
      _UserDetailsUpdateContentState();
}

class _UserDetailsUpdateContentState extends State<UserDetailsUpdateContent> {
  //
  var mwidth;
  var mHeight;
  //
  var _textName = TextEditingController();
  var _textAltMobile = TextEditingController();

  var _textAddress1 = TextEditingController();
  var _textAge = TextEditingController();
  //
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _usernameFocusNode = FocusNode();
  FocusNode _emailFocusNode = FocusNode();
  FocusNode _altMobileFocusNode = FocusNode();
  FocusNode _address1FocusNode = FocusNode();
  FocusNode _adddress2FocusNode = FocusNode();
  //
  var _useraddress2, _username, _usermobile, _useremail, _useraddress1;
  var imageURI = "";

  @override
  void initState() {
    setUserDetails();
    super.initState();
  }

  setUserDetails() {
    setState(() {
      _textName.text = widget.name;
      _textAltMobile.text = widget.mobile;
    });
  }

  @override
  Widget build(BuildContext context) {
    mwidth = MediaQuery.of(context).size.width;
    mHeight = MediaQuery.of(context).size.height;
    return Container(
      child: Scaffold(
          appBar: AppBar(
            title: Text("DPHTN"),
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
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
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 16),
                                        width: mwidth,
                                        child: _profileDetails()),
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
          )),
    );
  }

  Widget _profileDetails() {
    return Container(
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              InkWell(
                onTap: () async {
                  if (await Permission.storage.request().isGranted) {
                    print("Status: isGranted");
                  } else if (await Permission.storage.request().isDenied) {
                    print("Status: isDenied");
                  }
                },
                child: Container(
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
                        // backgroundImage: imageURI != ""
                        //     ? FileImage(File(imageURI))
                        //     : ExactAssetImage(
                        //         "images/User.png",
                        //       ),

                        backgroundImage: FileImage(File(imageURI)),

                        child: Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(
                              Icons.camera_alt,
                              color: Color(GetColor()
                                  .getColorHexFromStr(MyColor.gColor)),
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
              ),
            ],
          ),
          SizedBox(
            height: 24,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: TextFormField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9]+|\s"))
              ],
              onSaved: (name) => _username = name,
              onFieldSubmitted: (_) {
                fieldFocusChange(
                    context, _usernameFocusNode, _altMobileFocusNode);
              },
              focusNode: _usernameFocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Required field name";
                } else {
                  return null;
                }
              },
              maxLength: 24,
              textInputAction: TextInputAction.next,
              controller: _textName,
              decoration: InputDecoration(
                  // icon: Image.asset(
                  //   "images/User.png",
                  //   height: 24,
                  //   width: 24,
                  //   color: Color(
                  //       GetColor().getColorHexFromStr(MyColor.daileGreen)),
                  // ),
                  hintText: "Name"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: TextFormField(
              onSaved: (mobile) => _usermobile = mobile,
              onFieldSubmitted: (_) {
                fieldFocusChange(context, _altMobileFocusNode, _emailFocusNode);
              },
              focusNode: _altMobileFocusNode,
              validator: (value) {
                if (value!.length != 10) {
                  return "Required Mobile Number.";
                } else {
                  return null;
                }
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.next,
              maxLength: 10,
              controller: _textAltMobile,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: false, signed: true),
              decoration: InputDecoration(
                  // icon: Image.asset(
                  //   "images/Phone.png",
                  //   height: 24,
                  //   width: 24,
                  //   color: Color(
                  //       GetColor().getColorHexFromStr(MyColor.daileGreen)),
                  // ),
                  hintText: "Mobile No"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: TextFormField(
              readOnly: false,
              onSaved: (address1) => _useraddress1 = address1,
              onFieldSubmitted: (_) {
                fieldFocusChange(
                    context, _address1FocusNode, _adddress2FocusNode);
              },
              focusNode: _address1FocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Required field Address.";
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.next,
              minLines: 1,
              maxLines: 5,
              maxLength: 150,
              controller: _textAddress1,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  // icon: Image.asset(
                  //   "images/Location.png",
                  //   height: 24,
                  //   width: 24,
                  //   color: Color(
                  //       GetColor().getColorHexFromStr(MyColor.daileGreen)),
                  // ),
                  hintText: "Address"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32),
            child: TextFormField(
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onSaved: (address2) => _useraddress2 = address2,
              focusNode: _adddress2FocusNode,
              validator: (value) {
                if (value!.isEmpty) {
                  return "Required field Age";
                } else {
                  return null;
                }
              },
              textInputAction: TextInputAction.done,
              maxLength: 2,
              keyboardType:
                  TextInputType.numberWithOptions(decimal: false, signed: true),
              controller: _textAge,
              decoration: InputDecoration(hintText: "Age"),
            ),
          ),
          MaterialButton(
            color: Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
            onPressed: () {},
            child: Text(
              "Sumit",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  void fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }
}
