import 'package:dph_tn/model/district_model.dart';

abstract class DistrictRepository {
  Future<DistricModel> fetchDistrictResponse(String type);
}