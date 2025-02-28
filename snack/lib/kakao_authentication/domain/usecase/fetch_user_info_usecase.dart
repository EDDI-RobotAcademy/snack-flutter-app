import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

abstract class FetchUserInfoUseCase {
  Future<Map<String, dynamic>?> execute(String accessToken);
}