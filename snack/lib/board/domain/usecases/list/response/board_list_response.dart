import 'package:snack/board/domain/entity/board.dart';

class BoardListResponse {
  final List<Board> boardList;
  final int totalItems;
  final int totalPages;

  BoardListResponse({
    required this.boardList,
    required this.totalItems,
    required this.totalPages
  });
}