import 'package:flutter/material.dart';
import 'package:snack/board/domain/entity/board.dart';
import 'package:intl/intl.dart';

class CardItem extends StatelessWidget {
  final Board board;

  const CardItem({Key? key, required this.board}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isClosed = board.status == 'closed' || board.endTime.isBefore(DateTime.now());
    final formattedDeadline = DateFormat('yyyy-MM-dd HH:mm').format(board.endTime.toLocal());

    return Opacity(
      opacity: isClosed ? 0.4 : 1.0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                board.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('작성자: ${board.author}'),
              Text('모집상태: ${board.status == 'closed' || board.endTime.isBefore(DateTime.now()) ? '모집완료' : '모집중'}'),
              Text('마감일: $formattedDeadline'),
            ],
          ),
        ),
      ),
    );
  }
}
