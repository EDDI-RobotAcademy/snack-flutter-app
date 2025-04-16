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

  // 외부에서 접근할 수 있게 함
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;


   // 생성자
  GoogleAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  }) {
    _initAuthState(); // True -> HomePage,  False -> LoginPage
  }

  // 앱 시작 시 로그인 상태 확인하고 세팅
  // secureStorage에서 저장된 userToken을 확인하여 로그인 상태 복원
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
      notifyListeners();     // UI 변경을 감지해서 다시 그리게 함
    }
  }

  // 구글 로그인 처리:
  // Google 로그인 → 사용자 정보 요청 → 서버에 userToken 요청 → 저장 및 로그인 상태 업데이트
  Future<void> login() async {
    _isLoading = true;
    notifyListeners();  // UI에 상태 변경 알림

    try {
      _accessToken = await loginUseCase.execute();
      final userInfo = await fetchUserInfoUseCase.execute();

      if (userInfo == null) {
        throw Exception("Google 사용자 정보를 가져오지 못했습니다.");
      }
          // django 서버로 userToken 요청
      _userToken = await requestUserTokenUseCase.execute(
        _accessToken!,
        userInfo.id,  // id가 null ->  '0' 처리 후 변환
        userInfo.email ?? '',
        userInfo.displayName ?? '',
        "unknown",    // Google API에 gender 정보 없음
        "unknown",    // Google API에 ageRange 정보 없음
        "unknown",    // Google API에 birthyear 정보 없음
      );
          // secureStorage에 유저토큰 저장
      await secureStorage.write(key: 'userToken', value: _userToken);

      _isLoggedIn = true;
      _message = '로그인 성공';
      print("accesstoken:${_accessToken}");

      //await _initAuthState();     // 로그인 검증, 상태 확인
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 구글 로그아웃 처리: Google 로그아웃 → userToken 삭제 → 상태 초기화
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await logoutUseCase.execute();  // 구글 로그아웃
      await secureStorage.delete(key: 'userToken');
      _isLoggedIn = false;
      _accessToken = null;
      _userToken = null;
      _message = '로그아웃 완료';

      await _initAuthState();    // 로그아웃 후 상태 상태 초기화
    } catch (e) {
      _message = "로그아웃 실패: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
