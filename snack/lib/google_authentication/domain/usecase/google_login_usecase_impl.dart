import 'google_login_usecase.dart';
import '../../infrastructure/repository/google_auth_repository.dart';

class GoogleLoginUseCaseImpl implements GoogleLoginUseCase {
  final GoogleAuthRepository repository;

  GoogleLoginUseCaseImpl(this.repository);

  @override
  Future<String> execute() async {
    print("GoogleLoginUseCaseImpl execute()");
    return await repository.login();
  }
}