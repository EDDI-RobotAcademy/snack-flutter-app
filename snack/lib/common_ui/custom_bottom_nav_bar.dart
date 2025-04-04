import 'package:flutter/material.dart';
import 'package:snack/home/presentation/ui/home_page.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String loginType;

  const CustomBottomNavBar({super.key, required this.loginType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navBarItem(context, 'assets/images/restaurant_icon.png', onTap: () {
            print("맛집 탭 클릭됨");
          }),
          _navBarItem(context, 'assets/images/friend_icon.png', onTap: () {
            print("밥친구 찾기 탭 클릭됨");
          }),
          _navBarItem(context, 'assets/images/home_icon.png', isCenter: true, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(loginType: loginType),
              ),
            );
          }),
          _navBarItem(context, 'assets/images/mypage_icon.png', onTap: () {
            print("마이페이지 탭 클릭됨");
          }),
          _navBarItem(context, 'assets/images/alarm_icon.png', onTap: () {
            print("알림 탭 클릭됨");
          }),
        ],
      ),
    );
  }

  Widget _navBarItem(
      BuildContext context,
      String iconPath, {
        bool isCenter = false,
        required VoidCallback onTap,
      }) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        iconPath,
        width: isCenter ? 50 : 40,
        height: isCenter ? 50 : 40,
      ),
    );
  }
}
