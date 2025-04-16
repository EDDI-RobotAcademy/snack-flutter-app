import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:snack/board/presentation/providers/board_list_provider.dart';
import 'package:snack/board/presentation/ui/board_list_page.dart';
import 'package:snack/board/presentation/providers/board_create_provider.dart';
import 'package:snack/board/presentation/ui/board_create_page.dart';

import 'package:snack/board/domain/usecases/list/list_board_use_case_impl.dart';
import 'package:snack/board/domain/usecases/create/create_board_use_case_impl.dart';
import 'package:snack/board/infrastructure/repository/board_repository_impl.dart';
import 'package:snack/board/infrastructure/data_sources/board_remote_data_source.dart';


class BoardModule {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? '';

  static final boardRemoteDataSource = BoardRemoteDataSource(baseUrl);
  static final boardRepository = BoardRepositoryImpl(boardRemoteDataSource);

  static final listBoardUseCase = ListBoardUseCaseImpl(boardRepository);
  static final createBoardUseCase = CreateBoardUseCaseImpl(boardRepository);

  static List<SingleChildWidget> provideCommonProviders () {
    return [
      Provider(create: (_) => listBoardUseCase),
      Provider(create: (_) => createBoardUseCase),
    ];
  }

  static List<SingleChildWidget> provideListBoardProviders() {
    return [
      ...provideCommonProviders(),
      ChangeNotifierProvider(
        create: (_) => BoardListProvider(listBoardUseCase: listBoardUseCase),
      ),
    ];
  }

  static List<SingleChildWidget> provideCreateBoardProviders() {
    return [
      ...provideCommonProviders(),
      ChangeNotifierProvider(
        create: (_) => BoardCreateProvider(createBoardUseCase),
      ),
    ];
  }

  static Widget provideBoardListPage({required String loginType}) {
    return MultiProvider(
      providers: [
        ...provideListBoardProviders(),
      ],
      child: BoardListPage(loginType: loginType),
    );
  }

  static Widget provideBoardCreatePage({required String loginType}) {
    return MultiProvider(
      providers: [
        ...provideCreateBoardProviders(),
      ],
      child: BoardCreatePage(loginType: loginType),
    );
  }
}