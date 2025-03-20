import 'package:snack/naver_authentication/domain/usecase/naver_request_user_token_usecase.dart';
import '../../infrastructure/repository/naver_auth_repository.dart';

class NaverRequestUserTokenUseCaseImpl implements NaverRequestUserTokenUseCase {
  final NaverAuthRepository repository;

  NaverRequestUserTokenUseCaseImpl(this.repository);

  @override
  Future<String> execute(
      String accessToken, String email, String nickname, String accountPath, String roleType) async {
    try {
      final userToken =
      await repository.requestUserToken(accessToken, email, nickname, accountPath, roleType);
      print("User token obtained: $userToken");
      return userToken;
    } catch (error) {
      print("Error while requesting user token: $error");
      throw Exception('Failed to request user token: $error');
    }
  }
}
