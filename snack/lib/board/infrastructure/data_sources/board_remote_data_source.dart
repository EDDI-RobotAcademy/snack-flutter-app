import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:snack/board/domain/entity/board.dart';
import 'package:snack/board/domain/usecases/list/response/board_list_response.dart';

class BoardRemoteDataSource {
  final String baseUrl;

  BoardRemoteDataSource(this.baseUrl);

  Future<BoardListResponse> listBoard(int page, int perPage) async {
    final uri = Uri.parse('$baseUrl/board/all/?page=$page&per_page=$perPage');
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Board> boardList = (data['boards'] as List)
          .map((item) => Board.fromJson(item))
          .toList();

      return BoardListResponse(
        boardList: boardList,
        totalItems: data['boards'].length,
        totalPages: data['total_pages'],
      );
    } else {
      throw Exception('게시글 목록을 불러오지 못했습니다.');
    }
  }

  // ✅ 게시글 생성 API 요청
  Future<Board> createBoard({
    required String title,
    required String content,
    required String userToken,
    required DateTime endTime,
    String? imageUrl,
    String? restaurant,
  }) async {
    final uri = Uri.parse('$baseUrl/board/create/');
    final body = json.encode({
      'title': title,
      'content': content,
      'image_url': imageUrl ?? '',
      'end_time': endTime.toIso8601String(),
      'restaurant': restaurant,
    });

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $userToken',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Board.fromJson(data);
    } else {
      throw Exception('게시글 등록 실패: ${response.body}');
    }
  }
}
