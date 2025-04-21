import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'home/presentation/ui/home_page.dart';
import 'authentication/presentation/ui/login_page.dart';
import 'home/home_module.dart';
import 'policy/agreement_page.dart';
import 'package:snack/common_ui/logo_screen.dart';

//카카오 로그인 관련 의존성 추가
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import 'kakao_authentication/domain/usecase/login_usecase_impl.dart';
import 'kakao_authentication/domain/usecase/logout_usecase_impl.dart';
import 'kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart';
import 'kakao_authentication/infrastructure/data_sources/kakao_auth_remote_data_source.dart';
import 'kakao_authentication/infrastructure/repository/kakao_auth_repository.dart';
import 'kakao_authentication/infrastructure/repository/kakao_auth_repository_impl.dart';
import 'kakao_authentication/presentation/providers/kakao_auth_providers.dart';


// 네이버 로그인
// import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'naver_authentication/domain/usecase/naver_fetch_user_info_usecase_impl.dart';
import 'naver_authentication/domain/usecase/naver_request_user_token_usecase_impl.dart';
import 'naver_authentication/infrastructure/repository/naver_auth_repository.dart';
import 'naver_authentication/infrastructure/data_sources/naver_auth_remote_data_source.dart';
import 'naver_authentication/infrastructure/repository/naver_auth_repository_impl.dart';
import 'naver_authentication/domain/usecase/naver_login_usecase_impl.dart';
import 'naver_authentication/presentation/providers/naver_auth_providers.dart';


// Google 로그인 관련 의존성 추가
import 'google_authentication/domain/usecase/google_login_usecase_impl.dart';
import 'google_authentication/domain/usecase/google_logout_usecase_impl.dart';
import 'google_authentication/domain/usecase/google_fetch_user_info_usecase_impl.dart';
import 'google_authentication/domain/usecase/google_request_user_token_usecase_impl.dart';
import 'google_authentication/infrastructure/data_sources/google_auth_remote_data_source.dart';
import 'google_authentication/infrastructure/repository/google_auth_repository.dart';
import 'google_authentication/infrastructure/repository/google_auth_repository_impl.dart';
import 'google_authentication/presentation/providers/google_auth_providers.dart';




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


  runApp(MyApp(baseUrl: baseServerUrl));
}

class MyApp extends StatefulWidget {
  final String baseUrl;
  const MyApp({super.key, required this.baseUrl});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _showLogo = true;
  bool _agreed = false; // ✅ 약관 동의 여부 상태

  @override
  void initState() {
    super.initState();

    _loadAgreementStatus();

    // 앱 실행 후 3초 동안 로고 페이지 보여주고, 이후 약관 페이지로 이동
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _showLogo = false;
      });
    });
  }

  Future<void> _loadAgreementStatus() async {
    final agreed = await _storage.read(key: 'agreementAccepted');
    setState(() {
      _agreed = agreed == 'true';
    });
  }

  Future<void> _saveAgreementStatus() async {
    await _storage.write(key: 'agreementAccepted', value: 'true');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<KakaoAuthRemoteDataSource>(
            create: (_) => KakaoAuthRemoteDataSource(widget.baseUrl)),
        ProxyProvider<KakaoAuthRemoteDataSource, KakaoAuthRepository>(
          update: (_, remoteDataSource, __) =>
              KakaoAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<KakaoAuthRepository, LoginUseCaseImpl>(
          update: (_, repository, __) => LoginUseCaseImpl(repository),
        ),
        ProxyProvider<KakaoAuthRepository, LogoutUseCaseImpl>(
          update: (_, repository, __) => LogoutUseCaseImpl(repository),
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
            logoutUseCase: context.read<LogoutUseCaseImpl>(),
            fetchUserInfoUseCase: context.read<FetchUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<RequestUserTokenUseCaseImpl>(),
          ),
        ),
        // Provider<NaverAuthRemoteDataSource>(
        //   create: (_) => NaverAuthRemoteDataSource(baseUrl),
        // ),
        // ProxyProvider<NaverAuthRemoteDataSource, NaverAuthRepository>(
        //   update: (_, remoteDataSource, __) =>
        //       NaverAuthRepositoryImpl(remoteDataSource),
        // ),
        // ProxyProvider<NaverAuthRemoteDataSource, NaverAuthRepository>(
        //   update: (_, remoteDataSource, __) =>
        //       NaverAuthRepositoryImpl(remoteDataSource),
        // ),
        // ProxyProvider<NaverAuthRepository, NaverLoginUseCaseImpl>(
        //   update: (_, repository, __) =>
        //       NaverLoginUseCaseImpl(repository),
        // ),
        // ProxyProvider<NaverAuthRepository, NaverFetchUserInfoUseCaseImpl>(
        //   update: (_, repository, __) =>
        //       NaverFetchUserInfoUseCaseImpl(repository),
        // ),
        // ProxyProvider<NaverAuthRepository, NaverRequestUserTokenUseCaseImpl>(
        //   update: (_, repository, __) =>
        //       NaverRequestUserTokenUseCaseImpl(repository),
        // ),
        // ChangeNotifierProvider<NaverAuthProvider>(
        //   create: (context) => NaverAuthProvider(
        //     loginUseCase: context.read<NaverLoginUseCaseImpl>(),
        //     fetchUserInfoUseCase: context.read<NaverFetchUserInfoUseCaseImpl>(),
        //     requestUserTokenUseCase: context.read<NaverRequestUserTokenUseCaseImpl>(),
        //   ),
        // ),
        // ChangeNotifierProvider<NaverAuthProvider>(
        //   create: (_) => NaverAuthProvider(),
        // ),

        Provider<NaverAuthRemoteDataSource>(
          create: (_) => NaverAuthRemoteDataSource(widget.baseUrl),
        ),
        ChangeNotifierProvider<NaverAuthProvider>(
          create: (context) => NaverAuthProvider(
            remoteDataSource: context.read<NaverAuthRemoteDataSource>(),
          ),
        ),

        Provider<GoogleAuthRemoteDataSource>(
          create: (_) => GoogleAuthRemoteDataSource(widget.baseUrl),
        ),
        ProxyProvider<GoogleAuthRemoteDataSource, GoogleAuthRepository>(
          update: (_, remoteDataSource, __) =>
              GoogleAuthRepositoryImpl(remoteDataSource),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleLoginUseCaseImpl>(
          update: (_, repository, __) => GoogleLoginUseCaseImpl(repository),

        ),
        ProxyProvider<GoogleAuthRepository, GoogleLogoutUseCaseImpl>(
          update: (_, repository, __) => GoogleLogoutUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleFetchUserInfoUseCaseImpl>(
          update: (_, repository, __) => GoogleFetchUserInfoUseCaseImpl(repository),
        ),
        ProxyProvider<GoogleAuthRepository, GoogleRequestUserTokenUseCaseImpl>(
          update: (_, repository, __) => GoogleRequestUserTokenUseCaseImpl(repository),
        ),

        ChangeNotifierProvider<GoogleAuthProvider>(
          create: (context) => GoogleAuthProvider(
            loginUseCase: context.read<GoogleLoginUseCaseImpl>(),
            logoutUseCase: context.read<GoogleLogoutUseCaseImpl>(),
            fetchUserInfoUseCase: context.read<GoogleFetchUserInfoUseCaseImpl>(),
            requestUserTokenUseCase: context.read<GoogleRequestUserTokenUseCaseImpl>(),
          ),
        ),

        // ProxyProvider4<
        //     GoogleLoginUseCaseImpl,
        //     GoogleLogoutUseCaseImpl,
        //     GoogleFetchUserInfoUseCaseImpl,
        //     GoogleRequestUserTokenUseCaseImpl,
        //     GoogleAuthProvider
        // >(
        //   update: (
        //       _,
        //       loginUseCase,
        //       logoutUseCase,
        //       fetchUserInfoUseCase,
        //       requestUserTokenUseCase,
        //       __,
        //       ) =>
        //       GoogleAuthProvider(
        //         loginUseCase: loginUseCase,
        //         logoutUseCase: logoutUseCase,
        //         fetchUserInfoUseCase: fetchUserInfoUseCase,
        //         requestUserTokenUseCase: requestUserTokenUseCase,
        //       ),
        // ),

      ],
      child: MaterialApp(
        title: 'HUNGLL App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          quill.FlutterQuillLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],


        home: _showLogo
            ? const LogoScreen()
            : Consumer3<KakaoAuthProvider, NaverAuthProvider, GoogleAuthProvider>(
          builder: (context, kakaoProvider, naverProvider, googleProvider, child) {
            if (kakaoProvider.isLoggedIn) {
              return const HomePage(loginType: "Kakao");
            } else if (naverProvider.isLoggedIn) {
              return const HomePage(loginType: "Naver");
            } else if (googleProvider.isLoggedIn) {
              return const HomePage(loginType: "Google");
            } else if (!_agreed) {
              return AgreementPage(
                onAgreed: () async {
                  await _saveAgreementStatus();
                  setState(() {
                    _agreed = true;
                  });
                },
              );
            } else {
              return LoginPage();
            }
          },
        ),
      ),
    );
  }
}