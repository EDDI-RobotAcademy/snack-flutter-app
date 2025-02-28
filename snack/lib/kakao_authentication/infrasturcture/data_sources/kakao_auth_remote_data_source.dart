import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoAuthRemoteDataSource {
  final String baseUrl;

  KakaoAuthRemoteDataSource(this.baseUrl);

  Future<String> loginWithKakao() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
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

  Future<String> requestUserTokenFromServer(
      String accessToken, String email, String nickname) async {
    final url =
    Uri.parse('$baseUrl/kakao-oauth/request-user-token'); // Django 서버 URL

    print('requestUserTokenFromServer url: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', // Ensure Content-Type is set
        },
        body: json.encode({
          'access_token': accessToken,
          'email': email,
          'nickname': nickname,
        }),
      );

      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Server response data: $data');
        return data['userToken'] ?? ''; // 실제 토큰 필드명에 맞게 수정
      } else {
        print(
            'Error: Failed to request user token, status code: ${response.statusCode}');
        throw Exception('Failed to request user token: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during request to server: $error');
      throw Exception('Request to server failed: $error');
    }
  }
}