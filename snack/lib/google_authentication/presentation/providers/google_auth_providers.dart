import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecase/google_login_usecase.dart';
import '../../domain/usecase/google_logout_usecase.dart';
import '../../domain/usecase/google_fetch_user_info_usecase.dart';
import '../../domain/usecase/google_request_user_token_usecase.dart';


class GoogleAuthProvider with ChangeNotifier {
  final GoogleLoginUseCase loginUseCase;
  final GoogleLogoutUseCase logoutUseCase;
  final GoogleFetchUserInfoUseCase fetchUserInfoUseCase;
  final GoogleRequestUserTokenUseCase requestUserTokenUseCase;

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  String? _accessToken;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _message = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;

  GoogleAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  }) {
    _initAuthState(); // 앱 시작 시 로그인 상태 확인
  }

  // 초기 로그인 상태 확인
  Future<void> _initAuthState() async {
    _isLoading = true;
    notifyListeners();
    try {
      _userToken = await secureStorage.read(key: 'userToken');
      _isLoggedIn = _userToken != null;
      print("초기 로그인 상태: $_isLoggedIn");
    } catch (e) {
      print("초기화 오류: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 로그인 처리
  Future<void> login() async {
    _isLoading = true;
    notifyListeners();  // 상태 변경 알림

    try {
      _accessToken = await loginUseCase.execute();
      final userInfo = await fetchUserInfoUseCase.execute();

      if (userInfo == null) {
        throw Exception("Google 사용자 정보를 가져오지 못했습니다.");
      }
      _userToken = await requestUserTokenUseCase.execute(
        _accessToken!,
        userInfo.id,  // id가 null ->  '0' 처리 후 변환
        userInfo.email ?? '',  // 이메일이 null -> 빈 문자열
        userInfo.displayName ?? '',  // 닉네임이 null -> 빈 문자열
        "unknown",  // Google API에서 gender 정보 없음
        "unknown",  // Google API에서 ageRange 정보 없음
        "unknown",  // Google API에서 birthyear 정보 없음
      );

      await secureStorage.write(key: 'userToken', value: _userToken);

      _isLoggedIn = true;
      _message = '로그인 성공';
      print("accesstoken:${_accessToken}");

      // 로그인 후 상태 초기화 호출
      await _initAuthState();
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();  // 상태 변경 알림
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

      // 로그아웃 후 상태 초기화 호출
      await _initAuthState();
    } catch (e) {
      _message = "로그아웃 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();  // 상태 변경 알림
    }
  }
}
