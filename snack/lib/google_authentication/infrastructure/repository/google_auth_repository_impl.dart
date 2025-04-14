import 'package:snack/google_authentication/infrastructure/data_sources/google_auth_remote_data_source.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'google_auth_repository.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  final GoogleAuthRemoteDataSource remoteDataSource;

  GoogleAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> login() async {
    print("GoogleAuthRepositoryImpl login()");
    return await remoteDataSource.loginWithGoogle() ?? '';
  }

  @override
  Future<void> logout() async {
    print("GoogleAuthRepositoryImpl logout()");
    return await remoteDataSource.logoutWithGoogle();
  }

  @override
  Future<GoogleSignInAccount?> fetchUserInfo() async {
    return await remoteDataSource.fetchUserInfoFromGoogle();
  }

  @override
  Future<String> requestUserToken(
      String accessToken,
      String userId,
      String email,
      String nickname,
      String gender,
      String ageRange,
      String birthyear,
      ) async {
    print("Requesting user token with accessToken: $accessToken, user_id: $userId, email: $email, nickname: $nickname");
    try {
      final userToken = await remoteDataSource.requestUserTokenFromServer(
        accessToken,
        userId,
        email,
        nickname,
        gender,
        ageRange,
        birthyear,
      );
      print("User token obtained: $userToken");
      return userToken;
    } catch (e) {
      print("Error during requesting user token: $e");
      throw Exception("Failed to request user token: $e");
    }
  }
}
