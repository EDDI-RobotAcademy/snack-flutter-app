import 'package:snack/kakao_authentication/domain/usecase/request_user_token_usecase.dart';
import '../../infrastructure/repository/kakao_auth_repository.dart';

class RequestUserTokenUseCaseImpl implements RequestUserTokenUseCase {
  final KakaoAuthRepository repository;

  RequestUserTokenUseCaseImpl(this.repository);

  @override
  Future<String> execute(
      String accessToken, String email, String nickname, String accountPath, String roleType) async {
    try {
      final userToken =
      await repository.requestUserToken(accessToken, email, nickname, accountPath, roleType);
      return userToken;
    } catch (error) {
      throw Exception('Failed to request user token: $error');
    }
  }
}
