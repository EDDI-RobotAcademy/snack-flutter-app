import 'package:provider/single_child_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'package:snack/kakao_authentication/presentation/providers/kakao_auth_providers.dart';
import 'package:snack/kakao_authentication/domain/usecase/fetch_user_info_usecase_impl.dart';
import 'package:snack/kakao_authentication/domain/usecase/login_usecase_impl.dart';
import 'package:snack/kakao_authentication/domain/usecase/request_user_token_usecase_impl.dart';
import 'package:snack/kakao_authentication/infrastructure/data_sources/kakao_auth_remote_data_source.dart';
import 'package:snack/kakao_authentication/infrastructure/repository/kakao_auth_repository.dart';
import 'package:snack/kakao_authentication/infrastructure/repository/kakao_auth_repository_impl.dart';



class KakaoAuthModule {
  static List<SingleChildWidget> provideKakaoProviders() {
    dotenv.load();
    String baseServerUrl = dotenv.env['BASE_URL'] ?? '';

    return [
      Provider<KakaoAuthRemoteDataSource>(
          create: (_) => KakaoAuthRemoteDataSource(baseServerUrl)
      ),
      ProxyProvider<KakaoAuthRemoteDataSource, KakaoAuthRepository>(
        update: (_, remoteDataSource, __) => KakaoAuthRepositoryImpl(remoteDataSource),
      ),
      ProxyProvider<KakaoAuthRepository, LoginUseCaseImpl>(
        update: (_, repository, __) => LoginUseCaseImpl(repository),
      ),
      ChangeNotifierProvider<KakaoAuthProvider>(
        create: (context) => KakaoAuthProvider(
          loginUseCase: context.read<LoginUseCaseImpl>(),
          fetchUserInfoUseCase: context.read<FetchUserInfoUseCaseImpl>(),
          requestUserTokenUseCase: context.read<RequestUserTokenUseCaseImpl>(),
        ),
      ),
    ];
  }
}




