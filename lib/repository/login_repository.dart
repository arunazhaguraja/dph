
import 'package:dph_tn/model/login_response.dart';

abstract class LoginRepository {
  Future<LoginResponse> fetchLoginResponse(String postJson, String from, String token, String id);
}
