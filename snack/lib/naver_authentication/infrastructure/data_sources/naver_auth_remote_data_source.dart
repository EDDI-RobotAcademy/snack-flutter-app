import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:naver_login_sdk/naver_login_sdk.dart';

class NaverAuthRemoteDataSource {
  final String baseUrl;

  NaverAuthRemoteDataSource(this.baseUrl);

  Future<String> loginWithNaver() async {
    try {
      await NaverLoginSDK.authenticate(
        callback: OAuthLoginCallback(
          onSuccess: () {},
          onFailure: (status, message) {
            throw Exception("로그인 실패: $status / $message");
          },
          onError: (code, message) {
            throw Exception("로그인 오류: $code / $message");
          },
        ),
      );
      // 로그인 성공 후 토큰 정보를 직접 받아옵니다.
      final tokenInfo = await NaverLoginSDK.getAccessToken();
      return tokenInfo;
    } catch (e) {
      throw Exception("Naver 로그인 예외 발생: $e");
    }
  }

  Future<Map<String, dynamic>> fetchUserInfoFromNaver() async {
    final Completer<Map<String, dynamic>> completer = Completer<Map<String, dynamic>>();

    try {
      await NaverLoginSDK.profile(
        callback: ProfileCallback(
          onSuccess: (resultCode, message, response) {
            completer.complete(response); // response를 Completer에 전달
          },
          onFailure: (httpStatus, message) {
            completer.completeError(Exception("사용자 정보 가져오기 실패: HttpStatus: $httpStatus, Message: $message"));
          },
          onError: (errorCode, message) {
            completer.completeError(Exception("사용자 정보 가져오기 오류: ErrorCode: $errorCode, Message: $message"));
          },
        ),
      );

      return completer.future; // Completer의 Future를 반환
    } catch (e) {
      throw Exception("Naver 사용자 정보 실패: $e");
    }
  }

  Future<String> requestUserTokenFromServer({
    required String accessToken,
    required String email,
    required String nickname,
    required String accountPath,
    required String roleType,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/naver-oauth/request-user-token'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'access_token': accessToken,
        'email': email,
        'nickname': nickname,
        'account_path': accountPath,
        'role_type': roleType,
      }),
    );

    final data = jsonDecode(response.body);
    if (response.statusCode == 200 && data['userToken'] != null) {
      return data['userToken'];
    } else {
      throw Exception('유저 토큰 요청 실패: ${data['error_message'] ?? 'Unknown'}');
    }
  }

  Future<void> logoutFromNaver() async {
    try {
      await NaverLoginSDK.logout();
    } catch (e) {
      throw Exception("로그아웃 실패: $e");
    }
  }
}
