import 'package:snack/board/presentation/providers/board_list_provider.dart';
import 'package:flutter/cupertino.dart';

import '../../../../common_ui/pagination.dart';
import 'board_list.dart';

class PageContent extends StatelessWidget {
  final BoardListProvider boardListProvider;
  final Function(int) onPageChanged;

  PageContent({
    required this.boardListProvider,
    required this.onPageChanged
  });

  @override
  Widget build(BuildContext context) {
    List<dynamic> boardList = List.from(boardListProvider.boardList);
    while (boardList.length < 6) {
      boardList.add(null);
    }

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BoardList(boardList: boardList),
            ),
          ),
        ),

        if (boardListProvider.boardList.isNotEmpty)
          Pagination(
            currentPage: boardListProvider.currentPage,
            totalPages: boardListProvider.totalPages,
            onPageChanged: onPageChanged,
          )
      ],
    );
  }
}