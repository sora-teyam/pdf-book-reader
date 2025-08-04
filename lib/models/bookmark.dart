class Bookmark {
  final String id;
  final String bookId;
  final int pageNumber;
  final String title;
  final DateTime createdDate;

  Bookmark({
    required this.id,
    required this.bookId,
    required this.pageNumber,
    required this.title,
    required this.createdDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bookId': bookId,
      'pageNumber': pageNumber,
      'title': title,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      id: json['id'],
      bookId: json['bookId'],
      pageNumber: json['pageNumber'],
      title: json['title'],
      createdDate: DateTime.parse(json['createdDate']),
    );
  }
}