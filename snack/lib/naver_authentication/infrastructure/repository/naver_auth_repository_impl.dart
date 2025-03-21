import 'dart:convert'; // JSON 처리를 위한 import 추가
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'naver_auth_repository.dart';
import 'package:snack/naver_authentication/infrastructure/data_sources/naver_auth_remote_data_source.dart';




class NaverAuthRepositoryImpl implements NaverAuthRepository {
  final NaverAuthRemoteDataSource remoteDataSource;

  NaverAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login() async {
    print("NaverAuthRepositoryImpl login()");
    // 네이버 로그인 처리 후 액세스 토큰 반환
    return await remoteDataSource.loginWithNaver();
  }

  @override
  Future<NaverAccountResult> fetchUserInfo() async {
    print("Fetching user info from Naver");
    // 네이버 사용자 정보 가져오기
    return await remoteDataSource.fetchUserInfoFromNaver();
  }

  @override
  Future<String> requestUserToken(
      String accessToken, String email, String nickname, String accountPath, String roleType) async {
    print(
        "Requesting user token with accessToken: $accessToken, email: $email, nickname: $nickname, account_path: $accountPath, role_type: $roleType");
    try {
      // ✅ userToken이 null일 경우 대비하여 `?? ''`로 기본값 설정
      final String? userToken = await remoteDataSource.requestUserTokenFromServer(
          accessToken, email, nickname, accountPath, roleType);

      if (userToken == null || userToken.isEmpty) {
        print("⚠️ User token is null or empty!");
        throw Exception("Failed to obtain user token. Response was null or empty.");
      }

      print("✅ User token obtained: $userToken");
      return userToken;
    } catch (e) {
      print("❌ Error during requesting user token: $e");
      throw Exception("Failed to request user token: $e");
    }
  }

}

