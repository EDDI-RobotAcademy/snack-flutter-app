import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:snack/kakao_authentication/domain/usecase/login_usecase.dart';
import 'package:snack/kakao_authentication/domain/usecase/logout_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
  String _nickname = '';
  String _email = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;
  String get nickname => _nickname;
  String get email => _email;

  KakaoAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  }) {
    _initAuthState();
  }

  Future<void> _initAuthState() async {
    _isLoading = true;
    notifyListeners();
    try {
      _userToken = await secureStorage.read(key: 'userToken');
      _isLoggedIn = _userToken != null;
    } catch (e) {
      print("초기화 오류: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login() async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      _accessToken = await loginUseCase.execute();

      final userInfo = await fetchUserInfoUseCase.execute();
      final email = userInfo.kakaoAccount?.email;
      final nickname = userInfo.kakaoAccount?.profile?.nickname;

      final accountPath = "Kakao";
      final roleType = "USER";

      print(
          "👤 유저 정보 → 닉네임: $nickname, 이메일: $email, 로그인 경로: $accountPath, 권한 타입: $roleType");

      _userToken = await requestUserTokenUseCase.execute(
          _accessToken!, email!, nickname!, accountPath, roleType);

      await secureStorage.write(key: 'userToken', value: _userToken);
      print("🔐 userToken: $_userToken");

      _isLoggedIn = true;
      _message = 'Kakao 로그인 성공';
      await _initAuthState();
    } catch (e) {
      _isLoggedIn = false;
      _message = "Kakao 로그인 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User> fetchUserInfo() async {
    try {
      final userInfo = await fetchUserInfoUseCase.execute();
      return userInfo;
    } catch (e) {
      print("KakaoSDK 사용자 정보 불러오기 실패: $e");
      rethrow;
    }
  }

  Future<void> setToken(String token) async {
    _userToken = token;
    _isLoggedIn = true;

    await secureStorage.write(key: 'userToken', value: _userToken);

    notifyListeners();
  }

  void setUserInfo(String email, String nickname) {
    _email = email;
    _nickname = nickname;
    notifyListeners();
  }


  // 로그아웃 처리
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await secureStorage.read(key: 'userToken');
      if (token != null) {
        await logoutUseCase.execute(token);
      }

      await secureStorage.delete(key: 'userToken');
      _isLoggedIn = false;
      _accessToken = null;
      _userToken = null;
      _message = 'Kakao 로그아웃 완료';
    } catch (e) {
      _message = "Kakao 로그아웃 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
