import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

abstract class FetchUserInfoUseCase {
  Future<User> execute();
}
