import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';
import '../models/bookmark.dart';
import '../utils/pdf_thumbnail_generator.dart';
import 'settings_provider.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  List<Bookmark> _bookmarks = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  List<Bookmark> get bookmarks => _bookmarks;
  bool get isLoading => _isLoading;

  BookProvider() {
    loadBooks();
    loadBookmarks();
  }

  // Получить отсортированные книги
  List<Book> getSortedBooks(BookSortType sortType, bool ascending) {
    final sortedBooks = List<Book>.from(_books);
    
    switch (sortType) {
      case BookSortType.name:
        sortedBooks.sort((a, b) => a.title.compareTo(b.title));
        break;
      case BookSortType.dateAdded:
        sortedBooks.sort((a, b) => a.addedDate.compareTo(b.addedDate));
        break;
      case BookSortType.progress:
        sortedBooks.sort((a, b) => a.readingProgress.compareTo(b.readingProgress));
        break;
    }
    
    if (!ascending) {
      return sortedBooks.reversed.toList();
    }
    
    return sortedBooks;
  }

  // Получить недавние книги (последние 5)
  List<Book> getRecentBooks() {
    final recentBooks = List<Book>.from(_books);
    recentBooks.sort((a, b) => b.addedDate.compareTo(a.addedDate));
    return recentBooks.take(5).toList();
  }

  Future<void> loadBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = prefs.getStringList('books') ?? [];
      
      _books = booksJson.map((bookStr) {
        final bookData = jsonDecode(bookStr);
        return Book.fromJson(bookData);
      }).toList();
    } catch (e) {
      print('Error loading books: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> saveBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final booksJson = _books.map((book) => jsonEncode(book.toJson())).toList();
      await prefs.setStringList('books', booksJson);
    } catch (e) {
      print('Error saving books: $e');
    }
  }

  // Работа с закладками
  Future<void> loadBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = prefs.getStringList('bookmarks') ?? [];
      
      _bookmarks = bookmarksJson.map((bookmarkStr) {
        final bookmarkData = jsonDecode(bookmarkStr);
        return Bookmark.fromJson(bookmarkData);
      }).toList();
    } catch (e) {
      print('Error loading bookmarks: $e');
    }
    notifyListeners();
  }

  Future<void> saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final bookmarksJson = _bookmarks.map((bookmark) => jsonEncode(bookmark.toJson())).toList();
      await prefs.setStringList('bookmarks', bookmarksJson);
    } catch (e) {
      print('Error saving bookmarks: $e');
    }
  }

  Future<void> addBookmark(String bookId, int pageNumber, String title) async {
    final bookmark = Bookmark(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      pageNumber: pageNumber,
      title: title,
      createdDate: DateTime.now(),
    );

    _bookmarks.add(bookmark);
    await saveBookmarks();
    notifyListeners();
  }

  Future<void> removeBookmark(String bookmarkId) async {
    _bookmarks.removeWhere((bookmark) => bookmark.id == bookmarkId);
    await saveBookmarks();
    notifyListeners();
  }

  List<Bookmark> getBookmarksForBook(String bookId) {
    return _bookmarks.where((bookmark) => bookmark.bookId == bookId).toList()
      ..sort((a, b) => a.pageNumber.compareTo(b.pageNumber));
  }

  bool hasBookmarkForPage(String bookId, int pageNumber) {
    return _bookmarks.any((bookmark) => 
      bookmark.bookId == bookId && bookmark.pageNumber == pageNumber);
  }

  Bookmark? getBookmarkForPage(String bookId, int pageNumber) {
    try {
      return _bookmarks.firstWhere((bookmark) => 
        bookmark.bookId == bookId && bookmark.pageNumber == pageNumber);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateBookCover(String bookId, String? coverPath) async {
    try {
      final bookIndex = _books.indexWhere((book) => book.id == bookId);
      if (bookIndex != -1) {
        _books[bookIndex].customCoverPath = coverPath;
        await saveBooks();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating book cover: $e');
    }
  }

  Future<void> updateBookTitle(String bookId, String newTitle) async {
    try {
      final bookIndex = _books.indexWhere((book) => book.id == bookId);
      if (bookIndex != -1) {
        _books[bookIndex].title = newTitle;
        await saveBooks();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating book title: $e');
    }
  }

  Future<bool> addBook(String filePath, String fileName) async {
    try {
      // Копируем файл в папку приложения
      final appDir = await getApplicationDocumentsDirectory();
      final booksDir = Directory('${appDir.path}/books');
      if (!await booksDir.exists()) {
        await booksDir.create(recursive: true);
      }

      final originalFile = File(filePath);
      final newPath = '${booksDir.path}/$fileName';
      await originalFile.copy(newPath);

      // Создаем объект книги
      final book = Book(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: fileName.replaceAll('.pdf', ''),
        filePath: newPath,
        addedDate: DateTime.now(),
      );

      _books.add(book);
      await saveBooks();
      
      // Генерируем обложку в фоне (пока отключено)
      // PDFThumbnailGenerator.generateThumbnail(newPath, book.id).then((_) {
      //   notifyListeners();
      // });
      
      notifyListeners();
      return true;
    } catch (e) {
      print('Error adding book: $e');
      return false;
    }
  }

  Future<void> removeBook(String bookId) async {
    try {
      final bookIndex = _books.indexWhere((book) => book.id == bookId);
      if (bookIndex != -1) {
        final book = _books[bookIndex];
        
        // Удаляем файл
        final file = File(book.filePath);
        if (await file.exists()) {
          await file.delete();
        }

        // Удаляем обложку
        await PDFThumbnailGenerator.deleteThumbnail(bookId);

        // Удаляем закладки книги
        _bookmarks.removeWhere((bookmark) => bookmark.bookId == bookId);
        await saveBookmarks();

        _books.removeAt(bookIndex);
        await saveBooks();
        notifyListeners();
      }
    } catch (e) {
      print('Error removing book: $e');
    }
  }

  Future<void> updateBookProgress(String bookId, int currentPage, int totalPages) async {
    try {
      final bookIndex = _books.indexWhere((book) => book.id == bookId);
      if (bookIndex != -1) {
        _books[bookIndex].currentPage = currentPage;
        _books[bookIndex].totalPages = totalPages;
        await saveBooks();
        notifyListeners();
      }
    } catch (e) {
      print('Error updating book progress: $e');
    }
  }

  Book? getBookById(String bookId) {
    try {
      return _books.firstWhere((book) => book.id == bookId);
    } catch (e) {
      return null;
    }
  }

  // Статистика
  int get totalBooks => _books.length;
  int get completedBooks => _books.where((book) => book.readingProgress >= 1.0).length;
  int get inProgressBooks => _books.where((book) => book.readingProgress > 0 && book.readingProgress < 1.0).length;
  double get averageProgress {
    if (_books.isEmpty) return 0.0;
    final totalProgress = _books.fold<double>(0.0, (sum, book) => sum + book.readingProgress);
    return totalProgress / _books.length;
  }
}