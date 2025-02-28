import 'package:snack/kakao_authentication/domain/usecase/login_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/usecase/fetch_user_info_usecase.dart';
import '../../domain/usecase/request_user_token_usecase.dart';

class KakaoAuthProvider with ChangeNotifier {
  final LoginUseCase loginUseCase;
  final FetchUserInfoUseCase fetchUserInfoUseCase;
  final RequestUserTokenUseCase requestUserTokenUseCase;

  String? _accessToken;
  String? _userToken;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _message = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get message => _message;

  KakaoAuthProvider({
    required this.loginUseCase,
    required this.fetchUserInfoUseCase,
    required this.requestUserTokenUseCase,
  });

  Future<void> login() async {
    _isLoading = true;
    notifyListeners();

    try {
      _accessToken = await loginUseCase.execute();
      final userInfo = await fetchUserInfoUseCase.execute(_accessToken!);

      final email = userInfo?['email'];
      final nickname = userInfo?['nickname'];

      _userToken = await requestUserTokenUseCase.execute(_accessToken!, email, nickname);

      _isLoggedIn = true;
      _message = '로그인 성공';
    } catch (e) {
      _isLoggedIn = false;
      _message = "로그인 실패: $e";
    }

    _isLoading = false;
    notifyListeners();
  }
}