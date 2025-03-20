import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoAuthRemoteDataSource {
  final String baseUrl;

  KakaoAuthRemoteDataSource(this.baseUrl);

  Future<String> loginWithKakao() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {   // 카카오톡 설치 확인
        token = await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공: ${token.accessToken}');
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
        print('카카오 계정으로 로그인 성공: ${token.accessToken}');
      }

      return token.accessToken;
    } catch (error) {
      print("로그인 실패: $error");
      throw Exception("Kakao 로그인 실패!");
    }
  }

  // 카카오 API에서 사용자 정보를 가져오는 메서드
  Future<User> fetchUserInfoFromKakao() async {
    try {
      final user = await UserApi.instance.me();
      print('User info: $user');
      return user;
    } catch (error) {
      print('Error fetching user info: $error');
      throw Exception('Failed to fetch user info from Kakao');
    }
  }

  Future<String> requestUserTokenFromServer(String accessToken, String email,
      String nickname, String accountPath, String roleType) async {
    final url = Uri.parse('$baseUrl/kakao-oauth/request-user-token');

    print('requestUserTokenFromServer url: $url');

    final requestData = json.encode({
      'access_token': accessToken,
      'email': email,
      'nickname': nickname,
      'account_path': accountPath,
      'role_type': roleType,
    });

    print('Request Data: $requestData'); //전송할 데이터 확인

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: requestData,
      );

      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['userToken'] ?? '';
      } else {
        print('Error: Failed to request user token, status code: ${response
            .statusCode}');
        return ''; // 예외 발생 시 빈 문자열 반환
      }
    } catch (error) {
      print('Error during request to server: $error');
      return '';
    }
  }
}