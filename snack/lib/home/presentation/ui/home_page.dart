import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:snack/home/home_module.dart';
import 'package:snack/common_ui/custom_bottom_nav_bar.dart';

import 'package:snack/kakao_authentication/infrastructure/data_sources/kakao_auth_remote_data_source.dart';
import 'package:snack/authentication/presentation/ui/login_page.dart';
import '../../../kakao_authentication/presentation/providers/kakao_auth_providers.dart';

import '../../../naver_authentication/infrastructure/data_sources/naver_auth_remote_data_source.dart';
import '../../../naver_authentication/presentation/providers/naver_auth_providers.dart';

import '../../../google_authentication/presentation/providers/google_auth_providers.dart';

class HomePage extends StatefulWidget {
  final String loginType;

  const HomePage({Key? key, required this.loginType}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String userEmail = "";
  String userNickname = "";

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    try {
      if (widget.loginType == "Kakao") {
        final kakaoProvider = Provider.of<KakaoAuthProvider>(context, listen: false);
        //final userInfo = await kakaoProvider.fetchUserInfo();

        if (!mounted) return;
        setState(() {
          // userEmail = userInfo.kakaoAccount?.email ?? "";
          // userNickname = userInfo.kakaoAccount?.profile?.nickname ?? "";
          userEmail = kakaoProvider.email ?? "";
          userNickname = kakaoProvider.nickname ?? "";
        });
      } else if (widget.loginType == "Naver") {
        // final naverProvider = Provider.of<NaverAuthProvider>(context, listen: false);
        // final userInfo = await naverProvider.fetchUserInfo();
        // setState(() {
        //   userEmail = userInfo.email ?? "이메일 정보 없음";
        //   userNickname = userInfo.nickname ?? "닉네임 없음";
        // });
      } else if (widget.loginType == "Google") {
        final googleProvider = Provider.of<GoogleAuthProvider>(context, listen: false);
        final userInfo = await googleProvider.fetchUserInfo();

        if (!mounted) return;
        setState(() {
          userEmail = userInfo?.email ?? "";
          userNickname = userInfo?.displayName ?? "";
        });
      }

    } catch (error) {
      if (!mounted) return;
      setState(() {
        userEmail = "이메일 불러오기 실패";
        userNickname = "닉네임 불러오기 실패";
      });
    }
  }

  void _logout() async {
    print("로그아웃을 시작합니다");
    if (widget.loginType == "Kakao") {
      final kakaoRemote = Provider.of<KakaoAuthRemoteDataSource>(context, listen: false);
      final kakaoProvider = Provider.of<KakaoAuthProvider>(context, listen: false);

      // secureStorage에서 userToken 읽기
      final userToken = await secureStorage.read(key: 'userToken');

      // 로그아웃 요청
      if (userToken != null) {
        await kakaoRemote.logoutWithKakao(userToken);
      }
      // provider 상태 완전 초기화
      kakaoProvider.logout();

    } else if (widget.loginType == "Naver") {
      final naverRemote = Provider.of<NaverAuthRemoteDataSource>(context, listen: false);
      // await naverRemote.logoutFromNaver();
      // Provider.of<NaverAuthProvider>(context, listen: false).logout();
    } else if (widget.loginType == "Google") {
      final googleProvider = Provider.of<GoogleAuthProvider>(context, listen: false);
      await googleProvider.logout();
    }
    print("로그아웃을 종료합니다.");

    // 로그아웃 이후 로그인 페이지 이동 pushAndRemoveUntil->앱 흐름 초기화
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, //false면 모든 이전 라우트 제거
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("홈페이지"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),

          Column(
            children: [
              Text(
                "안녕하세요, $userNickname 님!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "이메일: $userEmail",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 12),
              Text(
                "무엇을 찾고 계신가요?",
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
          SizedBox(height: 20), // 간격 추가
          // ✅ 검색창 UI
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            padding: EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey, width: 2),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "검색어를 입력하세요",
                    ),
                  ),
                ),
                Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),

          Spacer(),
          /// 공통 하단 네비게이션 바 적용
          CustomBottomNavBar(loginType: widget.loginType),
        ],
      ),
    );
  }
}
