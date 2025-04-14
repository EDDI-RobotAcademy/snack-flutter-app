import '../../infrastructure/repository/kakao_auth_repository.dart';
import 'login_usecase.dart';

class LoginUseCaseImpl implements LoginUseCase {
  final KakaoAuthRepository repository;

  LoginUseCaseImpl(this.repository);

  @override
  Future<String> execute() async {
    print("LoginUseCaseImpl execute()");
    return await repository.login();
  }
}