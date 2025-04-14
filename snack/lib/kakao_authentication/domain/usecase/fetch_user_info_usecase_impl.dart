import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../infrastructure/repository/kakao_auth_repository.dart';
import 'fetch_user_info_usecase.dart';

class FetchUserInfoUseCaseImpl implements FetchUserInfoUseCase {
  final KakaoAuthRepository repository;

  FetchUserInfoUseCaseImpl(this.repository);

  @override
  Future<User> execute() async {
    return await repository.fetchUserInfo();
  }
}
