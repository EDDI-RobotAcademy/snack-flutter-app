import 'package:snack/google_authentication/domain/usecase/google_request_user_token_usecase.dart';
import '../../infrastructure/repository/google_auth_repository.dart';

class GoogleRequestUserTokenUseCaseImpl implements GoogleRequestUserTokenUseCase {
  final GoogleAuthRepository repository;

  GoogleRequestUserTokenUseCaseImpl(this.repository);

  @override
  Future<String> execute(
      String accessToken,
      String userId,
      String email,
      String nickname,
      String gender,
      String ageRange,
      String birthyear) async {
    try {
      // Django 서버로 요청하여 User Token 반환
      final userToken = await repository.requestUserToken(accessToken, userId, email, nickname, gender, ageRange, birthyear);
      print("User token obtained: $userToken");
      return userToken;
    } catch (error) {
      print("Error while requesting user token: $error");
      throw Exception('Failed to request user token: $error');
    }
  }
}