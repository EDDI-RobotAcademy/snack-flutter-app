import 'package:flutter/material.dart';
import 'package:snack/home/presentation/ui/home_page.dart';

class HomeModule {
  static MaterialPageRoute getHomeRoute({required String loginType}) {
    return MaterialPageRoute(
      builder: (context) => HomePage(loginType: loginType),
    );
  }
}