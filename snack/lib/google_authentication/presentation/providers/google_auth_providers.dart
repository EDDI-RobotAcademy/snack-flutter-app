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

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _userToken = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;

  GoogleAuthProvider({
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  });

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
