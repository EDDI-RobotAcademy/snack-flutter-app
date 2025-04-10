import 'package:http/http.dart' as http;
import 'dart:convert';

import 'naver_auth_repository.dart';

class NaverAuthRepositoryImpl implements NaverAuthRepository {
  final String backendUrl;

  NaverAuthRepositoryImpl(this.backendUrl);

  @override
  Future<String> requestUserToken(String accessToken) async {
    final response = await http.post(
      Uri.parse('$backendUrl/auth/naver/'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'access_token': accessToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['user_token']; // Django에서 보내주는 user token
    } else {
      throw Exception('User token 요청 실패: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> fetchUserInfo(String userToken) async {
    final response = await http.get(
      Uri.parse('$backendUrl/auth/profile/'),
      headers: {
        'Authorization': 'Bearer $userToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('유저 정보 불러오기 실패');
    }
  }
}
