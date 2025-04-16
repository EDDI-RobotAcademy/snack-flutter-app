import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snack/board/domain/usecases/create/create_board_use_case.dart';
import 'package:snack/board/domain/entity/board.dart';

class BoardCreateProvider with ChangeNotifier {
  final CreateBoardUseCase createBoardUseCase;

  BoardCreateProvider(this.createBoardUseCase);

  bool isLoading = false;
  String message = '';

  Future<Board?> create({
    required String userToken,
    required String title,
    required String content,
    String? imageUrl,
    required DateTime endTime,
    String? restaurant,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      final board = await createBoardUseCase.execute(
        userToken: userToken,
        title: title,
        content: content,
        imageUrl: imageUrl,
        endTime: endTime,
        restaurant: restaurant,
      );

      return board;
    } catch (e) {
      message = '게시글 생성 실패: $e';
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
