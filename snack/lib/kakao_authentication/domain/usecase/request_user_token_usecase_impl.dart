import 'package:snack/kakao_authentication/domain/usecase/request_user_token_usecase.dart';
import '../../infrasturcture/repository/kakao_auth_repository.dart';

class RequestUserTokenUseCaseImpl implements RequestUserTokenUseCase {
  final KakaoAuthRepository repository;

  RequestUserTokenUseCaseImpl(this.repository);

  @override
  Future<String?> execute(String accessToken, String email, String nickname) async {
    return await repository.requestUserToken(accessToken, email, nickname);
  }
}