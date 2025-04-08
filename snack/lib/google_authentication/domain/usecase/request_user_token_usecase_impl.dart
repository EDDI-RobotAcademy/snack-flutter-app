import 'request_user_token_usecase.dart';
import '../../infrastructure/data_sources/google_auth_remote_data_source.dart';

class RequestGoogleUserTokenUseCaseImpl implements RequestGoogleUserTokenUseCase {
  final GoogleAuthRemoteDataSource remoteDataSource;

  RequestGoogleUserTokenUseCaseImpl(this.remoteDataSource);

  @override
  Future<String> execute({
    required String accessToken,
    required String email,
    required String nickname,
  }) async {
    return await remoteDataSource.requestUserToken(accessToken, email, nickname);
  }
}