import 'package:snack/kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'kakao_auth_repository.dart';

class KakaoAuthRepositoryImpl implements KakaoAuthRepository {
  final KakaoAuthRemoteDataSource remoteDataSource;

  KakaoAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String?> login() async {
    return await remoteDataSource.login();
  }

  @override
  Future<Map<String, dynamic>?> fetchUserInfo(String accessToken) async {
    return await remoteDataSource.fetchUserInfo(accessToken);
  }

  @override
  Future<String?> requestUserToken(String accessToken, String email, String nickname) async {
    return await remoteDataSource.requestUserToken(accessToken, email, nickname);
  }
}