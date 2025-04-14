abstract class GoogleRequestUserTokenUseCase {
  Future<String> execute(
      String accessToken,
      String userId,
      String email,
      String nickname,
      String gender,
      String ageRange,
      String birthyear,
      );
}