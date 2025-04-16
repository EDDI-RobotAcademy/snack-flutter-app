import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snack/board/domain/entity/board.dart';
import 'package:snack/board/domain/usecases/list/response/board_list_response.dart';
import 'package:snack/board/infrastructure/data_sources/board_remote_data_source.dart';
import 'package:snack/board/infrastructure/repository/board_repository.dart';

class BoardRepositoryImpl implements BoardRepository {
  final BoardRemoteDataSource remoteDataSource;

  BoardRepositoryImpl(this.remoteDataSource);

  @override
  Future<BoardListResponse> listBoard(int page, int perPage) {
    return remoteDataSource.listBoard(page, perPage);
  }

  @override
  Future<Board> createBoard({
    required String title,
    required String content,
    required String userToken,
    required DateTime endTime,
    String? imageUrl,
    String? restaurant,
  }) {
    return remoteDataSource.createBoard(
      title: title,
      content: content,
      userToken: userToken,
      endTime: endTime,
      imageUrl: imageUrl,
      restaurant: restaurant,
    );
  }
}
