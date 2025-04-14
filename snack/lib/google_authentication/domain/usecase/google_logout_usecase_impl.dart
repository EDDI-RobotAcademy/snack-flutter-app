import '../../infrastructure/repository/google_auth_repository.dart';
import 'google_logout_usecase.dart';

class GoogleLogoutUseCaseImpl implements GoogleLogoutUseCase {
  final GoogleAuthRepository repository;

  GoogleLogoutUseCaseImpl(this.repository);

  @override
  Future<void> execute() async {
    print("GoogleLogoutUseCaseImpl execute()");
    await repository.logout();
  }
}