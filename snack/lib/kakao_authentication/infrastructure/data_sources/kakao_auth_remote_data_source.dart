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

  Future<void> logoutWithKakao(String userToken) async {
    try {
      // 플러터 로컬 로그아웃
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.logout();
        print('카카오톡으로 로그아웃 실행');
      } else {
        await UserApi.instance.logout();
        print('카카오 계정으로 로그아웃 실행');
      }

      // 백엔드 서버에 로그아웃 요청
      final url = Uri.parse('$baseUrl/authentication/kakao-logout');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $userToken',
          'Content-Type': 'application/json',
        },
        body: json.encode({ 'userToken': userToken }),
      );

      if (response.statusCode == 200) {
      } else {
        print("백엔드 로그아웃 실패: ${response.statusCode}, ${response.body}");
      }

    } catch (error) {
      // 로그아웃 중 오류 발생 - 예: 네트워크 오류, SDK 내부 오류 등
      print('로그아웃 중 예외 발생: $error');

      // 특정 로그: 이미 로그아웃된 상태에서 재로그아웃 시 나오는 메시지 제거
      if (error.toString().contains("authentication token doesn't exist")) {
        print('로그아웃된 상태입니다.');
      } else {
        throw Exception("Kakao 로그아웃 실패: $error");
      }
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
      String accessToken,
      String email,
      String nickname,
      String accountPath,
      String roleType,
      ) async {
    final url = Uri.parse('$baseUrl/kakao-oauth/request-user-token');

    final requestData = json.encode({
      'access_token': accessToken,
      'email': email,
      'nickname': nickname,
      'account_path': accountPath,
      'role_type': roleType,
    });

    print('Request Data: $requestData');

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: requestData,
      );

      if (response.statusCode == 200) {
        final userToken = response.headers['usertoken'];
        if (userToken != null && userToken.isNotEmpty) {
          return userToken;
        } else {
          return '';
        }
      } else {
        return '';
      }
    } catch (error) {
      return '';
    }
  }
}