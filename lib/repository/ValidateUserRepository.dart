import 'package:dph_tn/model/validate_user_model.dart';

abstract class ValidateUserRepository {
  Future<ValidateUserModel> fetchValidateUserResponse(String postJson,String type);
}
