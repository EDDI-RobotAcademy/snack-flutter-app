import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:snack/kakao_authentication/domain/usecase/login_usecase.dart';
import 'package:snack/kakao_authentication/domain/usecase/logout_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snack/kakao_authentication/domain/usecase/logout_usecase_impl.dart';

import '../../domain/usecase/fetch_user_info_usecase.dart';
import '../../domain/usecase/request_user_token_usecase.dart';


class KakaoAuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final FetchUserInfoUseCase fetchUserInfoUseCase;
  final RequestUserTokenUseCase requestUserTokenUseCase;

  // Nuxt localStorage와 같은 역할, 보안이 필요한 데이터 저장
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  String? _accessToken;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _message = '';

  // 해당 변수 값을 즉시 가져올 수 있도록 구성
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;

  KakaoAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  }); // 객체 의존성 주입 받아 초기화

  Future<void> login() async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      _accessToken = await loginUseCase.execute();

      final userInfo = await fetchUserInfoUseCase.execute();

      final email = userInfo.kakaoAccount?.email;
      final nickname = userInfo.kakaoAccount?.profile?.nickname;

      final accountPath = "Kakao";  // ✅ 추가
      final roleType = "USER";  // ✅ 추가

      print("User email: $email, User nickname: $nickname, Account Path: $accountPath, Role Type: $roleType");

      _userToken = await requestUserTokenUseCase.execute(
          _accessToken!, email!, nickname!, accountPath, roleType);

      print("User Token obtained: $_userToken");

      await secureStorage.write(key: 'userToken', value: _userToken);

      _isLoggedIn = true;
      _message = '로그인 성공';
      print("Login successful");
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<User> fetchUserInfo() async {
    try {
      final userInfo = await fetchUserInfoUseCase.execute();
      return userInfo;
    } catch (e) {
      print("Kakao 사용자 정보 불러오기 실패: $e");
      rethrow;
    }
  }


  // 로그아웃 처리
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();  // 상태 변경 알림

    try {
      await logoutUseCase.execute();
      await secureStorage.delete(key: 'userToken');
      _isLoggedIn = false;
      _accessToken = null;
      _userToken = null;
      _message = '로그아웃 완료';

    } catch (e) {
      _message = "로그아웃 실패: $e";
    }
  }
}