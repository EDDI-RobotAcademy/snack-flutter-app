import 'package:snack/kakao_authentication/infrastructure/data_sources/kakao_auth_remote_data_source.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'kakao_auth_repository.dart';


class KakaoAuthRepositoryImpl implements KakaoAuthRepository {
  final KakaoAuthRemoteDataSource remoteDataSource;

  KakaoAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login() async {
    print("KakaoAuthRepositoryImpl login()");
    return await remoteDataSource.loginWithKakao();
  }

  @override
  Future<void> logout(String userToken) async {
    print("KakaoAuthRepositoryImpl logout()");
    return await remoteDataSource.logoutWithKakao(userToken);
  }

  @override
  Future<User> fetchUserInfo() async {
    return await remoteDataSource.fetchUserInfoFromKakao();
  }

  @override
  Future<String> requestUserToken(
      String accessToken, String email, String nickname, String accountPath, String roleType) async {
    print(
        "Requesting user token with accessToken: $accessToken, email: $email, nickname: $nickname, account_path: $accountPath, role_type: $roleType");
    try {
      final userToken = await remoteDataSource.requestUserTokenFromServer(
          accessToken, email, nickname, accountPath, roleType);
      print("User token obtained: $userToken");
      return userToken;
    } catch (e) {
      print("Error during requesting user token: $e");
      throw Exception("Failed to request user token: $e");
    }
  }
}
