import 'package:flutter_naver_login/flutter_naver_login.dart';

abstract class NaverFetchUserInfoUseCase {
  Future<NaverAccountResult> execute();
}