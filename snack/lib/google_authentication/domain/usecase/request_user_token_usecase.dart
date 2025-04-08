abstract class RequestGoogleUserTokenUseCase {
  Future<String> execute({
    required String accessToken,
    required String email,
    required String nickname,
  });
}