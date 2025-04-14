import 'package:snack/board/board_module.dart';
import 'package:snack/board/presentation/providers/board_list_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/entity/board.dart';
import 'card_item.dart';

class BoardList extends StatelessWidget {
  final List<dynamic> boardList;

  BoardList({
    required this.boardList
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(boardList.length, (index) {
          final board = boardList[index];
          if (board == null) {
            return SizedBox(height: 20);
          }

          return CardItem(
              title: board.title,
              content: board.content,
              author: board.author,
              imageUrl: board.iamgeUrl,
              endTime: board.endTime,
              status: board.status,

          );
        })
    );
  }
}