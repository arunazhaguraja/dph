import 'package:dph_tn/model/class_list_by_school_model.dart';

abstract class ClassListBySchoolRepository {
  Future<ClassListBySchoolModel> fetchClassListBySchool(String postJson);
}
