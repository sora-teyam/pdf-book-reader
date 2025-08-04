import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../screens/pdf_reader_screen.dart';
import '../generated/l10n.dart';
import '../utils/pdf_thumbnail_generator.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFReaderScreen(book: book),
            ),
          );
        },
        onLongPress: () => _showOptionsDialog(context, s),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // PDF иконка и индикатор прогресса
              Expanded(
                flex: 4, // Увеличили место под иконку
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.red[50]!,
                            Colors.red[100]!,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: FutureBuilder<String?>(
                        future: _getThumbnailPath(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            // Показываем миниатюру первой страницы
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(snapshot.data!),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildDefaultPdfIcon();
                                },
                              ),
                            );
                          } else {
                            // Показываем стандартную иконку PDF
                            return _buildDefaultPdfIcon();
                          }
                        },
                      ),
                    ),
                    
                    // Индикатор прогресса в углу
                    if (book.totalPages > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  value: book.readingProgress,
                                  strokeWidth: 3,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    _getProgressColor(book.readingProgress),
                                  ),
                                ),
                              ),
                              Text(
                                '${(book.readingProgress * 100).round()}',
                                style: const TextStyle(
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Информация о книге
              Expanded(
                flex: 3, // Увеличили место под текст
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Название книги
                    Text(
                      book.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Статистика чтения  
                    if (book.totalPages > 0) ...[
                      Flexible(
                        child: Row(
                          children: [
                            Icon(
                              Icons.menu_book,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                s.readingProgress(
                                  (book.readingProgress * 100).toStringAsFixed(0),
                                  book.currentPage,
                                  book.totalPages,
                                ),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      Flexible(
                        child: Row(
                          children: [
                            Icon(
                              Icons.new_releases_outlined,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                s.notStarted,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const Spacer(),
                    
                    // Дата добавления
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(book.addedDate),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[500],
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.3) return Colors.red;
    if (progress < 0.7) return Colors.orange;
    if (progress < 1.0) return Colors.blue;
    return Colors.green;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Сегодня';
    } else if (difference.inDays == 1) {
      return 'Вчера';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} дн. назад';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).round()} нед. назад';
    } else {
      return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year}';
    }
  }

  void _showOptionsDialog(BuildContext context, S s) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Заголовок
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red[600],
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (book.totalPages > 0)
                          Text(
                            s.readingProgress(
                              (book.readingProgress * 100).toStringAsFixed(0),
                              book.currentPage,
                              book.totalPages,
                            ),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const Divider(),
            
            // Опции
            ListTile(
              leading: const Icon(Icons.open_in_new),
              title: Text(s.openBook),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFReaderScreen(book: book),
                  ),
                );
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Переименовать'),
              onTap: () {
                Navigator.pop(context);
                _showRenameDialog(context);
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Изменить обложку'),
              onTap: () {
                Navigator.pop(context);
                _showCoverOptions(context);
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.share),
              title: Text(s.share),
              onTap: () {
                Navigator.pop(context);
                // Implement share functionality
              },
            ),
            
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Информация'),
              onTap: () {
                Navigator.pop(context);
                _showBookInfo(context, s);
              },
            ),
            
            const Divider(),
            
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: Text(
                s.delete,
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, s);
              },
            ),
            
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }

  void _showBookInfo(BuildContext context, S s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Информация о книге'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Название:', book.title),
            _buildInfoRow('Добавлена:', _formatFullDate(book.addedDate)),
            if (book.totalPages > 0) ...[
              _buildInfoRow('Страниц:', '${book.totalPages}'),
              _buildInfoRow('Текущая страница:', '${book.currentPage}'),
              _buildInfoRow('Прогресс:', '${(book.readingProgress * 100).toStringAsFixed(1)}%'),
            ],
            _buildInfoRow('Размер файла:', _getFileSize()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.ok),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatFullDate(DateTime date) {
    return '${date.day}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  Future<String?> _getThumbnailPath() async {
    // Сначала проверяем пользовательскую обложку
    if (book.customCoverPath != null && book.customCoverPath!.isNotEmpty) {
      final file = File(book.customCoverPath!);
      if (await file.exists()) {
        return book.customCoverPath;
      }
    }
    
    // Затем пытаемся сгенерировать или получить существующую обложку из PDF
    return await PDFThumbnailGenerator.generateThumbnail(book.filePath, book.id);
  }

  Widget _buildDefaultPdfIcon() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.picture_as_pdf,
          size: 48,
          color: Colors.red[600],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.red[600],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Text(
            'PDF',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  String _getFileSize() {
    return 'Неизвестно'; // Упрощенная версия пока
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: book.title);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Переименовать книгу'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Название книги',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                final bookProvider = Provider.of<BookProvider>(context, listen: false);
                bookProvider.updateBookTitle(book.id, controller.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Название изменено')),
                );
              }
            },
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  void _showCoverOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Изменить обложку'),
        content: const Text('Выберите новую обложку для книги'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _pickCustomCover(context);
            },
            child: const Text('Выбрать файл'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetToDefaultCover(context);
            },
            child: const Text('По умолчанию'),
          ),
        ],
      ),
    );
  }

  void _pickCustomCover(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        final bookProvider = Provider.of<BookProvider>(context, listen: false);
        await bookProvider.updateBookCover(book.id, result.files.single.path!);
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Обложка изменена')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $e')),
      );
    }
  }

  void _resetToDefaultCover(BuildContext context) async {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    await bookProvider.updateBookCover(book.id, null);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Обложка сброшена')),
    );
  }

  void _showDeleteConfirmation(BuildContext context, S s) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(s.deleteBookTitle),
        content: Text(s.deleteBookMessage(book.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(s.cancel),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final bookProvider = Provider.of<BookProvider>(context, listen: false);
              await bookProvider.removeBook(book.id);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(s.bookDeleted),
                  backgroundColor: Colors.green,
                ),
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