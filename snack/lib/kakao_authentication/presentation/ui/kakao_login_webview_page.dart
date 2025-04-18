import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../home/home_module.dart';
import '../providers/kakao_auth_providers.dart';

class KakaoLoginWebViewPage extends StatefulWidget {
  const KakaoLoginWebViewPage({super.key});

  @override
  State<KakaoLoginWebViewPage> createState() => _KakaoLoginWebViewPageState();
}

class _KakaoLoginWebViewPageState extends State<KakaoLoginWebViewPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final clientId = dotenv.env['KAKAO_REST_API_KEY'] ?? '';
    final redirectUri = dotenv.env['KAKAO_REDIRECT_URI'] ?? '';

    final authUri = Uri.https(
      'kauth.kakao.com',
      '/oauth/authorize',
      {
        'grant_type': 'authorization_code',
        'response_type': 'code',
        'client_id': clientId,
        'redirect_uri': redirectUri,
      },
    );

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) async {
            final url = request.url;
            debugPrint("🔍 Navigating to: $url");

            if (url.startsWith('flutter://kakao-login-success')) {
              final uri = Uri.parse(url);
              final userToken = uri.queryParameters['userToken'];
              debugPrint("✅ userToken: $userToken");

              if (userToken != null && context.mounted) {
                final provider =
                    Provider.of<KakaoAuthProvider>(context, listen: false);
                await provider.setToken(userToken);

                Navigator.pushReplacement(
                  context,
                  HomeModule.getHomeRoute(loginType: "Kakao"),
                );
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(authUri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("카카오 로그인")),
      body: WebViewWidget(controller: _controller),
    );
  }
}
