import 'package:google_sign_in/google_sign_in.dart';
import '../../infrastructure/repository/google_auth_repository.dart';
import 'google_fetch_user_info_usecase.dart';

class GoogleFetchUserInfoUseCaseImpl implements GoogleFetchUserInfoUseCase {
  final GoogleAuthRepository repository;

  GoogleFetchUserInfoUseCaseImpl(this.repository);

  @override
  Future<GoogleSignInAccount?> execute() async {
    return await repository.fetchUserInfo();
  }
}


