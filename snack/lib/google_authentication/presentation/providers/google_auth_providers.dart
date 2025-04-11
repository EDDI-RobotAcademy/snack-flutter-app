import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecase/google_login_usecase.dart';


class GoogleAuthProvider with ChangeNotifier {
  final GoogleLoginUseCase loginUseCase;
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _userToken = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  GoogleAuthProvider({required this.loginUseCase});

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userToken = await loginUseCase.execute();
      _userToken = userToken;
      await secureStorage.write(key: 'userToken', value: userToken);
      _isLoggedIn = true;
    } catch (e) {
      _isLoggedIn = false;
    }

    _isLoading = false;
    notifyListeners();
  }
}
