import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';

class PDFReaderScreen extends StatefulWidget {
  final Book book;

  const PDFReaderScreen({Key? key, required this.book}) : super(key: key);

  @override
  _PDFReaderScreenState createState() => _PDFReaderScreenState();
}

class _PDFReaderScreenState extends State<PDFReaderScreen> {
  PDFViewController? controller;
  int currentPage = 1;
  int totalPages = 0;
  bool isReady = false;

  @override
  void initState() {
    super.initState();
    currentPage = widget.book.currentPage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.book.title,
          overflow: TextOverflow.ellipsis,
        ),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        actions: [
          if (isReady)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '$currentPage / $totalPages',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          if (File(widget.book.filePath).existsSync())
            PDFView(
              filePath: widget.book.filePath,
              enableSwipe: true,
              swipeHorizontal: true,
              autoSpacing: false,
              pageFling: false,
              pageSnap: true,
              defaultPage: currentPage - 1,
              fitPolicy: FitPolicy.BOTH,
              preventLinkNavigation: false,
              onRender: (pages) {
                setState(() {
                  totalPages = pages!;
                  isReady = true;
                });
                _updateProgress();
              },
              onError: (error) {
                print('PDF Error: $error');
                _showErrorDialog();
              },
              onPageError: (page, error) {
                print('Page $page Error: $error');
              },
              onViewCreated: (PDFViewController pdfViewController) {
                controller = pdfViewController;
              },
              onLinkHandler: (String? uri) {
                print('Link: $uri');
              },
              onPageChanged: (int? page, int? total) {
                setState(() {
                  currentPage = (page ?? 0) + 1;
                  totalPages = total ?? 0;
                });
                _updateProgress();
              },
            )
          else
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 100,
                    color: Colors.red[300],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Файл не найден',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.red[600],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'PDF файл был удален или перемещен',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          if (!isReady && File(widget.book.filePath).existsSync())
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Загрузка PDF...'),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: isReady
          ? Container(
              height: 60,
              color: Colors.grey[100],
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: currentPage > 1 ? _previousPage : null,
                    icon: Icon(Icons.chevron_left),
                    iconSize: 32,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LinearProgressIndicator(
                          value: totalPages > 0 ? currentPage / totalPages : 0,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${(totalPages > 0 ? (currentPage / totalPages * 100) : 0).toStringAsFixed(1)}%',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: currentPage < totalPages ? _nextPage : null,
                    icon: Icon(Icons.chevron_right),
                    iconSize: 32,
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _previousPage() async {
    if (controller != null && currentPage > 1) {
      await controller!.setPage(currentPage - 2);
    }
  }

  void _nextPage() async {
    if (controller != null && currentPage < totalPages) {
      await controller!.setPage(currentPage);
    }
  }

  void _updateProgress() {
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    bookProvider.updateBookProgress(widget.book.id, currentPage, totalPages);
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ошибка'),
        content: Text('Не удалось загрузить PDF файл. Проверьте, что файл не поврежден.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}