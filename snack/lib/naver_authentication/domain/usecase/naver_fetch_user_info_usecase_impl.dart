import '../../infrastructure/data_sources/naver_auth_remote_data_source.dart';
import 'naver_fetch_user_info_usecase.dart';

class NaverFetchUserInfoUseCaseImpl implements NaverFetchUserInfoUseCase {
  final NaverAuthRemoteDataSource remote;

  NaverFetchUserInfoUseCaseImpl(this.remote);

  @override
  Future<Map<String, dynamic>> execute() async {
    return await remote.fetchUserInfoFromNaver();
  }
}
