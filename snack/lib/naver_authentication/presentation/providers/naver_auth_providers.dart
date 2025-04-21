import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snack/naver_authentication/infrastructure/data_sources/naver_auth_remote_data_source.dart';



class NaverAuthProvider with ChangeNotifier {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final NaverAuthRemoteDataSource remoteDataSource;

  NaverAuthProvider({required this.remoteDataSource}) {
    _initAuthState();
  }

  String? _userToken;
  String _email = '';
  String _nickname = '';
  bool _isLoggedIn = false;
  bool _isLoading = false;

  String get userToken => _userToken ?? '';

  String get email => _email;

  String get nickname => _nickname;

  bool get isLoggedIn => _isLoggedIn;

  bool get isLoading => _isLoading;



  Future<void> _initAuthState() async {
    _isLoading = true;
    notifyListeners();
    try {
      _userToken = await secureStorage.read(key: 'userToken');
      _isLoggedIn = _userToken != null;
    } catch (e) {
      print('초기화 실패: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
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

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final token = await secureStorage.read(key: 'userToken');

      if (token != null) {
        await remoteDataSource.logoutWithNaver(token); // 🔹 Django 서버 로그아웃 호출
        await secureStorage.delete(key: 'userToken');
      }

      _userToken = null;
      _email = '';
      _nickname = '';
      _isLoggedIn = false;

      print("✅ 네이버 로그아웃 완료");
    } catch (e) {
      print("❌ 네이버 로그아웃 실패: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}




//   Future<void> setToken(String token) async {
//     _userToken = token;
//     _isLoggedIn = true;
//
//     await secureStorage.write(key: 'userToken', value: _userToken);
//
//     notifyListeners();
//   }
//
//   Future<void> logout() async {
//     try {
//       await secureStorage.delete(key: 'userToken');
//       _userToken = null;
//       _isLoggedIn = false;
//       notifyListeners();
//     } catch (e) {
//       debugPrint("Naver 로그아웃 실패: $e");
//     }
//   }
// }

