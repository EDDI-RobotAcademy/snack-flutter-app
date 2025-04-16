import 'package:snack/board/domain/entity/board.dart';

abstract class CreateBoardUseCase {
  Future<Board> execute({
    required String title,
    required String content,
    required String userToken,
    required DateTime endTime,
    String? imageUrl,
    String? restaurant,
  });
}

