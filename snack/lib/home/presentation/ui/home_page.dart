import 'package:flutter/material.dart';
import 'package:snack/home/home_module.dart';

class HomePage extends StatelessWidget {
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
                "안녕하세요, 헝글님",
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
