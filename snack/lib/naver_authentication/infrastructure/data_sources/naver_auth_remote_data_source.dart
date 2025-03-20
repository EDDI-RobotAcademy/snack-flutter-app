import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_naver_login/flutter_naver_login.dart';


class NaverAuthRemoteDataSource {
  final String baseUrl;

  NaverAuthRemoteDataSource(this.baseUrl);

  Future<String> loginWithNaver() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/login/naver'));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['accessToken'];
      } else {
        throw Exception("Naver 로그인 실패: HTTP ${response.statusCode}");
      }
    } catch (error) {
      print("로그인 실패: $error");
      throw Exception("Naver 로그인 실패!");
    }
  }

  Future<NaverAccountResult> fetchUserInfoFromNaver() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/user/info'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to fetch user info.");
      }
    } catch (error) {
      print('Error fetching user info: $error');
      throw Exception('Failed to fetch user info from Naver');
    }
  }

  Future<String> requestUserTokenFromServer(String accessToken, String email, String nickname, String accountPath, String roleType) async {
    final url = Uri.parse('$baseUrl/naver-oauth/request-user-token');

    final requestData = json.encode({
      'access_token': accessToken,
      'email': email,
      'nickname': nickname,
      'account_path': accountPath,
      'role_type': roleType,
    });

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: requestData,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['userToken'];
    } else {
      throw Exception("Failed to request user token: HTTP ${response.statusCode}");
    }
  }
}
