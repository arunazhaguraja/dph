import 'package:dph_tn/model/general_leave_model.dart';
import 'package:dph_tn/model/leave_request_detail_model.dart' as LeaveReqDetail;
import 'package:dph_tn/model/leave_request_status_model.dart'
    as LeaveReqStatsModel;
import 'package:dph_tn/model/leave_type_model.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaveRequestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LeaveRequestContent();
  }
}

class LeaveRequestContent extends StatefulWidget {
  @override
  _LeaveRequestContentState createState() => _LeaveRequestContentState();
}

class _LeaveRequestContentState extends State<LeaveRequestContent> {
  var mwidth;
  var mHeight;
  var empId = "";
  var empName = "";
  var toDate = "";
  var fromDate = "";
  var buildContext;
  Data? selectedUser;
  var leaveType = "";
  var leaveId = "";
  var masterId = "", leaveTypeHF = "";
  var leaveReason = "";
  var _textReason = TextEditingController();
  Future<LeaveTypeModel>? futureLeveType;
  SharedPreferences? prefs;
  List<String> nDays = [];
  LeaveReqStatsModel.LeaveRequestStatusModel? _leaveRequestStatusModel,
      leaveRequestStatusModel;

  Future<LeaveTypeModel> fetchFutureLeaveType() async {
    var response =
        await injector.leaveTypeRepo.fetchLeaveTypeResponse("LoadLeaveType");
    if (response.success == "true") {
      fetchLeaveReqStatus();
      return response;
    } else {
      return response;
    }
  }

  previousPage() {
    Navigator.pop(context, "Done");
  }

  fetchLeaveReqStatus() async {
    _leaveRequestStatusModel = await injector.leaveReqStatusRepo
        .fetchLeaveRequestStatusResponse(
            "SavedLeaveMaster_New?Emp_id=" + empId);
    if (_leaveRequestStatusModel!.success!) {
      print("fetchLeaveReqStatus : Success");
      setState(() {
        leaveRequestStatusModel = _leaveRequestStatusModel;
      });
    } else {
      print("fetchLeaveReqStatus :  Error");
    }
  }

  var selectedFromDate = "",
      showFromDateInText = "DD/MM/YYYY",
      selectedToDate = "",
      showToDateInText = "DD/MM/YYYY";
  DateTime? fDate;

  getFromDateFunc() async {
    if (nDays.isNotEmpty) {
      nDays.clear();
    }
    fDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2022));
    if (fDate != null) {
      setState(() {
        selectedFromDate = fDate!.month.toString() +
            "/" +
            fDate!.day.toString() +
            "/" +
            fDate!.year.toString();

        selectedToDate = fDate!.month.toString() +
            "/" +
            fDate!.day.toString() +
            "/" +
            fDate!.year.toString();

        showFromDateInText = fDate!.day.toString() +
            "/" +
            fDate!.month.toString() +
            "/" +
            fDate!.year.toString();
        showToDateInText = fDate!.day.toString() +
            "/" +
            fDate!.month.toString() +
            "/" +
            fDate!.year.toString();
      });
      final differenceInDays = fDate!.difference(fDate!).inDays;
      print('$differenceInDays');
      for (var i = 0; i < differenceInDays + 1; i++) {
        DateTime realDates = fDate!.add(new Duration(days: i));
        var rs = realDates.year.toString() +
            "/" +
            realDates.month.toString() +
            "/" +
            realDates.day.toString();
        nDays.add(rs);
        print("Real Dates: " + rs.toString());
      }
    }
  }

  getToDateFunc() async {
    if (nDays.isNotEmpty) {
      nDays.clear();
    }
    if (selectedFromDate == "") {
      showValidation("FromDate", "Please selecct from date", context);
    } else {
      var tDate = await showDatePicker(
        context: context,
        initialDate: fDate!,
        firstDate: fDate!,
        lastDate: DateTime(2022),
      );
      if (tDate != null) {
        setState(() {
          selectedToDate = tDate.month.toString() +
              "/" +
              tDate.day.toString() +
              "/" +
              tDate.year.toString();

          showToDateInText = tDate.day.toString() +
              "/" +
              tDate.month.toString() +
              "/" +
              tDate.year.toString();
        });
        // DateTime dateTimeCreatedAt = DateTime.parse('2019-9-11');
        // DateTime dateTimeNow = DateTime.now();
        final differenceInDays = tDate.difference(fDate!).inDays;
        print('$differenceInDays');
        for (var i = 0; i < differenceInDays + 1; i++) {
          DateTime realDates = fDate!.add(new Duration(days: i));
          var rs = realDates.year.toString() +
              "/" +
              realDates.month.toString() +
              "/" +
              realDates.day.toString();
          nDays.add(rs);
          print("Real Dates: " + rs.toString());
        }
      }
    }
  }

  @override
  void initState() {
    futureLeveType = fetchFutureLeaveType();
    getUserDetails();
    super.initState();
  }

  getUserDetails() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      empId = prefs!.getString(Consts.EMP_ID)!;
      empName = prefs!.getString(Consts.USER_NAME)!;
    });
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
        body: FutureBuilder<LeaveTypeModel>(
            future: futureLeveType,
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
                                              Color(GetColor()
                                                  .getColorHexFromStr(
                                                      MyColor.primaryColor)),
                                              Color(GetColor()
                                                  .getColorHexFromStr(
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
                                                  child: _leaveRequest(
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
                                            height: 120, width: 120),
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
      ),
    );
  }

  int? _radioValue = 0;

  void _handleRadioValueChange(int? value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          leaveTypeHF = "Full";
          break;
        case 1:
          leaveTypeHF = "Half";
          break;
      }
    });
  }

  Widget _leaveRequest(List<Data> data) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Leave Request",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 16,
          ),
          InkWell(
            onTap: () {
              getFromDateFunc();
            },
            child: Row(
              children: [
                Text(
                  "From",
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(showFromDateInText,
                      style: TextStyle(color: Colors.indigo)),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              getToDateFunc();
            },
            child: Row(
              children: [
                Text("To"),
                Text("     "),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(showToDateInText,
                      style: TextStyle(color: Colors.indigo)),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.black)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Leave Type",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          DropdownButton<Data>(
            hint: Text("Select"),
            value: selectedUser,
            onChanged: (Data? value) {
              setState(() {
                selectedUser = value;
                leaveType = value!.leaveType!;
                leaveId = value.leaveTypeId.toString();
              });
            },
            items: data.map((Data user) {
              return DropdownMenuItem<Data>(
                value: user,
                child: Row(
                  children: <Widget>[
                    Text(
                      user.leaveType!,
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          Text(
            "Day Type",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text(
                'Full Day',
                style: TextStyle(fontSize: 16.0),
              ),
              Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
              Text(
                'Half Day',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          Text(
            "Reason",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            // focusNode: mobileNumberFocusNode,
            // inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _textReason,
            textAlign: TextAlign.start,
            textInputAction: TextInputAction.done,
            style: TextStyle(color: Colors.black),
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            maxLength: 10,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              counter: SizedBox(),
              hintText: "",
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
            height: 16,
          ),
          Container(
            width: mwidth,
            child: Center(
              child: MaterialButton(
                color:
                    Color(GetColor().getColorHexFromStr(MyColor.accentColor)),
                onPressed: () {
                  postMasterLeave();
                },
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Text(
            "Leave Status",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 16,
          ),
          leaveRequestStatusModel != null
              ? Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Color(
                          GetColor().getColorHexFromStr(MyColor.daileWhite)),
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "From",
                              textAlign: TextAlign.start,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "To",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Status",
                              textAlign: TextAlign.end,
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _leaveRequestStatusModel!.data!.length,
                        itemBuilder: (context, index) {
                          var item = _leaveRequestStatusModel!.data![index];
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        item.fromDate.toString(),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        item.toDate.toString(),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                          onTap: () {
                                            fetchLeaveDetails(item
                                                .leaveRequestMasterId
                                                .toString());
                                          },
                                          child: Text(
                                            "View",
                                            textAlign: TextAlign.end,
                                            style:
                                                TextStyle(color: Colors.blue),
                                          )),
                                    ),
                                  ],
                                ),
                                // Container(
                                //   height: 1,
                                //   color: Colors.grey,
                                // ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                )
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
        ],
      ),
    );
  }

  postMasterLeave() async {
    leaveReason = _textReason.text.toString().trim();
    if (selectedFromDate != "" &&
        selectedToDate != "" &&
        leaveType != "" &&
        leaveReason != "") {
      // progressDialog(context);

      var url =
          "http://template.timesmed.in/Master/Save_LeaveMasterRequest_Mobile?FromDate=" +
              selectedFromDate +
              "&ToDate=" +
              selectedToDate +
              "&Emp_id=" +
              empId;
      var response = await injector.leaveRequestMaster
          .fetchMasterLeaveRequestResponse(url);
      if (response.success == true) {
        masterId = response.data.toString();
        loopLeaveRequest(leaveReason, masterId);
        // Navigator.of(buildContext).pop();
        // showValidation(
        //     "Leave Request",
        //     "Leave request submitted successfully. Kindly wait for your confirmation ",
        //     context);

      } else {
        Navigator.of(buildContext).pop();
        showValidation("Leave Request", "Error in request", context);
      }
    } else {
      showValidation(
          "Leave Request", "Please select leave information", context);
    }
  }

  loopLeaveRequest(String leaveReason, String masterId) async {
    for (var i = 0; i < nDays.length; i++) {
      var url =
          "http://template.timesmed.in/Master/Save_LeaveRquest_Mobile?LeaveType_id=" +
              leaveId +
              "&Date=" +
              nDays[i] +
              "&DayType=" +
              leaveTypeHF +
              "&Reason=" +
              leaveReason +
              "&Emp_id=" +
              empId +
              "&LeaveRequestMaster_id=" +
              masterId;
      print("Loop Leave Url: " + url);
      GeneralLeaveModel response =
          await injector.loopLeaveRepo.fetchLoopLeaveResponse(url);
      if (response.success == "true" && nDays.length - 1 == i) {
        print("Leave requested");
        showValidation(
            "Leave Request", "Leave request submitted successfully.", context);
        fetchLeaveReqStatus();
      } else {
        print("Error in leave request");
      }
    }
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

  Future<LeaveReqDetail.LeaveRequestDetailModel> fetchLeaveDetailss(
      String id) async {
    LeaveReqDetail.LeaveRequestDetailModel res = await injector
        .leaveReqDetailRepo
        .fetchLeaveRequestDetailResponse("LeaveRequestMaster_id=" + id);
    if (res.success!) {
      print("LeaveRequestDetailModel : Success");
      return res;
    } else {
      print("LeaveRequestDetailModel : Failure");
      return res;
    }
  }

  Future<Null> fetchLeaveDetails(String id) async {
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
                                  LeaveReqDetail.LeaveRequestDetailModel>(
                              future: fetchLeaveDetailss(id),
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
                                              "Leave Details",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Date",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text("Full / Half",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                                Expanded(
                                                  child: Text("Status",
                                                      textAlign: TextAlign.end,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      )),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 8),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount:
                                                  snapshot.data!.data!.length,
                                              itemBuilder: (context, index) {
                                                var item =
                                                    snapshot.data!.data![index];
                                                return Container(
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(item.date!,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            item.dayType!,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                            item.approvalStatus ==
                                                                    "N"
                                                                ? "Pending"
                                                                : "Approved",
                                                            textAlign:
                                                                TextAlign.end,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white)),
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

  void showLeaveDetails(String title, String msg, BuildContext context) {
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
}
