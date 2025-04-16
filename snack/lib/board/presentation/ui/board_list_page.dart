import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snack/common_ui/custom_bottom_nav_bar.dart';
import 'package:snack/board/presentation/providers/board_list_provider.dart';
import 'package:snack/board/presentation/ui/component/card_item.dart';
import 'package:snack/board/board_module.dart';

class BoardListPage extends StatefulWidget {
  final String loginType;
  const BoardListPage({super.key, required this.loginType});

  @override
  State<BoardListPage> createState() => _BoardListPageState();
}

class _BoardListPageState extends State<BoardListPage> {
  late ScrollController _scrollController;
  final int _limit = 10;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<BoardListProvider>(context, listen: false);
      provider.listBoard(1, _limit);
    });

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      final provider = Provider.of<BoardListProvider>(context, listen: false);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !provider.isLoading &&
          provider.currentPage < provider.totalPages) {
        provider.listBoard(provider.currentPage + 1, _limit, append: true);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BoardListProvider>(context);
    final boards = provider.boardList;

    return Scaffold(
      appBar: AppBar(title: const Text('모임 리스트')),
      body: Stack(
        children: [
          Consumer<BoardListProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading && provider.boardList.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.message.isNotEmpty) {
                return Center(child: Text(provider.message));
              }

              if (boards.isEmpty) {
                return const Center(child: Text('등록된 게시글이 없습니다.'));
              }

              return ListView.builder(
                controller: _scrollController,
                itemCount: boards.length + 1,
                itemBuilder: (context, index) {
                  if (index == boards.length) {
                    return provider.isLoading
                        ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    )
                        : const SizedBox.shrink();
                  }

                  final board = boards[index];
                  return CardItem(board: board);
                },
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BoardModule.provideBoardCreatePage(
                        loginType: widget.loginType,
                      ),
                    ),
                  );
                  Provider.of<BoardListProvider>(context, listen: false)
                      .listBoard(1, _limit);
                },
                icon: const Icon(Icons.edit, color: Colors.white),
                label: const Text('모임 등록',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(loginType: widget.loginType),
    );
  }
}
