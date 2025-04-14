import 'package:snack/common_ui/page_button.dart';
import 'package:flutter/cupertino.dart';

class Pagination extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChanged;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentPage > 1)
            PageButton(
              label: '이전',
              page: currentPage - 1,
              isCurrentPage: false,
              onTap: () => onPageChanged(currentPage - 1),
            ),
          ...List.generate(totalPages, (index) {
            int pageNum = index + 1;
            return PageButton(
              label: '$pageNum',
              page: pageNum,
              isCurrentPage: pageNum == currentPage,
              onTap: () => onPageChanged(pageNum),
            );
          }),
          if (currentPage < totalPages)
            PageButton(
              label: '다음',
              page: currentPage + 1,
              isCurrentPage: false,
              onTap: () => onPageChanged(currentPage + 1),
            )
        ],
      )
    );
  }
}