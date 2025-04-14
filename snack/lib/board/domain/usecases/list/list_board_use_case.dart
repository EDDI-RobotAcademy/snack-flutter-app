import 'package:snack/board/domain/usecases/list/response/board_list_response.dart';

abstract class ListBoardUseCase {
  Future<BoardListResponse> call(int page, int perPage);
}
