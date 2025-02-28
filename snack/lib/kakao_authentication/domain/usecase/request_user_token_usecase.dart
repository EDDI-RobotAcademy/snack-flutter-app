abstract class RequestUserTokenUseCase {
  Future<String> execute(String accessToken, String email, String nickname);
}
