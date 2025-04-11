import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleAuthRemoteDataSource {
  final String baseUrl;

  GoogleAuthRemoteDataSource(this.baseUrl);

  Future<String> requestUserToken(String accessToken, String email,
      String nickname) async {
    final url = Uri.parse('$baseUrl/google-oauth/request-user-token');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'access_token': accessToken,
        'email': email,
        'nickname': nickname,
        'account_path': 'Google',
        'role_type': 'USER',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['userToken'];
    } else {
      throw Exception('유저 토큰 요청 실패');
    }
  }
}
