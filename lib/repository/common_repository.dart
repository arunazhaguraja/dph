import 'package:dph_tn/model/common_user_model.dart';

abstract class CommonRepository {
  Future<CommonUserModel> fetchCommonUserResponse(String postJson,String type);
}
