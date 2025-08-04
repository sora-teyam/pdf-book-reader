class Book {
  final String id;
  String title; // Убираем final чтобы можно было изменять
  final String filePath;
  final DateTime addedDate;
  int currentPage;
  int totalPages;
  String? customCoverPath; // Добавляем путь к пользовательской обложке

  Book({
    required this.id,
    required this.title,
    required this.filePath,
    required this.addedDate,
    this.currentPage = 1,
    this.totalPages = 0,
    this.customCoverPath,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'addedDate': addedDate.toIso8601String(),
      'currentPage': currentPage,
      'totalPages': totalPages,
      'customCoverPath': customCoverPath,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      title: json['title'],
      filePath: json['filePath'],
      addedDate: DateTime.parse(json['addedDate']),
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 0,
      customCoverPath: json['customCoverPath'],
    );
  }

  double get readingProgress {
    if (totalPages <= 0) return 0.0;
    return currentPage / totalPages;
  }
}