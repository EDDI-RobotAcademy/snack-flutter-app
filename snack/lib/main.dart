import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_naver_login/flutter_naver_login.dart';

import 'google_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import 'google_authentication/domain/usecase/google_login_usecase_impl.dart';
import 'google_authentication/infrastructure/data_sources/google_auth_remote_data_source.dart';
import 'google_authentication/infrastructure/repository/google_auth_repository.dart';
import 'google_authentication/infrastructure/repository/google_auth_repository_impl.dart';
import 'google_authentication/presentation/providers/google_auth_providers.dart';
import 'home/presentation/ui/home_page.dart';
import 'kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import 'kakao_authentication/domain/usecase/login_usecase_impl.dart';
import 'kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart';
import 'kakao_authentication/infrasturcture/data_sources/kakao_auth_remote_data_source.dart';
import 'kakao_authentication/infrasturcture/repository/kakao_auth_repository.dart';
import 'kakao_authentication/infrasturcture/repository/kakao_auth_repository_impl.dart';
import 'kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'authentication/presentation/ui/login_page.dart';
import 'naver_authentication/domain/usecase/naver_fetch_user_info_usecase_impl.dart';
import 'naver_authentication/domain/usecase/naver_request_user_token_usecase_impl.dart';
import 'naver_authentication/infrastructure/repository/naver_auth_repository.dart';
import 'home/home_module.dart';

import 'naver_authentication/infrastructure/data_sources/naver_auth_remote_data_source.dart';
import 'naver_authentication/infrastructure/repository/naver_auth_repository_impl.dart';
import 'naver_authentication/domain/usecase/naver_login_usecase_impl.dart';
import 'naver_authentication/presentation/providers/naver_auth_providers.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  String baseServerUrl = dotenv.env['BASE_URL'] ?? '';
  String kakaoNativeAppKey = dotenv.env['KAKAO_NATIVE_APP_KEY'] ?? '';
  String kakaoJavaScriptAppKey = dotenv.env['KAKAO_JAVASCRIPT_APP_KEY'] ?? '';

  // ✅ 카카오 SDK 초기화
  KakaoSdk.init(
    nativeAppKey: kakaoNativeAppKey,
    javaScriptAppKey: kakaoJavaScriptAppKey,
  );

  // 네이버 로그인 설정
  String clientId = dotenv.env['NAVER_CLIENT_ID'] ?? '';
  String clientSecret = dotenv.env['NAVER_CLIENT_SECRET'] ?? '';
  String clientName = dotenv.env['NAVER_CLIENT_NAME'] ?? '';

  //await FlutterNaverLogin.initSdk(
  //    clientId: clientId,
  //    clientName: clientName,
  //    clientSecret: clientSecret
  //);


  runApp(MyApp(baseUrl: baseServerUrl));
}

class MyApp extends StatelessWidget {
  final String baseUrl;


  const MyApp({
    super.key,
    required this.baseUrl,

  });


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
        Provider<NaverAuthRemoteDataSource>(
          create: (_) => NaverAuthRemoteDataSource(baseUrl),
        ),
        ProxyProvider<NaverAuthRemoteDataSource, NaverAuthRepository>(
          update: (_, remoteDataSource, __) =>
              NaverAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<NaverAuthRemoteDataSource, NaverAuthRepository>(
          update: (_, remoteDataSource, __) =>
              NaverAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<NaverAuthRepository, NaverLoginUseCaseImpl>(
          update: (_, repository, __) =>
              NaverLoginUseCaseImpl(repository),
        ),
        ProxyProvider<NaverAuthRepository, NaverFetchUserInfoUseCaseImpl>(
          update: (_, repository, __) =>
              NaverFetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<NaverAuthRepository, NaverRequestUserTokenUseCaseImpl>(
          update: (_, repository, __) =>
              NaverRequestUserTokenUseCaseImpl(repository),
        ),
        ChangeNotifierProvider<NaverAuthProvider>(
          create: (context) => NaverAuthProvider(
            loginUseCase: context.read<NaverLoginUseCaseImpl>(),
            fetchUserInfoUseCase: context.read<NaverFetchUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<NaverRequestUserTokenUseCaseImpl>(),
          ),
        ),
        Provider<GoogleAuthRemoteDataSource>(
          create: (_) => GoogleAuthRemoteDataSource(baseUrl),
        ),
        ProxyProvider<GoogleAuthRemoteDataSource, GoogleAuthRepository>(
          update: (_, remoteDataSource, __) =>
              GoogleAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleLoginUseCaseImpl>(
          update: (_, repository, __) => GoogleLoginUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, FetchGoogleUserInfoUseCaseImpl>(
          update: (_, repository, __) =>
              FetchGoogleUserInfoUseCaseImpl(repository),
        ),
        ChangeNotifierProvider<GoogleAuthProvider>(
          create: (context) => GoogleAuthProvider(
            loginUseCase: context.read<GoogleLoginUseCaseImpl>(),
            // fetchUserInfoUseCase: context.read<FetchGoogleUserInfoUseCaseImpl>(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Hungle App',
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
        home: Consumer2<KakaoAuthProvider, NaverAuthProvider>(
          builder: (context, kakaoProvider, naverProvider, child) {
            if (kakaoProvider.isLoggedIn) {
              return HomePage(loginType: "Kakao");
            } else if (naverProvider.isLoggedIn) {
              return HomePage(loginType: "Naver");
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}
