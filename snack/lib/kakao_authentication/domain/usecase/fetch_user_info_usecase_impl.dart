import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../infrasturcture/repository/kakao_auth_repository.dart';
import 'fetch_user_info_usecase.dart';

class FetchUserInfoUseCaseImpl implements FetchUserInfoUseCase {
  final KakaoAuthRepository repository;

  FetchUserInfoUseCaseImpl(this.repository);

  @override
  Future<Map<String, dynamic>?> execute(String accessToken) async {
    return await repository.fetchUserInfo(accessToken);
  }
}