import 'package:flutter/material.dart';
import 'package:snack/board/domain/entity/board.dart';

class CardItem extends StatelessWidget {
  final Board board;
  const CardItem({super.key, required this.board});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 썸네일 이미지 or 회색 박스
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: board.imageUrl != null && board.imageUrl!.isNotEmpty
                    ? null
                    : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
                image: board.imageUrl != null && board.imageUrl!.isNotEmpty
                    ? DecorationImage(
                  image: NetworkImage(board.imageUrl!),
                  fit: BoxFit.cover,
                )
                    : null,
              ),
              child: board.imageUrl == null || board.imageUrl!.isEmpty
                  ? const Center(
                child: Text(
                  "IMAGE",
                  style: TextStyle(
                    color: Colors.black45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
                  : null,
            ),
            const SizedBox(width: 16),

            // 오른쪽 텍스트 정보
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.schedule, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "마감일: ${board.endTime.toLocal()}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.person, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "작성자: ${board.author}",
                        style: const TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
