import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class NaverAuthProvider with ChangeNotifier {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  NaverAuthProvider();

  Future<void> setToken(String token) async {
    _userToken = token;
    _isLoggedIn = true;

    await secureStorage.write(key: 'userToken', value: _userToken);

    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await secureStorage.delete(key: 'userToken');
      _userToken = null;
      _isLoggedIn = false;
      notifyListeners();
    } catch (e) {
      debugPrint("Naver 로그아웃 실패: $e");
    }
  }
}
