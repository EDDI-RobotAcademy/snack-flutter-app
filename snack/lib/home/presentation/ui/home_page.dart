import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:snack/home/home_module.dart';
import 'package:snack/kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final KakaoAuthRemoteDataSource _authRemoteDataSource = KakaoAuthRemoteDataSource(dotenv.env['BASE_URL'] ?? "");
  String userEmail = "이메일을 불러오는 중...";

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    try {
      final user = await _authRemoteDataSource.fetchUserInfoFromKakao();
      setState(() {
        userEmail = user.kakaoAccount?.email ?? "이메일 정보 없음";
      });
    } catch (error) {
      print("Error fetching user email: $error");
      setState(() {
        userEmail = "이메일 불러오기 실패";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Spacer(),

          // ✅ 사용자 인사 텍스트
          Column(
            children: [
              Text(
                "안녕하세요, $userEmail",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
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
          Navigator.pushReplacement(context, HomeModule.getHomeRoute());
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
