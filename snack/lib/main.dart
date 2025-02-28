import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

import 'kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import 'kakao_authentication/domain/usecase/login_usecase_impl.dart';
import 'kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart';
import 'kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import 'kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';
import 'kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'kakao_authentication/presentation/ui/kakao_login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  String baseServerUrl = dotenv.env['BASE_URL'] ?? '';
  String kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
  String kakaoJavaScriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'] ?? '';

  // 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey,
    javaScriptAppKey: kakaoJavaScriptAppKey,
  );

  runApp(MyApp(baseUrl: baseServerUrl));
}

class MyApp extends StatelessWidget {
  final String baseUrl;

  const MyApp({required this.baseUrl, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<KakaoAuthRemoteDataSource>(
            create: (_) => KakaoAuthRemoteDataSource(baseUrl)),
        ProxyProvider<KakaoAuthRemoteDataSource, KakaoAuthRepository>(
          update: (_, remoteDataSource, __) =>
              KakaoAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<KakaoAuthRepository, LoginUseCaseImpl>(
          update: (_, repository, __) => LoginUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, FetchUserInfoUseCaseImpl>(
          update: (_, repository, __) => FetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, RequestUserTokenUseCaseImpl>(
          update: (_, repository, __) =>
              RequestUserTokenUseCaseImpl(repository),
        ),
        ChangeNotifierProvider<KakaoAuthProvider>(
          create: (context) => KakaoAuthProvider(
            loginUseCase: context.read<LoginUseCaseImpl>(),
            fetchUserInfoUseCase: context.read<FetchUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<RequestUserTokenUseCaseImpl>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Kakao Login Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          quill.FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],
        home: KakaoLoginPage(),
      ),
    );
  }
}
