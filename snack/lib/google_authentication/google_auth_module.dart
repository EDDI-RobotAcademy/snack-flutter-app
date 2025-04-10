import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'infrastructure/data_sources/google_auth_remote_data_source.dart';
import 'infrastructure/repository/google_auth_repository.dart';
import 'infrastructure/repository/google_auth_repository_impl.dart';

import 'domain/usecase/google_login_usecase.dart';
import 'domain/usecase/google_login_usecase_impl.dart';
import 'domain/usecase/fetch_user_info_usecase.dart';
import 'domain/usecase/fetch_user_info_usecase_impl.dart';
import 'domain/usecase/request_user_token_usecase.dart';
import 'domain/usecase/request_user_token_usecase_impl.dart';

import 'presentation/providers/google_auth_providers.dart';

class GoogleAuthModule {
  static List<SingleChildWidget> provideGoogleProviders() {
    dotenv.load();
    final baseUrl = dotenv.env['BASE_URL'] ?? '';

    final remoteDataSource = GoogleAuthRemoteDataSource(baseUrl);
    final repository = GoogleAuthRepositoryImpl(remoteDataSource);

    final loginUseCase = GoogleLoginUseCaseImpl(repository);
    final fetchUserInfoUseCase = FetchGoogleUserInfoUseCaseImpl();
    final requestUserTokenUseCase = RequestGoogleUserTokenUseCaseImpl(remoteDataSource);

    return [
      Provider<GoogleAuthRemoteDataSource>(create: (_) => remoteDataSource),
      Provider<GoogleAuthRepository>(create: (_) => repository),
      Provider<GoogleLoginUseCase>(create: (_) => loginUseCase),
      Provider<FetchGoogleUserInfoUseCase>(create: (_) => fetchUserInfoUseCase),
      Provider<RequestGoogleUserTokenUseCase>(create: (_) => requestUserTokenUseCase),
      ChangeNotifierProvider<GoogleAuthProvider>(
        create: (context) => GoogleAuthProvider(
          loginUseCase: context.read<GoogleLoginUseCase>(),
          fetchUserInfoUseCase: context.read<FetchGoogleUserInfoUseCase>(),
          requestUserTokenUseCase: context.read<RequestGoogleUserTokenUseCase>(),
        ),
      ),
    ];
  }
}
