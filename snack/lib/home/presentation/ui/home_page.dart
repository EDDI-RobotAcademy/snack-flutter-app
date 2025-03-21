import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:snack/home/home_module.dart';
import 'package:snack/kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'package:snack/authentication/presentation/ui/login_page.dart';

import '../../../kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import '../../../naver_authentication/infrastructure/data_sources/naver_auth_remote_data_source.dart';
import '../../../naver_authentication/presentation/providers/naver_auth_providers.dart';

class HomePage extends StatefulWidget {
  final String loginType;

  const HomePage({Key? key, required this.loginType}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userEmail = "이메일을 불러오는 중...";
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
        final userInfo = await kakaoProvider.fetchUserInfo();
        setState(() {
          userEmail = userInfo.kakaoAccount?.email ?? "이메일 정보 없음";
          userNickname = userInfo.kakaoAccount?.profile?.nickname ?? "닉네임 없음";
        });
      } else if (widget.loginType == "Naver") {
        final naverProvider = Provider.of<NaverAuthProvider>(context, listen: false);
        final userInfo = await naverProvider.fetchUserInfo();
        setState(() {
          userEmail = userInfo.email ?? "이메일 정보 없음";
          userNickname = userInfo.nickname ?? "닉네임 없음";
        });
      }
    } catch (error) {
      setState(() {
        userEmail = "이메일 불러오기 실패";
        userNickname = "닉네임 불러오기 실패";
      });
    }
  }

  void _logout() async {
    if (widget.loginType == "Kakao") {
      final kakaoRemote = Provider.of<KakaoAuthRemoteDataSource>(context, listen: false);
      await kakaoRemote.logoutFromKakao();
      Provider.of<KakaoAuthProvider>(context, listen: false).logout();
    } else if (widget.loginType == "Naver") {
      final naverRemote = Provider.of<NaverAuthRemoteDataSource>(context, listen: false);
      await naverRemote.logoutFromNaver();
      Provider.of<NaverAuthProvider>(context, listen: false).logout();
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
          SizedBox(height: 20), // 간격 추
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

          // ✅ 하단 네비게이션 바
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _navBarItem(context, 'assets/images/restaurant_icon.png'),
                _navBarItem(context, 'assets/images/friend_icon.png'),
                _navBarItem(context, 'assets/images/home_icon.png', isCenter: true), // 홈 버튼
                _navBarItem(context, 'assets/images/mypage_icon.png'),
                _navBarItem(context, 'assets/images/alarm_icon.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ 하단 네비게이션 바 아이템 (홈 버튼 클릭 시 홈 이동)
  Widget _navBarItem(BuildContext context, String iconPath, {bool isCenter = false}) {
    return GestureDetector(
      onTap: () {
        if (iconPath == 'assets/images/home_icon.png') {
          // ✅ 홈 버튼 클릭 시 홈 페이지로 이동
          Navigator.pushReplacement(
              context,
            MaterialPageRoute(builder: (context) => HomePage(loginType: widget.loginType)),
          );
        }
      },
      child: Image.asset(
        iconPath,
        width: isCenter ? 50 : 40, // 홈 버튼 크기 강조
        height: isCenter ? 50 : 40,
      ),
    );
  }
}
