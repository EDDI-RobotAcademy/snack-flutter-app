import 'package:snack/board/domain/entity/board.dart';
import 'package:snack/board/domain/usecases/list/response/board_list_response.dart';
import 'package:snack/board/infrastructure/data_sources/board_remote_data_source.dart';
import 'package:snack/board/infrastructure/repository/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  final BoardRemoteDataSource boardRemoteDataSource;

  BoardRepositoryImpl(this.boardRemoteDataSource);

  @override
  Future<BoardListResponse> listBoard(int page, int perPage) async {
    final boardListResponse =
    await boardRemoteDataSource.listBoard(page, perPage);

    return boardListResponse;
  }
}