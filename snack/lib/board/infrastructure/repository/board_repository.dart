import 'package:snack/board/domain/entity/board.dart';
import 'package:snack/board/domain/usecases/list/response/board_list_response.dart';

abstract class BoardRepository {
  Future<BoardListResponse> listBoard(int page, int perPage);
  Future<Board> createBoard({
    required String userToken,
    required String title,
    required String content,
    String? imageUrl,
    required DateTime endTime,
    String? restaurant,
  });
}
