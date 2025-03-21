import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snack/naver_authentication/presentation/providers/naver_auth_providers.dart';
import 'package:snack/kakao_authentication/presentation/providers/kakao_auth_providers.dart';

import '../../../home/home_module.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경색 흰색
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(), // 상단 여백 확보

          // 헝글 로고 이미지
          Center(
            child: Transform.translate(
              offset: Offset(0, -20),
              child: Image.asset(
                'assets/images/hungle_app_logo.png',
                width: 180, // 로고 크기 조절
              ),
            ),
          ),

          SizedBox(height: 50), // 로고 아래 여백

          // 카카오 로그인 버튼
          Consumer<KakaoAuthProvider>(
            builder: (context, kakaoProvider, child) {
              return GestureDetector(
                onTap: kakaoProvider.isLoading
                    ? null
                    : () async {
                  await kakaoProvider.login();
                  // ✅ 로그인 성공하면 HomePage로 이동
                  if (kakaoProvider.isLoggedIn) {
                    Navigator.pushReplacement(
                      context,
                      HomeModule.getHomeRoute(loginType: "Kakao"),
                    );
                  }
                },
                child: Container(
                  width: 200, // 버튼 크기 조정
                  height: 50, // 버튼 높이
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/kakao_login.png'),
                      fit: BoxFit.fill, // 이미지 비율 유지하면서 크기 맞춤
                    ),
                  ),
                ),
              );
            },
          ),

          SizedBox(height: 10), // 카카오 버튼 아래 여백

          // 네이버 로그인 버튼
          Consumer<NaverAuthProvider>(
            builder: (context, naverProvider, child) {
              return GestureDetector(
                onTap: naverProvider.isLoading
                    ? null
                    : () async {
                  await naverProvider.login();
                  // ✅ 로그인 성공하면 HomePage로 이동
                  if (naverProvider.isLoggedIn) {
                    Navigator.pushReplacement(
                      context,
                      HomeModule.getHomeRoute(loginType: "Naver"),
                    );
                  }
                },
                child: Container(
                  width: 200, // 버튼 크기 조정
                  height: 50, // 버튼 높이
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/naver_login.png'),
                      fit: BoxFit.fill, // 이미지 비율 유지하면서 크기 맞춤
                    ),
                  ),
                ),
              );
            },
          ),

          Spacer(), // 하단 여백 확보
        ],
      ),
    );
  }
}
