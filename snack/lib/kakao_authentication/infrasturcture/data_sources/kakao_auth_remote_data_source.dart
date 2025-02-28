import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoAuthRemoteDataSource {
  final String baseUrl;

  KakaoAuthRemoteDataSource(this.baseUrl);

  Future<String?> login() async {
    final response = await http.post(Uri.parse('$baseUrl/auth/kakao/login'));
    if (response.statusCode == 200) {
      return json.decode(response.body)['access_token'];
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchUserInfo(String accessToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/auth/kakao/userinfo'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }
    return null;
  }

  Future<String?> requestUserToken(String accessToken, String email, String nickname) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/kakao/request-token'),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: json.encode({'email': email, 'nickname': nickname}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['user_token'];
    }
    return null;
  }
}