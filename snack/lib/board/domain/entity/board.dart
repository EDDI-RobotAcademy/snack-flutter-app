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
        id: json['board_id'] ?? json['id'],
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        imageUrl: json['image_url'] as String?,
        author: json['author_nickname'] ?? json['author'] ?? '익명',
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : DateTime.now(),
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : DateTime.now(),
        endTime: json['end_time'] != null
            ? DateTime.parse(json['end_time'])
            : DateTime.now().add(Duration(hours: 1)),
        status: json['status'] ?? 'ongoing',
        restaurant: json['restaurant'] as String?,
      );
    } catch (e) {
      print('❌ JSON 파싱 중 오류: $json\nError: $e');
      rethrow;
    }
  }
}