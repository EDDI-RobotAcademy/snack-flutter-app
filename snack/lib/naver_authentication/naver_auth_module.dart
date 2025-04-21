import 'package:provider/single_child_widget.dart';
import 'package:snack/naver_authentication/presentation/providers/naver_auth_providers.dart';
import 'package:snack/authentication/presentation/ui/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'domain/usecase/naver_fetch_user_info_usecase_impl.dart';
import 'domain/usecase/naver_login_usecase_impl.dart';
import 'domain/usecase/naver_request_user_token_usecase_impl.dart';
import 'infrastructure/data_sources/naver_auth_remote_data_source.dart';
import 'infrastructure/repository/naver_auth_repository.dart';
import 'infrastructure/repository/naver_auth_repository_impl.dart';
import 'package:snack/kakao_authentication/infrastructure/data_sources/kakao_auth_remote_data_source.dart';




class NaverAuthModule {
  static List<SingleChildWidget> provideNaverProviders() {
    dotenv.load();
    String baseServerUrl = dotenv.env['BASE_URL'] ?? '';

    return [
      // ✅ WebView 기반 네이버 로그인에서는 RemoteDataSource와 Provider만 필요
      Provider<NaverAuthRemoteDataSource>(
        create: (_) => NaverAuthRemoteDataSource(baseServerUrl),
      ),
      ChangeNotifierProvider<NaverAuthProvider>(
        create: (context) => NaverAuthProvider(
          remoteDataSource: context.read<NaverAuthRemoteDataSource>(),
        ),
      ),
    ];
  }
}




//
// class NaverAuthModule {
//   static List<SingleChildWidget> provideNaverProviders() {
//     dotenv.load();
//     String baseServerUrl = dotenv.env['BASE_URL'] ?? '';
//
//     return [
//       // // ✅ KakaoAuthRemoteDataSource 제공
//       // Provider<KakaoAuthRemoteDataSource>(
//       //   create: (_) => KakaoAuthRemoteDataSource(baseServerUrl),
//       // ),
//       Provider<NaverAuthRemoteDataSource>(
//         create: (_) => NaverAuthRemoteDataSource(baseServerUrl),
//       ),
//       // ProxyProvider<NaverAuthRemoteDataSource, NaverAuthRepositoryImpl>(
//       //   update: (_, remoteDataSource, __) => NaverAuthRepositoryImpl(remoteDataSource),
//       // ),
//       // ProxyProvider<NaverAuthRepositoryImpl, NaverLoginUseCaseImpl>(
//       //   update: (_, repository, __) => NaverLoginUseCaseImpl(repository),
//       // ),
//       // ProxyProvider<NaverAuthRepositoryImpl, NaverFetchUserInfoUseCaseImpl>(
//       //   update: (_, repository, __) => NaverFetchUserInfoUseCaseImpl(repository),
//       // ),
//       // ProxyProvider<NaverAuthRepositoryImpl, NaverRequestUserTokenUseCaseImpl>(
//       //   update: (_, repository, __) => NaverRequestUserTokenUseCaseImpl(repository),
//       // ),
//       // ChangeNotifierProvider<NaverAuthProvider>(
//       //   create: (context) => NaverAuthProvider(
//       //     loginUseCase: context.read<NaverLoginUseCaseImpl>(),
//       //     fetchUserInfoUseCase: context.read<NaverFetchUserInfoUseCaseImpl>(),
//       //     requestUserTokenUseCase: context.read<NaverRequestUserTokenUseCaseImpl>(),
//       //   ),
//       // ),
//     ];
//   }
// }



// 기존 코드
// class NaverAuthModule {
//   static Widget provideNaverProviders() {
//     dotenv.load();
//     String baseServerUrl = dotenv.env['BASE_URL'] ?? '';
//
//     return MultiProvider(
//       providers: [
//         Provider<NaverAuthRemoteDataSource>(
//             create: (_) => NaverAuthRemoteDataSource(baseServerUrl)
//         ),
//         ProxyProvider<NaverAuthRemoteDataSource, NaverAuthRepositoryImpl>(
//           update: (_, remoteDataSource, __) => NaverAuthRepositoryImpl(remoteDataSource),
//         ),
//         ProxyProvider<NaverAuthRepositoryImpl, NaverLoginUseCaseImpl>(
//           update: (_, repository, __) => NaverLoginUseCaseImpl(repository),
//         ),
//         ProxyProvider<NaverAuthRepositoryImpl, NaverFetchUserInfoUseCaseImpl>(
//           update: (_, repository, __) => NaverFetchUserInfoUseCaseImpl(repository),
//         ),
//         ProxyProvider<NaverAuthRepositoryImpl, NaverRequestUserTokenUseCaseImpl>(
//           update: (_, repository, __) => NaverRequestUserTokenUseCaseImpl(repository),
//         ),
//         ChangeNotifierProvider<NaverAuthProvider>(
//           create: (context) => NaverAuthProvider(
//             loginUseCase: context.read<NaverLoginUseCaseImpl>(),
//             fetchUserInfoUseCase: context.read<NaverFetchUserInfoUseCaseImpl>(),
//             requestUserTokenUseCase: context.read<NaverRequestUserTokenUseCaseImpl>(),
//           ),
//         ),
//       ],
//        // child: LoginPage()
//     );
//   }
// }