import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:snack/kakao_authentication/infrastructure/data_sources/kakao_auth_remote_data_source.dart';

class NaverAuthRemoteDataSource {
  final String baseUrl;

  NaverAuthRemoteDataSource(this.baseUrl);

  Future<void> logoutWithNaver(String userToken) async {
    final url = Uri.parse('$baseUrl/authentication/naver-logout');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'userToken': userToken}),
    );

    if (response.statusCode == 200) {
      print("🟢 Django 서버 로그아웃 성공");
    } else {
      print("🔴 Django 서버 로그아웃 실패: ${response.statusCode} - ${response.body}");
    }
  }
}

  /// 1. 네이버 로그인 → access token 리턴
  // Future<String> loginWithNaver() async {
  //   try {
  //     // 네이버 로그인 시도
  //     final NaverLoginResult result = await FlutterNaverLogin.logIn();
  //     print("로그인 상태: ${result.status}");
  //
  //     // 🚀 로그인 성공했지만 accessToken이 비어 있는 경우 대비
  //     String? accessToken = result.accessToken?.accessToken;
  //     if (accessToken == null || accessToken.isEmpty) {
  //       print("⚠️ accessToken이 비어 있음. currentAccessToken() 호출!");
  //       final NaverAccessToken newToken = await FlutterNaverLogin.currentAccessToken;
  //       accessToken = newToken.accessToken;
  //     }
  //
  //     print("최종 네이버 accessToken: $accessToken");
  //
  //     if (accessToken == null || accessToken.isEmpty) {
  //       throw Exception("Naver 로그인 실패: accessToken이 null 또는 비어 있음");
  //     }
  //
  //     // 🔥 서버에 유저 토큰 요청
  //     final serverResponse = await requestUserTokenFromServer(
  //       accessToken,
  //       "ajeseung@naver.com",
  //       "ajes****",
  //       "Naver",
  //       "USER",
  //     );
  //
  //     print("서버 응답: $serverResponse");
  //
  //     return accessToken;
  //   } catch (error) {
  //     print("로그인 실패: $error");
  //     throw Exception("Naver 로그인 실패!");
  //   }
  // }
  //
  //
  //
  // /// 2. 네이버 SDK에서 사용자 정보 가져오기
  // Future<NaverAccountResult> fetchUserInfoFromNaver() async {
  //   try {
  //     final result = await FlutterNaverLogin.currentAccount();
  //     if (result != null) {
  //       print("네이버 사용자 정보: ${result.email}, ${result.nickname}");
  //       return result;
  //     } else {
  //       throw Exception("네이버 사용자 정보 없음");
  //     }
  //   } catch (error) {
  //     print('Error fetching user info: $error');
  //     throw Exception('Failed to fetch user info from Naver');
  //   }
  // }
  //====================================================
  // /// 3. 서버에 유저 토큰 요청
  // Future<String?> requestUserTokenFromServer(
  //     String accessToken,
  //     String email,
  //     String nickname,
  //     String accountPath,
  //     String roleType,
  //     ) async {
  //   final url = Uri.parse('$baseUrl/naver-oauth/request-user-token');
  //
  //   final requestData = json.encode({
  //     'access_token': accessToken,
  //     'email': email,
  //     'nickname': nickname,
  //     'account_path': accountPath,
  //     'role_type': roleType,
  //   });
  //
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         'Authorization': 'Bearer $accessToken',
  //         'Content-Type': 'application/json',
  //       },
  //       body: requestData,
  //     );
  //
  //     print("서버 응답: ${response.statusCode}, ${response.body}");
  //
  //     final data = json.decode(response.body);
  //
  //     // ✅ userToken이 없으면 null 반환
  //     if (response.statusCode == 200 && data.containsKey('userToken')) {
  //       final userToken = data['userToken'];
  //       print("✅ 서버에서 받은 userToken: $userToken");
  //       return userToken;
  //     } else {
  //       final errorMessage = data['error_message'] ?? 'Unknown error from server';
  //       print("⚠️ 서버 응답 오류: $errorMessage");
  //       return null;  // 안전한 null 반환
  //     }
  //   } catch (error) {
  //     print("❌ requestUserTokenFromServer 에러: $error");
  //     return null;  // 예외 발생 시 null 반환
  //   }
  // }
//=================================================================

  // Future<void> logoutFromNaver() async {
  //   try {
  //     await FlutterNaverLogin.logOut();
  //     print("✅ Naver 로그아웃 성공");
  //   } catch (error) {
  //     print("❌ Naver 로그아웃 실패: $error");
  //   }
  // }

//}
