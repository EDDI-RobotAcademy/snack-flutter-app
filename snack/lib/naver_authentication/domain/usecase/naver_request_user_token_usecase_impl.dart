import '../../infrastructure/data_sources/naver_auth_remote_data_source.dart';
import 'naver_request_user_token_usecase.dart';

class NaverRequestUserTokenUseCaseImpl implements NaverRequestUserTokenUseCase {
  final NaverAuthRemoteDataSource remote;

  NaverRequestUserTokenUseCaseImpl(this.remote);

  @override
  Future<String> execute(
      String accessToken,
      String email,
      String nickname,
      String accountPath,
      String roleType,
      ) async {
    final token = await remote.requestUserTokenFromServer(
      accessToken: accessToken,
      email: email,
      nickname: nickname,
      accountPath: accountPath,
      roleType: roleType,
    );
    if (token == null) throw Exception("userToken 획득 실패");
    return token;
  }
}
