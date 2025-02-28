import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/kakao_auth_providers.dart';

class KakaoLoginPage extends StatelessWidget {
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
            child: Image.asset(
              'assets/images/hungle_app_logo.png', //
              width: 180, // 로고 크기 조절
            ),
          ),

          SizedBox(height: 50), // 로고 아래 여백

          Consumer<KakaoAuthProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return CircularProgressIndicator(); // 로딩 중이면 스피너 표시
              }

              return GestureDetector(
                onTap: provider.isLoading ? null : () => provider.login(),
                child: Image.asset(
                  'assets/images/kakao_login_medium_wide.png', // ✅ 에셋 이미지 버튼으로 사용
                  width: 280, // 버튼 크기 조정
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
