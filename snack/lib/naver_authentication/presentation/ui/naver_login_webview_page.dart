import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../home/home_module.dart';
import '../providers/naver_auth_providers.dart';

class NaverLoginWebViewPage extends StatefulWidget {
  const NaverLoginWebViewPage({super.key});

  @override
  State<NaverLoginWebViewPage> createState() => _NaverLoginWebViewPageState();
}

class _NaverLoginWebViewPageState extends State<NaverLoginWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
            onNavigationRequest: (request) async {
              final url = request.url;
              debugPrint("🔍 Navigating to: $url");

              if (url.startsWith('flutter://naver-login-success')) {
                final uri = Uri.parse(url);
                final userToken = uri.queryParameters['userToken'];
                debugPrint("✅ userToken: $userToken");

                if (userToken != null && context.mounted) {
                  final provider = Provider.of<NaverAuthProvider>(context, listen: false);
                  await provider.setToken(userToken);

                  Navigator.pushReplacement(
                    context,
                    HomeModule.getHomeRoute(loginType: "Naver"),
                  );
                }

                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            }
        ),
      )
      ..loadRequest(Uri.parse(
        "https://nid.naver.com/oauth2.0/authorize?response_type=code&client_id=MAve2Vid1IJdVBfWyPPq&redirect_uri=http://192.168.0.39:8000/naver-oauth/redirect-access-token&state=random_state",
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("네이버 로그인")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
