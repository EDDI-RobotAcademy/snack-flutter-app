import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:snack/common_ui/pagination.dart';
import 'package:snack/common_ui/custom_bottom_nav_bar.dart';
import 'package:snack/board/presentation/providers/board_list_provider.dart';
import 'package:snack/board/presentation/ui/component/card_item.dart';
import 'package:snack/board/presentation/ui/component/board_list.dart';
import 'package:snack/board/presentation/ui/component/page_content.dart';
import 'package:snack/board/board_module.dart';


class BoardListPage extends StatelessWidget {
  final String loginType;
  const BoardListPage({super.key, required this.loginType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Board List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // 로딩 다시 시작하는 코드 구현
            },
          )
        ],
      ),
      body: Consumer<BoardListProvider>(
        builder: (context, provider, _) {
          // 로딩 중일 때
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 메시지가 있을 경우
          if (provider.message.isNotEmpty) {
            return Center(child: Text(provider.message));
          }

          // 게시글이 없을 때
          if (provider.boardList.isEmpty) {
            return const Center(child: Text('등록된 게시글이 없습니다.'));
          }

          // 게시글 목록이 있을 때
          return ListView.builder(
            itemCount: provider.boardList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(provider.boardList[index].title),
                subtitle: Text(provider.boardList[index].author),
                onTap: () {
                  // 게시글 상세 페이지로 이동
                },
              );
            },
          );
        },
      ),
      // 하단 네비게이션 바 추가
      bottomNavigationBar: CustomBottomNavBar(loginType: loginType),
    );
  }
}
