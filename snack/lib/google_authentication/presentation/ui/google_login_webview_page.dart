// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:webview_flutter/webview_flutter.dart';
// import 'package:flutter_dotenv/flutter_dotenv.dart';
//
// import '../../../home/home_module.dart';
// import '../providers/google_auth_providers.dart';
//
// class GoogleLoginWebViewPage extends StatefulWidget {
//   const GoogleLoginWebViewPage({super.key});
//
//   @override
//   State<GoogleLoginWebViewPage> createState() => _GoogleLoginWebViewPageState();
// }
//
// class _GoogleLoginWebViewPageState extends State<GoogleLoginWebViewPage> {
//   late final WebViewController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//
//     final clientId = dotenv.env['GOOGLE_CLIENT_ID'] ?? '';
//     final redirectUri = dotenv.env['GOOGLE_REDIRECT_URI'] ?? '';
//
//     final authUri = Uri.https(
//       'accounts.google.com',
//       '/o/oauth2/v2/auth',
//       {
//         'client_id': clientId,
//         'redirect_uri': redirectUri,
//         'response_type': 'code',
//         'scope': 'email profile openid',
//         'access_type': 'offline',
//         'prompt': 'consent',
//       },
//     );
//
//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onNavigationRequest: (request) async {
//             final url = request.url;
//             debugPrint("🔍 Navigating to: $url");
//
//             if (url.startsWith('flutter://google-login-success')) {
//               final uri = Uri.parse(url);
//               final userToken = uri.queryParameters['userToken'];
//               debugPrint("✅ userToken: $userToken");
//
//               if (userToken != null && context.mounted) {
//                 final provider =
//                 Provider.of<GoogleAuthProvider>(context, listen: false);
//                 await provider.setToken(userToken);
//
//                 Navigator.pushReplacement(
//                   context,
//                   HomeModule.getHomeRoute(loginType: "Google"),
//                 );
//               }
//
//               return NavigationDecision.prevent;
//             }
//
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(authUri);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("구글 로그인")),
//       body: WebViewWidget(controller: _controller),
//     );
//   }
// }
