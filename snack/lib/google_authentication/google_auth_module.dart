import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'domain/usecase/google_login_usecase.dart';
import 'domain/usecase/google_login_usecase_impl.dart';
import 'domain/usecase/google_logout_usecase.dart';
import 'domain/usecase/google_logout_usecase_impl.dart';
import 'domain/usecase/google_fetch_user_info_usecase.dart';
import 'domain/usecase/google_fetch_user_info_usecase_impl.dart';
import 'domain/usecase/google_request_user_token_usecase.dart';
import 'domain/usecase/google_request_user_token_usecase_impl.dart';

import 'infrastructure/data_sources/google_auth_remote_data_source.dart';
import 'infrastructure/repository/google_auth_repository.dart';
import 'infrastructure/repository/google_auth_repository_impl.dart';

import 'presentation/providers/google_auth_providers.dart';

class GoogleAuthModule {
  static List<SingleChildWidget> provideGoogleProviders() {
    dotenv.load();
    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    final remoteDataSource = GoogleAuthRemoteDataSource(baseUrl);
    final repository = GoogleAuthRepositoryImpl(remoteDataSource);

    final loginUseCase = GoogleLoginUseCaseImpl(repository);
    final logoutUseCase = GoogleLogoutUseCaseImpl(repository);
    final fetchUserInfoUseCase = GoogleFetchUserInfoUseCaseImpl(repository);
    final requestUserTokenUseCase = GoogleRequestUserTokenUseCaseImpl(repository);

    return [
      Provider<GoogleAuthRemoteDataSource>(create: (_) => remoteDataSource),
      Provider<GoogleAuthRepository>(create: (_) => repository),
      Provider<GoogleLoginUseCase>(create: (_) => loginUseCase),
      Provider<GoogleLogoutUseCase>(create: (_) => logoutUseCase),
      Provider<GoogleFetchUserInfoUseCase>(create: (_) => fetchUserInfoUseCase),
      Provider<GoogleRequestUserTokenUseCase>(create: (_) => requestUserTokenUseCase),
      ChangeNotifierProvider<GoogleAuthProvider>(
        create: (context) => GoogleAuthProvider(
          loginUseCase: context.read<GoogleLoginUseCase>(),
          logoutUseCase: context.read<GoogleLogoutUseCase>(),
          fetchUserInfoUseCase: context.read<GoogleFetchUserInfoUseCase>(),
          requestUserTokenUseCase: context.read<GoogleRequestUserTokenUseCase>(),
        ),
      ),
    ];
  }
}
