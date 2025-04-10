import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

import 'package:snack/naver_authentication/presentation/providers/naver_auth_providers.dart';
import 'package:snack/authentication/presentation/ui/login_page.dart';
import 'package:snack/naver_authentication/domain/usecase/naver_fetch_user_info_usecase_impl.dart';
import 'package:snack/naver_authentication/domain/usecase/naver_login_usecase_impl.dart';
import 'package:snack/naver_authentication/domain/usecase/naver_request_user_token_usecase_impl.dart';
import 'package:snack/naver_authentication/infrastructure/data_sources/naver_auth_remote_data_source.dart';
import 'package:snack/naver_authentication/infrastructure/repository/naver_auth_repository_impl.dart';

class NaverAuthModule {
  static List<SingleChildWidget> provideNaverProviders() {
    dotenv.load();
    String baseServerUrl = dotenv.env['BASE_URL'] ?? '';

    return [
      Provider<NaverAuthRemoteDataSource>(
        create: (_) => NaverAuthRemoteDataSource(baseServerUrl),
      ),
      ProxyProvider<NaverAuthRemoteDataSource, NaverAuthRepositoryImpl>(
        update: (_, remoteDataSource, __) => NaverAuthRepositoryImpl(remoteDataSource.baseUrl),
      ),
      ProxyProvider<NaverAuthRepositoryImpl, NaverLoginUseCaseImpl>(
        update: (_, repository, __) => NaverLoginUseCaseImpl(repository),
      ),
      ProxyProvider<NaverAuthRepositoryImpl, NaverFetchUserInfoUseCaseImpl>(
        update: (_, repository, __) => NaverFetchUserInfoUseCaseImpl(repository),
      ),
      ProxyProvider<NaverAuthRepositoryImpl, NaverRequestUserTokenUseCaseImpl>(
        update: (_, repository, __) => NaverRequestUserTokenUseCaseImpl(repository),
      ),
      ChangeNotifierProvider<NaverAuthProvider>(
        create: (context) => NaverAuthProvider(
          loginUseCase: context.read<NaverLoginUseCaseImpl>(),
          fetchUserInfoUseCase: context.read<NaverFetchUserInfoUseCaseImpl>(),
          requestUserTokenUseCase: context.read<NaverRequestUserTokenUseCaseImpl>(),
        ),
      ),
    ];
  }
}
