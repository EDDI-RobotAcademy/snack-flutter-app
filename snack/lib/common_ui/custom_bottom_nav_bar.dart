import 'package:flutter/material.dart';
import 'package:snack/home/presentation/ui/home_page.dart';
import 'package:snack/board/board_module.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:snack/board/presentation/ui/board_list_page.dart';
import 'package:snack/board/presentation/providers/board_list_provider.dart';

class CustomBottomNavBar extends StatelessWidget {
  final String loginType;

  const CustomBottomNavBar({super.key, required this.loginType});

  @override
  Widget build(BuildContext context) {
    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _navBarItem(context, 'assets/images/restaurant_icon.png', onTap: () {
            print("맛집 탭 클릭됨");
          }),

          // 보드 아이콘 탭 클릭 시
          _navBarItem(context, 'assets/images/friend_icon.png', onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MultiProvider(
                  providers: BoardModule.provideListBoardProviders(),
                  child: BoardListPage(loginType: loginType),
                ),
              ),
            );
          }),

          //홈
          _navBarItem(context, 'assets/images/home_icon.png', isCenter: true, onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(loginType: loginType), // ✅ 로그인 타입 전달 유지
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
