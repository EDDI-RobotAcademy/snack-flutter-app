import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snack/naver_authentication/presentation/providers/naver_auth_providers.dart';
import 'package:snack/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import '../../../google_authentication/presentation/providers/google_auth_providers.dart';
import '../../../home/home_module.dart';
import '../../../kakao_authentication/presentation/ui/kakao_login_webview_page.dart';
import '../../../naver_authentication/presentation/ui/naver_login_webview_page.dart';
import '../../../google_authentication/presentation/ui/google_login_webview_page.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: screenHeight, // 화면 전체 높이만큼 확보
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 로고
              Image.asset(
                'assets/images/hungll_logo_long.png',
                width: 180,
              ),

              const SizedBox(height: 50),

              // 카카오 로그인 버튼
              Consumer<KakaoAuthProvider>(
                builder: (context, kakaoProvider, child) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const KakaoLoginWebViewPage()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/kakao_login.png',
                      width: 200,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // 네이버 로그인 버튼
              Consumer<NaverAuthProvider>(
                builder: (context, naverProvider, child) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const NaverLoginWebViewPage()),
                      );
                    },
                    child: Image.asset(
                      'assets/images/naver_login.png',
                      width: 200,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              // 구글 로그인 버튼
              Consumer<GoogleAuthProvider>(
                builder: (context, googleProvider, child) {
                  return GestureDetector(
                    // onTap: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => const GoogleLoginWebViewPage()),
                    //   );
                    // },
                    onTap: googleProvider.isLoading
                        ? null
                        : () async {
                            await googleProvider.login();
                            if (googleProvider.isLoggedIn) {
                              Navigator.pushReplacement(
                                context,
                                HomeModule.getHomeRoute(loginType: "Google"),
                              );
                            }
                          },
                    child: Image.asset(
                      'assets/images/google_login.png',
                      width: 200,
                      height: 50,
                      fit: BoxFit.fill,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
