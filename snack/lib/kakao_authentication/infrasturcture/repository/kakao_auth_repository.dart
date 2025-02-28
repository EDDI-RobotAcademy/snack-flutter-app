import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

abstract class KakaoAuthRepository {
  Future<String?> login();
  Future<Map<String, dynamic>?> fetchUserInfo(String accessToken);
  Future<String?> requestUserToken(String accessToken, String email, String nickname);
}