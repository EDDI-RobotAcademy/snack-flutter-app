import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleAuthRepository {
  Future<String> login();
  Future<void> logout();
  Future<GoogleSignInAccount?> fetchUserInfo();
  Future<String> requestUserToken(
      String accessToken,
      String userId,
      String email,
      String nickname,
      String gender,
      String ageRange,
      String birthyear,
      );
}
