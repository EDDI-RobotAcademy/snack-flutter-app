import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snack/kakao_authentication/kakao_auth_module.dart'; // 카카오 로그인 모듈 경로
import 'package:snack/naver_authentication/naver_auth_module.dart'; // 네이버 로그인 모듈 경로
import 'package:snack/google_authentication/google_auth_module.dart'; // 네이버 로그인 모듈 경로
import 'package:snack/authentication/presentation/ui/login_page.dart';

class AuthModule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ...KakaoAuthModule.provideKakaoProviders(), // 카카오 로그인 관련 프로바이더
        ...NaverAuthModule.provideNaverProviders(), // 네이버 로그인 관련 프로바이더
        ...GoogleAuthModule.provideGoogleProviders(), // 구글 로그인 관련 프로바이더
      ],
      child: MaterialApp(
        home: LoginPage(), // 로그인 페이지
      ),
    );
  }
}
