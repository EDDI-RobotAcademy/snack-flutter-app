import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';

import '../../domain/usecase/naver_login_usecase.dart';
import '../../domain/usecase/naver_fetch_user_info_usecase.dart';
import '../../domain/usecase/naver_request_user_token_usecase.dart';

class NaverAuthProvider with ChangeNotifier {
  final NaverLoginUseCase loginUseCase;
  final NaverFetchUserInfoUseCase fetchUserInfoUseCase;
  final NaverRequestUserTokenUseCase requestUserTokenUseCase;

  final secureStorage = const FlutterSecureStorage();

  String? _accessToken;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _message = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;

  NaverAuthProvider({
    required this.loginUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  });

  Future<Map<String, dynamic>> fetchUserInfo() async {
    try {
      return await fetchUserInfoUseCase.execute();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login() async {
    _isLoading = true;
    _message = '';
    notifyListeners();

    try {
      _accessToken = await loginUseCase.execute();
      final profile = await fetchUserInfoUseCase.execute();

      final email = profile['email'];
      final nickname = profile['nickname'];

      if (email == null || nickname == null) {
        throw Exception("이메일 또는 닉네임 없음");
      }

      _userToken = await requestUserTokenUseCase.execute(
        _accessToken!,
        email,
        nickname,
        "Naver",
        "USER",
      );

      await secureStorage.write(key: 'userToken', value: _userToken);
      _isLoggedIn = true;
      _message = '로그인 성공';
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await NaverLoginSDK.logout();
      await secureStorage.delete(key: 'userToken');
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      print("로그아웃 실패: $e");
    }
  }
}
