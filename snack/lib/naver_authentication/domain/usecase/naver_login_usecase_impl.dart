import '../../infrastructure/data_sources/naver_auth_remote_data_source.dart';
import 'naver_login_usecase.dart';

class NaverLoginUseCaseImpl implements NaverLoginUseCase {
  final NaverAuthRemoteDataSource remote;

  NaverLoginUseCaseImpl(this.remote);

  @override
  Future<String> execute() async {
    return await remote.loginWithNaver();
  }
}
