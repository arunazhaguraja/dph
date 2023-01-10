import 'package:dph_tn/model/student_conditions_model.dart';
import 'package:dph_tn/utils/consts.dart';
import 'package:dph_tn/utils/getcolor.dart';
import 'package:dph_tn/utils/mycolors.dart';
import 'package:dph_tn/view/splash/myapp.dart';
import 'package:flutter/material.dart';

class StudentConditionReportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StudentConditionReportContent();
  }
}

class StudentConditionReportContent extends StatefulWidget {
  @override
  _StudentConditionReportContentState createState() =>
      _StudentConditionReportContentState();
}

class _StudentConditionReportContentState
    extends State<StudentConditionReportContent> {
  bool _checkbox = false;
  Future<StudentConditionsModel>? fStudentConditions;

  Future<StudentConditionsModel> fetchStuConditions() async {
    StudentConditionsModel res = await injector.studentConditionsRepo
        .fetchStudentConditions("api/student/screencondition");
    if (res.success!) {
      print("StudentCondition : Success");
      return res;
    } else {
      print("StudentCondition : Failure");
      return res;
    }
  }

  @override
  void initState() {
    fStudentConditions = fetchStuConditions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {},
        // ),
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
              children: <Widget>[
                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.all(8),
                  margin: EdgeInsets.all(8),
                  decoration: new BoxDecoration(
                    color: Color(
                        GetColor().getColorHexFromStr(MyColor.primaryColor)),
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
                  child: FutureBuilder<StudentConditionsModel>(
                      future: fetchStuConditions(),
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
                                      "Screening Conditions",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    SizedBox(height: 10),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount: snapshot.data!.data!.length,
                                      itemBuilder: (context, index) {
                                        var item = snapshot.data!.data![index];
                                        return ConditionItemList(item: item);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            } else if (snapshot.hasError) {
                              if (snapshot.error.toString().split(":")[0] ==
                                  "SocketException") {
                                return Center(
                                    child: Text("Whoops!\nConnection Error" +
                                        snapshot.hasError.toString()));
                              } else {
                                return Center(
                                    child: Text("oh Snap!\nServer Error"));
                              }
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ConditionItemList extends StatefulWidget {
  final Data? item;

  ConditionItemList({this.item});

  @override
  _ConditionItemListState createState() => _ConditionItemListState();
}

class _ConditionItemListState extends State<ConditionItemList> {
  bool _checkbox = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Checkbox(
            value: _checkbox,
            onChanged: (value) {
              setState(() {
                if (_checkbox) {
                  _checkbox = false;
                } else {
                  _checkbox = true;
                }
              });
            },
          ),
          Text(widget.item!.name!),
        ],
      ),
    );
  }
}
