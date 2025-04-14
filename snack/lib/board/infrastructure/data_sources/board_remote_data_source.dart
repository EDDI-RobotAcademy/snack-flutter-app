import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:snack/board/domain/entity/board.dart';
import 'package:snack/board/domain/usecases/list/response/board_list_response.dart';

class BoardRemoteDataSource {
  final String baseUrl;

  BoardRemoteDataSource(this.baseUrl);

  Future<BoardListResponse> listBoard(int page, int perPage) async {
    final parsedUri =
    Uri.parse('$baseUrl/board/list?page=$page&perPage=$perPage');

    final boardListResponse = await http.get(parsedUri);

    if (boardListResponse.statusCode == 200) {
      final data = json.decode(boardListResponse.body);

      List<Board> boardList = (data['dataList'] as List)
          .map((data) =>
          Board(
            id: data['boardId'] ?? 0,
            title: data['title'],
            content: data['content'],
            imageUrl: data['image_url'] ?? '',
            author: data['author'],
            createdAt: DateTime.parse(data['created_at']),
            updatedAt: DateTime.parse(data['updated_at']),
            endTime: DateTime.parse(data['end_time']),
            status: data['status'],
            restaurant: data['restaurant'] ?? '',
          )
      )
          .toList();
      int totalItems = parseInt(data['totalItems']);
      int totalPages = parseInt(data['totalPages']);

      return BoardListResponse(
          boardList: boardList,
          totalItems: totalItems,
          totalPages: totalPages
      );
    } else {
      throw Exception('게시물 리스트 조회 실패');
    }
  }
  int parseInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return value ?? 0;
  }
}