import 'google_login_usecase.dart';
import '../../infrastructure/repository/google_auth_repository.dart';

class GoogleLoginUseCaseImpl implements GoogleLoginUseCase {
  final GoogleAuthRepository repository;

  GoogleLoginUseCaseImpl(this.repository);

  @override
  Future<String> execute() async {
    return await repository.loginWithGoogle();
  }
}
