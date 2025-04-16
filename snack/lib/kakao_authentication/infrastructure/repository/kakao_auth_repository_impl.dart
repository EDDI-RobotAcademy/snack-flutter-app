import 'package:snack/kakao_authentication/infrastructure/data_sources/kakao_auth_remote_data_source.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'kakao_auth_repository.dart';


class KakaoAuthRepositoryImpl implements KakaoAuthRepository {
  final KakaoAuthRemoteDataSource remoteDataSource;

  KakaoAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login() async {
    return await remoteDataSource.loginWithKakao();
  }

  @override
  Future<void> logout(String userToken) async {
    return await remoteDataSource.logoutWithKakao(userToken);
  }

  @override
  Future<User> fetchUserInfo() async {
    return await remoteDataSource.fetchUserInfoFromKakao();
  }

  @override
  Future<String> requestUserToken(
      String accessToken, String email, String nickname, String accountPath, String roleType) async {
    try {
      final userToken = await remoteDataSource.requestUserTokenFromServer(
          accessToken, email, nickname, accountPath, roleType);
      return userToken;
    } catch (e) {
      print("Error during requesting user token: $e");
      throw Exception("Failed to request user token: $e");
    }
  }
}
