class Board {
  final int id;
  final String title;
  final String content;
  final String? imageUrl;
  final String author;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime endTime;
  final String status;
  final String? restaurant;

  Board({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.author,
    required this.createdAt,
    required this.updatedAt,
    required this.endTime,
    required this.status,
    this.restaurant,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    try {
      print('JSON 변환 시작: $json');

      return Board(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        imageUrl: json['image_url'],
        author: json['author'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        endTime: DateTime.parse(json['end_time']),
        status: json['status'],
        restaurant: json['restaurant'],
      );
    } catch (e) {
      print('JSON 파싱 중 오류: $json, Error: $e');
      rethrow;
    }
  }
}
