import 'dart:io';
import 'dart:async';
import 'package:dph_tn/model/attendance_report_db_model.dart';
import 'package:dph_tn/model/class_list_by_emp_db_model.dart';
import 'package:dph_tn/model/internet_status_model.dart';
import 'package:dph_tn/model/out_time_model.dart';
import 'package:dph_tn/model/school_list_db_model.dart';
import 'package:dph_tn/model/student_list_by_emp_db_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DataBaseHelper {
  DataBaseHelper._createInstance();

  static DataBaseHelper? _dataBaseHelper; // singleton dbhelper
  static Database? _database; // singleton db

  String tableName = 'DPHTN';
  String colEmpId = 'EmpId';
  String colImage = "Image";
  String colLat = 'Lattitude';
  String colLng = 'Longtitude';
  String colAlt = 'Altitude';
  String colInternetStatus = 'InternetStatus';
  String colDate = 'AddressDate';
  String colTime = 'InTime';
  String colAttendType = "Type";
  String colOutTime = "OutTime";
  String colInTimeStatus = "InTimeStatus";
  String colOutTimeStatus = "OutTimeStatus";
  String colWorkStatus = "WorkStatus";
  String colDayStatus = "DayStatus";

  String tableSchool = 'SchoolListTable';
  String schSchoolId = 'schoolId';
  String schSchoolName = 'schoolName';
  String schSchoolAttendance = 'schoolAttendance';
  String schSchoolAttendanceStatus = 'schoolAttendanceStatus';
  String schLastScreenDate = 'schoolLastScreenDate';

  String tableClass = 'ClassListTable';
  String clsSchoolId = 'clsSchoolId';
  String clsClassId = 'classId';
  String clsName = 'className';
  String clsSection = 'classSection';
  String clsLastScreenDate = 'classLastScreenDate';
  String clsAttendanceStatus = 'classAttendanceStatus';
  String clsStudentCount = 'classStudentCount';
  String clsUDISECode = 'classUDISECode';

  String tableStudent = 'StudentListTable';
  String stuSchoolId = 'stuSchoolId';
  String stuClassId = 'stuClassId';
  String stuStudentId = 'stuStudentId';
  String studentUniqueId = 'stuUniqueId';
  String stuFirstName = 'stuFirstName';
  String stuDob = 'stuDob';
  String stuMobileNumber = 'stuMobileNumber';
  String stuBloodGroup = 'stuBloodGroup';
  String stuScreeningId = 'stuScreeningId';
  String stuAttendance = 'stuAttendace';
  String studUDISECode = 'stuUDISECode';

  static const NEW_DB_VERSION = 1;

  factory DataBaseHelper() {
    if (_dataBaseHelper == null) {
      _dataBaseHelper = DataBaseHelper._createInstance();
    }
    return _dataBaseHelper!;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'dphtn.db';
    print("Database Path:" + path);

    var itemCountDatabase = await openDatabase(path,
        version: NEW_DB_VERSION, onCreate: _createDb, onUpgrade: _onUpgrade);
    itemCountDatabase.setVersion(NEW_DB_VERSION);

    return itemCountDatabase;
  }

  void _createDb(Database db, int newVesrion) async {
    print("_createDb SQlite: " + " newVersion " + newVesrion.toString());
    int dbVersion = await db.getVersion();

    print("Version Db: " + dbVersion.toString());

    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableName(ID INTEGER PRIMARY KEY AUTOINCREMENT, $colEmpId TEXT, $colImage TEXT, $colLat TeXT, $colLng TEXT,'
        '$colAlt TEXT, $colInternetStatus TEXT, $colDate TEXT , $colTime TEXT, $colAttendType TEXT,'
        '$colOutTime TEXT, $colInTimeStatus TEXT, $colOutTimeStatus TEXT, $colWorkStatus TEXT, $colDayStatus TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableSchool(ID INTEGER PRIMARY KEY AUTOINCREMENT, $schSchoolId TEXT, $schSchoolName TeXT, $schSchoolAttendance TEXT, $schSchoolAttendanceStatus TEXT , $schLastScreenDate TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableClass(ID INTEGER PRIMARY KEY AUTOINCREMENT, $clsSchoolId TEXT,'
        '$clsClassId TEXT, $clsName TEXT, $clsSection TEXT, $clsLastScreenDate TEXT, $clsAttendanceStatus TEXT , $clsStudentCount TEXT , $clsUDISECode TEXT)');
    await db.execute(
        'CREATE TABLE IF NOT EXISTS $tableStudent (ID INTEGER PRIMARY KEY AUTOINCREMENT, $stuSchoolId TEXT,'
        '$stuClassId TEXT, $stuStudentId TEXT, $studentUniqueId TEXT, $stuFirstName TEXT, $stuDob TEXT,'
        '$stuMobileNumber TEXT, $stuBloodGroup TEXT, $stuScreeningId TEXT , $stuAttendance TEXT , $studUDISECode TEXT)');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("_onUpgrade SQlite: oldVersion: " +
        oldVersion.toString() +
        " newVersion " +
        newVersion.toString());
  }

  Future<int> insertAttendanceIn(AttendanceReportDbModel itemDetails) async {
    Database db = await this.database;
    var results = db.insert(tableName, itemDetails.toJson());
    return results;
  }

  Future<List<Map<String, dynamic>>> queryAttendanceIn() async {
    var dbClient = await database;
    var results =
        await dbClient.rawQuery('SELECT * FROM $tableName LIMIT 0,30');
    return results;
  }

  Future<List<AttendanceReportDbModel>> fetchAttendanceIn() async {
    var list = await queryAttendanceIn();
    print("Attendance Length: " + list.length.toString());
    List<AttendanceReportDbModel> mList = <AttendanceReportDbModel>[];
    int c = list.length;
    for (int i = 0; i < c; i++) {
      mList.add(AttendanceReportDbModel.fromJson(list[i]));
    }
    return mList;
  }

  Future<List<Map<String, dynamic>>> validateAttendanceInByDate(
      String date) async {
    var dbClient = await database;
    var results = await dbClient
        .rawQuery("SELECT * FROM $tableName where $colDate = '$date'");
    return results;
  }

  Future<List<AttendanceReportDbModel>> fetchAttendanceInByDate(
      String date) async {
    var list = await validateAttendanceInByDate(date);
    List<AttendanceReportDbModel> mList = <AttendanceReportDbModel>[];
    int c = list.length;
    for (int i = 0; i < c; i++) {
      mList.add(AttendanceReportDbModel.fromJson(list[i]));
    }
    return mList;
  }

  Future<List<Map<String, dynamic>>> validateAttendanceOutByDate(
      String date) async {
    var dbClient = await database;
    var results = await dbClient
        .rawQuery("SELECT * FROM $tableName where $colDate = '$date'");
    return results;
  }

  Future<List<AttendanceReportDbModel>> fetchAttendanceOutByDate(
      String date) async {
    var list = await validateAttendanceOutByDate(date);
    print("OutDate: " + list.length.toString());
    List<AttendanceReportDbModel> mList = <AttendanceReportDbModel>[];
    int c = list.length;
    for (int i = 0; i < c; i++) {
      mList.add(AttendanceReportDbModel.fromJson(list[i]));
    }
    return mList;
  }

  //
  Future<List<Map<String, dynamic>>> getAttendanceInReportOffline(
      String status) async {
    var dbClient = await database;
    var results = await dbClient.rawQuery(
        "SELECT * FROM $tableName where $colInTimeStatus = '$status'");
    return results;
  }

  Future<List<AttendanceReportDbModel>> fetchAttendanceInReportOffline(
      String status) async {
    var list = await getAttendanceInReportOffline(status);

    List<AttendanceReportDbModel> mList = <AttendanceReportDbModel>[];
    int c = list.length;
    for (int i = 0; i < c; i++) {
      mList.add(AttendanceReportDbModel.fromJson(list[i]));
    }
    return mList;
  }

  //
  Future<List<Map<String, dynamic>>> getAttendanceOutReportOffline(
      String status) async {
    var dbClient = await database;
    var results = await dbClient.rawQuery(
        "SELECT * FROM $tableName where $colOutTimeStatus = '$status'");
    return results;
  }

  Future<List<AttendanceReportDbModel>> fetchAttendanceOutReportOffline(
      String status) async {
    var list = await getAttendanceOutReportOffline(status);

    List<AttendanceReportDbModel> mList = <AttendanceReportDbModel>[];
    int c = list.length;
    for (int i = 0; i < c; i++) {
      mList.add(AttendanceReportDbModel.fromJson(list[i]));
    }
    return mList;
  }

  Future<int> updateInternetStatus(
      InternetStatusModel internetStatusModel) async {
    Database db = await this.database;
    var results = db.update(tableName, internetStatusModel.toJson(),
        where: '$colDate=?', whereArgs: [internetStatusModel.date]);

    return results;
  }

  Future<int> updateOutTime(OutTimeModel outTimeModel) async {
    Database db = await this.database;
    var results = db.update(tableName, outTimeModel.toJson(),
        where: '$colDate=?', whereArgs: [outTimeModel.date]);

    return results;
  }

  Future<int> deleteUserData(String id) async {
    Database db = await this.database;
    var result =
        await db.delete(tableName, where: 'EmpId = ?', whereArgs: [id]);

    return result;
  }

  Future<int> insertSchoolList(SchoolListDbModel schoolListDbModel) async {
    Database db = await this.database;
    var results = db.insert(tableSchool, schoolListDbModel.toJson());
    return results;
  }

  Future<int> insertClassList(
      ClassListByEmpDbModel classListByEmpDbModel) async {
    Database db = await this.database;
    var results = db.insert(tableClass, classListByEmpDbModel.toJson());
    return results;
  }

  Future<int> insertStudentList(
      StudentListByEmpDbModel studentListByEmpDbModel) async {
    Database db = await this.database;
    var results = db.insert(tableStudent, studentListByEmpDbModel.toJson());
    return results;
  }
}
