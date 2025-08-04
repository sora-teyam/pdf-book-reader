import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bookmark.dart';
import '../providers/book_provider.dart';
import '../generated/l10n.dart';

class BookmarksBottomSheet extends StatelessWidget {
  final String bookId;
  final Function(Bookmark) onBookmarkTap;

  const BookmarksBottomSheet({
    Key? key,
    required this.bookId,
    required this.onBookmarkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    return Consumer<BookProvider>(
      builder: (context, bookProvider, child) {
        final bookmarks = bookProvider.getBookmarksForBook(bookId);
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Заголовок
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.bookmarks,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      s.bookmarks,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${bookmarks.length}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Список закладок
              if (bookmarks.isEmpty)
                _buildEmptyState(s)
              else
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final bookmark = bookmarks[index];
                      return _buildBookmarkTile(
                        context,
                        bookmark,
                        bookProvider,
                        s,
                      );
                    },
                  ),
                ),
              
              // Отступ снизу для безопасной зоны
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(S s) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.bookmark_border,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            s.noBookmarks,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Нажмите на иконку закладки в PDF для добавления',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBookmarkTile(
    BuildContext context,
    Bookmark bookmark,
    BookProvider bookProvider,
    S s,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.bookmark,
            color: Theme.of(context).primaryColor,
            size: 20,
          ),
        ),
        title: Text(
          bookmark.title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          _formatDate(bookmark.createdDate),
          style: TextStyle(
            color: Theme.of(context).textTheme.bodySmall?.color,
            fontSize: 12,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${bookmark.pageNumber}',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  _showDeleteConfirmation(context, bookmark, bookProvider, s);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      const Icon(Icons.delete, color: Colors.red),
                      const SizedBox(width: 8),
                      Text(s.delete),
                    ],
                  ),
                ),
              ],
              child: const Icon(Icons.more_vert),
            ),
          ],
        ),
        onTap: () => onBookmarkTap(bookmark),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Сегодня ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Вчера ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    Bookmark bookmark,
    BookProvider bookProvider,
    S s,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.removeBookmark),
        content: Text('Удалить закладку "${bookmark.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await bookProvider.removeBookmark(bookmark.id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(s.bookmarkRemoved)),
              );
            },
            child: Text(
              s.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}