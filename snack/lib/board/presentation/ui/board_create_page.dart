import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:snack/board/presentation/providers/board_create_provider.dart';
import 'package:snack/board/domain/entity/board.dart';

class BoardCreatePage extends StatefulWidget {
  final String loginType;
  const BoardCreatePage({super.key, required this.loginType});

  @override
  State<BoardCreatePage> createState() => _BoardCreatePageState();
}

class _BoardCreatePageState extends State<BoardCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _restaurantController = TextEditingController();
  final _imageUrlController = TextEditingController();

  DateTime? _endTime;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BoardCreateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('게시글 작성')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (value) => value!.isEmpty ? '제목을 입력하세요' : null,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '본문'),
                maxLines: 5,
                validator: (value) => value!.isEmpty ? '내용을 입력하세요' : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration:
                const InputDecoration(labelText: '썸네일 이미지 URL (선택)'),
              ),
              TextFormField(
                controller: _restaurantController,
                decoration: const InputDecoration(labelText: '식당 (선택)'),
              ),
              const SizedBox(height: 16),
              const Text('모집 마감일시'),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );

                  if (picked != null) {
                    setState(() {
                      _endTime = picked;
                    });
                  }
                },
                child: Text(_endTime == null
                    ? '날짜 선택'
                    : DateFormat('yyyy-MM-dd').format(_endTime!)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _endTime != null) {
                    final userToken =
                        await storage.read(key: 'userToken') ?? '';
                    if (userToken.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('유저 토큰이 없습니다.')),
                      );
                      return;
                    }

                    final Board? board = await provider.create(
                      userToken: userToken,
                      title: _titleController.text,
                      content: _contentController.text,
                      imageUrl: _imageUrlController.text.isEmpty
                          ? null
                          : _imageUrlController.text,
                      restaurant: _restaurantController.text.isEmpty
                          ? null
                          : _restaurantController.text,
                      endTime: _endTime!,
                    );

                    if (!context.mounted) return;

                    if (board != null) {
                      Navigator.pop(context, board); // 생성된 게시글 전달
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('게시글 생성에 실패했습니다.')),
                      );
                    }
                  }
                },
                child: const Text('등록'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
