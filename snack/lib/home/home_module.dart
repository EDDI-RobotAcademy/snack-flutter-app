import 'package:flutter/material.dart';
import 'package:snack/home/presentation/ui/home_page.dart';

class HomeModule {
  static Widget provideHomePage() {
    return HomePage();
  }

  // ✅ 홈 페이지로 이동하는 라우트 제공
  static Route<dynamic> getHomeRoute() {
    return MaterialPageRoute(
      builder: (context) => provideHomePage(),
    );
  }
}
