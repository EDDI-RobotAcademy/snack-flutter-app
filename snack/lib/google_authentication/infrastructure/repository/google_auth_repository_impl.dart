import 'package:google_sign_in/google_sign_in.dart';
import '../data_sources/google_auth_remote_data_source.dart';
import 'google_auth_repository.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  final GoogleAuthRemoteDataSource remoteDataSource;

  GoogleAuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> loginWithGoogle() async {
    final account = await GoogleSignIn().signIn();
    final auth = await account?.authentication;
    final accessToken = auth?.accessToken;

    if (accessToken != null) {
      final userToken = await remoteDataSource.requestUserToken(accessToken);
      return userToken;
    } else {
      throw Exception("Google 로그인 실패");
    }
  }
}
