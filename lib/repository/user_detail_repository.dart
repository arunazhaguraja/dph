import 'package:dph_tn/model/userdetailsmodel.dart';

abstract class UserDetailsRepository {
  Future<UserDetailsModel> fetchUserDetailsResponse(String postJson);
}