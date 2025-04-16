import 'package:snack/board/domain/entity/board.dart';
import 'package:snack/board/infrastructure/repository/board_repository.dart';
import 'package:snack/board/domain/usecases/create/create_board_use_case.dart';

class CreateBoardUseCaseImpl implements CreateBoardUseCase {
  final BoardRepository repository;

  CreateBoardUseCaseImpl(this.repository);

  @override
  Future<Board> execute({
    required String title,
    required String content,
    required String userToken,
    required DateTime endTime,
    String? imageUrl,
    String? restaurant,
  }) {
    return repository.createBoard(
      title: title,
      content: content,
      userToken: userToken,
      endTime: endTime,
      imageUrl: imageUrl,
      restaurant: restaurant,
    );
  }
}