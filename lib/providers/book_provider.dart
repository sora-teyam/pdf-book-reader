import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  bool _isLoading = false;

  List<Book> get books => _books;
  bool get isLoading => _isLoading;

  BookProvider() {
    loadBooks();
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
}