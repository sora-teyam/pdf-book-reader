// ЗАГЛУШКА - этот файл будет автоматически сгенерирован после flutter pub get
// Временно используем простую имплементацию

import 'package:flutter/material.dart';

class S {
  S(this.localeName);
  
  final String localeName;

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S)!;
  }

  static const LocalizationsDelegate<S> delegate = _SDelegate();

  // Переводы в зависимости от языка
  String get appTitle {
    switch (localeName) {
      case 'ru': return 'PDF Читалка';
      case 'uk': return 'PDF Читалка';
      case 'sk': return 'PDF Čítačka';
      default: return 'PDF Reader';
    }
  }

  String get noBooksTitle {
    switch (localeName) {
      case 'ru': return 'Нет книг';
      case 'uk': return 'Немає книг';
      case 'sk': return 'Žiadne knihy';
      default: return 'No Books';
    }
  }

  String get noBooksSubtitle {
    switch (localeName) {
      case 'ru': return 'Добавьте свою первую PDF книгу';
      case 'uk': return 'Додайте свою першу PDF книгу';
      case 'sk': return 'Pridajte svoju prvú PDF knihu';
      default: return 'Add your first PDF book';
    }
  }

  String get addBook {
    switch (localeName) {
      case 'ru': return 'Добавить книгу';
      case 'uk': return 'Додати книгу';
      case 'sk': return 'Pridať knihu';
      default: return 'Add Book';
    }
  }

  String get removeBook {
    switch (localeName) {
      case 'ru': return 'Удалить книгу';
      case 'uk': return 'Видалити книгу';
      case 'sk': return 'Odstrániť knihu';
      default: return 'Remove Book';
    }
  }

  String get openBook {
    switch (localeName) {
      case 'ru': return 'Открыть книгу';
      case 'uk': return 'Відкрити книгу';
      case 'sk': return 'Otvoriť knihu';
      default: return 'Open Book';
    }
  }

  String get cancel {
    switch (localeName) {
      case 'ru': return 'Отмена';
      case 'uk': return 'Скасувати';
      case 'sk': return 'Zrušiť';
      default: return 'Cancel';
    }
  }

  String get delete {
    switch (localeName) {
      case 'ru': return 'Удалить';
      case 'uk': return 'Видалити';
      case 'sk': return 'Vymazať';
      default: return 'Delete';
    }
  }

  String get deleteBookTitle {
    switch (localeName) {
      case 'ru': return 'Удалить книгу?';
      case 'uk': return 'Видалити книгу?';
      case 'sk': return 'Vymazať knihu?';
      default: return 'Delete Book?';
    }
  }

  String deleteBookMessage(String title) {
    switch (localeName) {
      case 'ru': return 'Вы уверены, что хотите удалить "$title"? Это действие нельзя отменить.';
      case 'uk': return 'Ви впевнені, що хочете видалити "$title"? Цю дію неможливо скасувати.';
      case 'sk': return 'Ste si istí, že chcete vymazať "$title"? Túto akciu nie je možné vrátiť späť.';
      default: return 'Are you sure you want to delete "$title"? This action cannot be undone.';
    }
  }

  String get bookAddedSuccess {
    switch (localeName) {
      case 'ru': return 'Книга успешно добавлена!';
      case 'uk': return 'Книгу успішно додано!';
      case 'sk': return 'Kniha bola úspešne pridaná!';
      default: return 'Book added successfully!';
    }
  }

  String get bookAddedError {
    switch (localeName) {
      case 'ru': return 'Ошибка при добавлении книги';
      case 'uk': return 'Помилка при додаванні книги';
      case 'sk': return 'Chyba pri pridávaní knihy';
      default: return 'Error adding book';
    }
  }

  String get bookDeleted {
    switch (localeName) {
      case 'ru': return 'Книга удалена';
      case 'uk': return 'Книгу видалено';
      case 'sk': return 'Kniha vymazaná';
      default: return 'Book deleted';
    }
  }

  String get loadingPdf {
    switch (localeName) {
      case 'ru': return 'Загрузка PDF...';
      case 'uk': return 'Завантаження PDF...';
      case 'sk': return 'Načítavanie PDF...';
      default: return 'Loading PDF...';
    }
  }

  String get fileNotFound {
    switch (localeName) {
      case 'ru': return 'Файл не найден';
      case 'uk': return 'Файл не знайдено';
      case 'sk': return 'Súbor sa nenašiel';
      default: return 'File not found';
    }
  }

  String get fileNotFoundMessage {
    switch (localeName) {
      case 'ru': return 'PDF файл был удален или перемещен';
      case 'uk': return 'PDF файл було видалено або переміщено';
      case 'sk': return 'PDF súbor bol vymazaný alebo presunutý';
      default: return 'PDF file was deleted or moved';
    }
  }

  String get error {
    switch (localeName) {
      case 'ru': return 'Ошибка';
      case 'uk': return 'Помилка';
      case 'sk': return 'Chyba';
      default: return 'Error';
    }
  }

  String get pdfLoadError {
    switch (localeName) {
      case 'ru': return 'Не удалось загрузить PDF файл. Проверьте, что файл не поврежден.';
      case 'uk': return 'Не вдалося завантажити PDF файл. Перевірте, чи файл не пошкоджений.';
      case 'sk': return 'Nepodarilo sa načítať PDF súbor. Skontrolujte, či súbor nie je poškodený.';
      default: return 'Could not load PDF file. Check that the file is not corrupted.';
    }
  }

  String get ok {
    switch (localeName) {
      case 'ru': return 'ОК';
      case 'uk': return 'OK';
      case 'sk': return 'OK';
      default: return 'OK';
    }
  }

  String get notStarted {
    switch (localeName) {
      case 'ru': return 'Не начата';
      case 'uk': return 'Не розпочато';
      case 'sk': return 'Nezačaté';
      default: return 'Not started';
    }
  }

  String get page {
    switch (localeName) {
      case 'ru': return 'Страница';
      case 'uk': return 'Сторінка';
      case 'sk': return 'Strana';
      default: return 'Page';
    }
  }

  String get ofPages {
    switch (localeName) {
      case 'ru': return 'из';
      case 'uk': return 'з';
      case 'sk': return 'z';
      default: return 'of';
    }
  }

  String get settings {
    switch (localeName) {
      case 'ru': return 'Настройки';
      case 'uk': return 'Налаштування';
      case 'sk': return 'Nastavenia';
      default: return 'Settings';
    }
  }

  String get language {
    switch (localeName) {
      case 'ru': return 'Язык';
      case 'uk': return 'Мова';
      case 'sk': return 'Jazyk';
      default: return 'Language';
    }
  }

  String get theme {
    switch (localeName) {
      case 'ru': return 'Тема';
      case 'uk': return 'Тема';
      case 'sk': return 'Téma';
      default: return 'Theme';
    }
  }

  String get systemTheme {
    switch (localeName) {
      case 'ru': return 'Системная';
      case 'uk': return 'Системна';
      case 'sk': return 'Systémová';
      default: return 'System';
    }
  }

  String get lightTheme {
    switch (localeName) {
      case 'ru': return 'Светлая';
      case 'uk': return 'Світла';
      case 'sk': return 'Svetlá';
      default: return 'Light';
    }
  }

  String get darkTheme {
    switch (localeName) {
      case 'ru': return 'Темная';
      case 'uk': return 'Темна';
      case 'sk': return 'Tmavá';
      default: return 'Dark';
    }
  }

  String get bookmarks {
    switch (localeName) {
      case 'ru': return 'Закладки';
      case 'uk': return 'Закладки';
      case 'sk': return 'Záložky';
      default: return 'Bookmarks';
    }
  }

  String get addBookmark {
    switch (localeName) {
      case 'ru': return 'Добавить закладку';
      case 'uk': return 'Додати закладку';
      case 'sk': return 'Pridať záložku';
      default: return 'Add Bookmark';
    }
  }

  String get removeBookmark {
    switch (localeName) {
      case 'ru': return 'Удалить закладку';
      case 'uk': return 'Видалити закладку';
      case 'sk': return 'Odstrániť záložku';
      default: return 'Remove Bookmark';
    }
  }

  String get goToPage {
    switch (localeName) {
      case 'ru': return 'Перейти к странице';
      case 'uk': return 'Перейти до сторінки';
      case 'sk': return 'Prejsť na stranu';
      default: return 'Go to Page';
    }
  }

  String get searchInBook {
    switch (localeName) {
      case 'ru': return 'Поиск в книге';
      case 'uk': return 'Пошук у книзі';
      case 'sk': return 'Hľadať v knihe';
      default: return 'Search in Book';
    }
  }

  String get noBookmarks {
    switch (localeName) {
      case 'ru': return 'Нет закладок';
      case 'uk': return 'Немає закладок';
      case 'sk': return 'Žiadne záložky';
      default: return 'No bookmarks';
    }
  }

  String get bookmarkAdded {
    switch (localeName) {
      case 'ru': return 'Закладка добавлена';
      case 'uk': return 'Закладку додано';
      case 'sk': return 'Záložka pridaná';
      default: return 'Bookmark added';
    }
  }

  String get bookmarkRemoved {
    switch (localeName) {
      case 'ru': return 'Закладка удалена';
      case 'uk': return 'Закладку видалено';
      case 'sk': return 'Záložka odstránená';
      default: return 'Bookmark removed';
    }
  }

  String get fontSize {
    switch (localeName) {
      case 'ru': return 'Размер шрифта';
      case 'uk': return 'Розмір шрифту';
      case 'sk': return 'Veľkosť písma';
      default: return 'Font Size';
    }
  }

  String get brightness {
    switch (localeName) {
      case 'ru': return 'Яркость';
      case 'uk': return 'Яскравість';
      case 'sk': return 'Jas';
      default: return 'Brightness';
    }
  }

  String get enterPageNumber {
    switch (localeName) {
      case 'ru': return 'Введите номер страницы';
      case 'uk': return 'Введіть номер сторінки';
      case 'sk': return 'Zadajte číslo strany';
      default: return 'Enter page number';
    }
  }

  String get invalidPageNumber {
    switch (localeName) {
      case 'ru': return 'Неверный номер страницы';
      case 'uk': return 'Невірний номер сторінки';
      case 'sk': return 'Neplatné číslo strany';
      default: return 'Invalid page number';
    }
  }

  String get jumpToPage {
    switch (localeName) {
      case 'ru': return 'Перейти';
      case 'uk': return 'Перейти';
      case 'sk': return 'Prejsť';
      default: return 'Jump';
    }
  }

  String get share {
    switch (localeName) {
      case 'ru': return 'Поделиться';
      case 'uk': return 'Поділитися';
      case 'sk': return 'Zdieľať';
      default: return 'Share';
    }
  }

  String get recentBooks {
    switch (localeName) {
      case 'ru': return 'Недавние книги';
      case 'uk': return 'Недавні книги';
      case 'sk': return 'Nedávne knihy';
      default: return 'Recent Books';
    }
  }

  String get allBooks {
    switch (localeName) {
      case 'ru': return 'Все книги';
      case 'uk': return 'Усі книги';
      case 'sk': return 'Všetky knihy';
      default: return 'All Books';
    }
  }

  String get sortBy {
    switch (localeName) {
      case 'ru': return 'Сортировать по';
      case 'uk': return 'Сортувати за';
      case 'sk': return 'Zoradiť podľa';
      default: return 'Sort By';
    }
  }

  String get sortByName {
    switch (localeName) {
      case 'ru': return 'Названию';
      case 'uk': return 'Назвою';
      case 'sk': return 'Názvu';
      default: return 'Name';
    }
  }

  String get sortByDate {
    switch (localeName) {
      case 'ru': return 'Дате добавления';
      case 'uk': return 'Даті додавання';
      case 'sk': return 'Dátumu pridania';
      default: return 'Date Added';
    }
  }

  String get sortByProgress {
    switch (localeName) {
      case 'ru': return 'Прогрессу';
      case 'uk': return 'Прогресу';
      case 'sk': return 'Pokroku';
      default: return 'Progress';
    }
  }

  String get about {
    switch (localeName) {
      case 'ru': return 'О программе';
      case 'uk': return 'Про програму';
      case 'sk': return 'O aplikácii';
      default: return 'About';
    }
  }

  String get version {
    switch (localeName) {
      case 'ru': return 'Версия';
      case 'uk': return 'Версія';
      case 'sk': return 'Verzia';
      default: return 'Version';
    }
  }

  String readingProgress(String progress, int current, int total) {
    switch (localeName) {
      case 'ru': return '$progress% • Стр. $current/$total';
      case 'uk': return '$progress% • Стор. $current/$total';
      case 'sk': return '$progress% • Str. $current/$total';
      default: return '$progress% • Page $current/$total';
    }
  }

  // Остальные свойства для совместимости
  String get progress => 'Progress';
  String get whatToDoWithBook => 'What do you want to do with this book?';
  String get nightMode => 'Night Mode';
  String get pageJump => 'Page Jump';
  String get copy => 'Copy';
}

class _SDelegate extends LocalizationsDelegate<S> {
  const _SDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ru', 'sk', 'uk'].contains(locale.languageCode);
  }

  @override
  Future<S> load(Locale locale) async {
    return S(locale.toString());
  }

  @override
  bool shouldReload(_SDelegate old) => false;

  List<Locale> get supportedLocales => [
    const Locale('en'),
    const Locale('ru'),
    const Locale('sk'),
    const Locale('uk'),
  ];
}