import 'package:dph_tn/model/district_model.dart';
import 'package:dph_tn/model/slidermodel.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ReportPageContent();
  }
}

class ReportPageContent extends StatefulWidget {
  @override
  _ReportPageContentState createState() => _ReportPageContentState();
}

class _ReportPageContentState extends State<ReportPageContent> {
  var mwidth;
  var mHeight;
  var empId = "";
  var empName = "";
  var toDate = "";
  var fromDate = "";
  String endDateApi = "";
  String fromDateApi = "";

  Future<List<SliderModel>>? futureAttendanceReport;
  Future<List<DistricModel>>? futureDistrict;

  Future<List<SliderModel>> fetchFutureAttendanceReport() async {
    return getSlides;
  }

  Future<List<DistricModel>> fetchFutureDistrict() async {
    List<DistricModel> districtList = [];
    var response =
        await injector.districtRepo.fetchDistrictResponse("Get_Distirct_List");

    districtList.add(response);
    return districtList;
  }

  @override
  void initState() {
    getCurrentDateandTime();
    futureAttendanceReport = fetchFutureAttendanceReport();
    futureDistrict = fetchFutureDistrict();
    super.initState();
  }

  getDateFunc() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
  }

  getCurrentDateandTime() async {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yMMMd');
    final DateFormat formatterM = DateFormat('yMMM');
    //
    final DateFormat endDateFormat = DateFormat('yyyy-MM-dd');
    endDateApi = endDateFormat.format(now);
    var fromYearApi = endDateApi.split("-")[0];
    var fromMonthApi = endDateApi.split("-")[1];
    fromDateApi = fromYearApi + "-" + fromMonthApi + "-" + "01";

    final String formattedToDate = formatter.format(now);
    final String formattedFromDate = formatterM.format(now);
    var fromMonth = formattedFromDate.split(" ")[0];
    var fromYear = formattedFromDate.split(" ")[1];

    setState(() {
      toDate = formattedToDate;
      fromDate = fromMonth + " 01, " + fromYear;
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
            onPressed: () async {
              previousPage();
            },
          ),
          title: Text(Consts.APP_NAME),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
              Color(GetColor().getColorHexFromStr(MyColor.primaryColor)),
        ),
        body: FutureBuilder<List<SliderModel>>(
            future: futureAttendanceReport,
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
                                                  child:
                                                      _attendanceReportList()),
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
      ),
    );
  }

  Widget _attendanceReportList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0, right: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today Report",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w800),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Export",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.orange,
                      fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No of District",
                      textAlign: TextAlign.center,
                    ),
                    Text("30")
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No of Block",
                      textAlign: TextAlign.center,
                    ),
                    Text("26")
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No of PHC",
                      textAlign: TextAlign.center,
                    ),
                    Text("4")
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "No of HSC",
                      textAlign: TextAlign.center,
                    ),
                    Text("30")
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Total no of employees",
                      textAlign: TextAlign.center,
                    ),
                    Text("26")
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Present",
                      textAlign: TextAlign.center,
                    ),
                    Text("4")
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Absent",
                      textAlign: TextAlign.center,
                    ),
                    Text("10")
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "Waiting for Sync",
                      textAlign: TextAlign.center,
                    ),
                    Text("26")
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      "",
                      textAlign: TextAlign.center,
                    ),
                    Text("")
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
              color: Color(GetColor().getColorHexFromStr(MyColor.daileWhite)),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text("From", style: TextStyle(color: Colors.black)),
                  TextButton.icon(
                      onPressed: () {
                        //getDateFunc();
                      },
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      label:
                          Text(fromDate, style: TextStyle(color: Colors.black)))
                ],
              ),
              Column(
                children: [
                  Text(
                    "To",
                    style: TextStyle(color: Colors.black),
                  ),
                  TextButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      label:
                          Text(toDate, style: TextStyle(color: Colors.black)))
                ],
              )
            ],
          ),
        ),
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
                    "Date",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "To no of emps",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "No of presents",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "No of absent",
                    textAlign: TextAlign.center,
                  )),
                  Expanded(
                      child: Text(
                    "Not yet Sync",
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    //var i = data[index];
                    return Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            endDateApi,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: Text(
                            "300",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: Text(
                            "200",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          )),
                          Expanded(
                              child: InkWell(
                            onTap: () {},
                            child: Text(
                              "100",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          )),
                          Expanded(
                              child: Text(
                            "100",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12),
                          ))
                        ],
                      ),
                    );
                  }),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ],
    );
  }
}
