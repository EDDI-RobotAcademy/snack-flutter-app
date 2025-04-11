// import 'package:flutter_naver_login/flutter_naver_login.dart';

abstract class NaverAuthRepository {
  Future<String> login(); // 로그인 시 액세스 토큰을 반환
  // Future<NaverAccountResult> fetchUserInfo(); // 사용자 정보를 반환 (NaverAccountResult 형태)
  Future<String> requestUserToken(
      String accessToken, String email, String nickname, String accountPath, String roleType); // 추가 토큰 요청
}
