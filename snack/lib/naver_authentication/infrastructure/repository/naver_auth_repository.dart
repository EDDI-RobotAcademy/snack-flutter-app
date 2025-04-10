abstract class NaverAuthRepository {
  Future<String> requestUserToken(String accessToken);
  Future<Map<String, dynamic>> fetchUserInfo(String userToken);
}
