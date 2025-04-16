import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class GoogleAuthRemoteDataSource {
  final String baseUrl;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: dotenv.env['GOOGLE_IOS_CLIENT_ID'],
    scopes: ['email', 'profile'],
  );

  GoogleAuthRemoteDataSource(this.baseUrl);

  Future<String?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("사용자가 Google 로그인을 취소함");
        return null;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print("로그인 성공:${googleAuth.accessToken}");
      return googleAuth.accessToken;
    } catch (error) {
      print("Google로그인 실패:$error");
      throw Exception("Google 로그인 실패!");
    }
  }

  Future<void> logoutWithGoogle() async {
    try {
      await _googleSignIn.signOut();
      print("Google 로그아웃 성공!");
    } catch (error) {
      print("로그아웃 실패: $error");
      throw Exception("Google 로그아웃 실패!");
    }
  }

  // 구글 API에서 사용자 정보를 가져오는 메서드
  Future<GoogleSignInAccount?> fetchUserInfoFromGoogle() async {
    try {
      GoogleSignInAccount? user = _googleSignIn.currentUser;

      if (user == null) {
        print("현재 로그인된 Google 사용자가 없음, 자동 로그인 시도");
        user = await _googleSignIn.signInSilently();  // 자동 로그인 기능
        print("결과: $user");
      }

      if (user == null) {
        print("자동 로그인 실패, 사용자 정보 없음");
        return null;
      }

      print("Google 사용자 정보: ${user.displayName ?? '이름 없음'}, ${user.email ?? '이메일 없음'}");
      return user;
    } catch (error) {
      print('❌ Error fetching user info: $error');
      throw Exception('Failed to fetch user info from Google');
    }
  }

  Future<String> requestUserTokenFromServer(
      String accessToken,
      String userId,
      String email,
      String nickname,
      String gender,
      String ageRange,
      String birthyear,
      ) async {
    final url = Uri.parse('$baseUrl/google-oauth/request-user-token'); // Django 서버 URL
    print('requestUserTokenFromServer url: $url');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json', 
        },
        body: json.encode({
          'access_token': accessToken,
          'email': email,
          'nickname': nickname,
          'user_id': userId,
          'gender': gender,               // 'unknown' 가능
          'age_range': ageRange,          // 'N/A' 가능
          'birthyear': birthyear,         // 예: '2000'
          'birthday': '01-01',            // 임의로라도 기본값 필수 (예: 생일 모를 땐 '01-01')
          'phone_num': '',
          'address': '',
          'payment': '',
          'subscribed': false,
          'name': nickname
          // 'access_token': accessToken,
          // 'email': email,
          // 'nickname': nickname,
          // 'user_id': userId,
          // 'gender': 'unknown',
          // 'age_range': 'N/A',
          // 'birthyear': '0000'
          // // 'account_path': 'Google',
          // // 'role_type': 'USER',
        }),
      );

      print('Server response status: ${response.statusCode}');
      print('Server response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Server response data: $data');
        return data['userToken'] ?? ''; // 실제 토큰 필드명에 맞게 수정
      } else {
        print('Error: Failed to request user token, status code: ${response.statusCode}');
        throw Exception('Failed to request user token: ${response.statusCode}');
      }
    } catch (error) {
      print('Error during request to server: $error');
      throw Exception('Request to server failed: $error');
    }
  }
}