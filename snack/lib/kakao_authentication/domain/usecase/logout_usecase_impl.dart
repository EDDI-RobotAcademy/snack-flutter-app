import 'package:snack/kakao_authentication/infrastructure/repository/kakao_auth_repository.dart';
import 'package:snack/kakao_authentication/domain/usecase/logout_usecase.dart';


class LogoutUseCaseImpl implements LogoutUseCase {
  final KakaoAuthRepository repository;

  LogoutUseCaseImpl(this.repository);

  @override
  Future<void> execute(String userToken) async {
    await repository.logout(userToken);
  }
}