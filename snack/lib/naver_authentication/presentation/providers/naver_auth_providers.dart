import 'package:snack/naver_authentication/domain/usecase/naver_login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import '../../domain/usecase/naver_fetch_user_info_usecase.dart';
import '../../domain/usecase/naver_request_user_token_usecase.dart';


class NaverAuthProvider with ChangeNotifier {
  final NaverLoginUseCase loginUseCase;
  final NaverFetchUserInfoUseCase fetchUserInfoUseCase;
  final NaverRequestUserTokenUseCase requestUserTokenUseCase;

  // Nuxt localStorage와 같은 역할
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

  NaverAuthProvider({
    required this.loginUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  });

  Future<void> login() async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      print("Naver loginUseCase.execute()");
      _accessToken = await loginUseCase.execute();
      print("AccessToken obtained: $_accessToken");

      final NaverAccountResult userInfo = await FlutterNaverLogin.currentAccount();
      print("User Info fetched: $userInfo");


      final email = userInfo.email;
      final nickname = userInfo.nickname;

      final accountPath = "Naver";  // ✅ 추가
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
      print(e.toString());
    }

    _isLoading = false;
    notifyListeners();
  }
}