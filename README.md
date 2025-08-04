# PDFBookReader 📚

A modern, feature-rich PDF reader app built with Flutter for Android devices. Read your PDF books with style and comfort!

## ✨ Features

### 📖 Library Management
- Add PDF files from device storage
- Beautiful book cards with progress indicators
- Custom book covers (set your own images)
- Rename books with custom titles
- Smart sorting (by name, date, progress)
- Search through your library
- Reading statistics dashboard

### 🎯 Reading Experience
- Smooth page navigation with swipe gestures
- Tap navigation buttons for precise control
- Adjustable font size (zoom functionality)
- Brightness control for comfortable reading
- Full-screen reading mode
- Keep screen on option
- Auto-save reading progress

### 🔖 Bookmarks & Navigation
- Add/remove bookmarks on any page
- Quick bookmark access panel
- Jump to specific page
- Visual progress tracking
- Reading percentage display

### 🌍 Multilingual Support
- English
- Russian (Русский)
- Ukrainian (Українська)
- Slovak (Slovenčina)

### 🎨 Themes & Customization
- Light/Dark/System themes
- Adjustable interface settings
- Customizable reading preferences
- Modern Material Design 3 UI

## 📱 Screenshots

| Library View | Reading Mode | Bookmarks | Settings |
|--------------|--------------|-----------|----------|
| Coming soon | Coming soon | Coming soon | Coming soon |

## 🚀 Installation

### Download APK
1. Go to [Releases](https://github.com/krutoychel24/pdf-book-reader/releases)
2. Download the latest `PDFBookReader.apk`
3. Install on your Android device

### Build from Source
```bash
# Clone the repository
git clone https://github.com/krutoychel24/pdf-book-reader.git
cd pdf-book-reader

# Install dependencies
flutter pub get

# Build APK
flutter build apk --release

# Or just run
flutter run
```

## 📋 Requirements

- Android 5.0 (API level 21) or higher
- 50MB free storage space
- PDF files on device storage

## 🛠️ Tech Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart
- **Architecture**: Provider state management
- **PDF Rendering**: flutter_pdfview
- **File Picker**: file_picker
- **Local Storage**: shared_preferences
- **Internationalization**: flutter_localizations

## 📁 Project Structure

```
lib/
├── main.dart
├── generated/
│   └── l10n.dart
├── l10n/
│   ├── app_en.arb
│   ├── app_ru.arb
│   ├── app_sk.arb
│   └── app_uk.arb
├── models/
│   ├── book.dart
│   └── bookmark.dart
├── providers/
│   ├── book_provider.dart
│   └── settings_provider.dart
├── screens/
│   ├── home_screen.dart
│   ├── pdf_reader_screen.dart
│   └── settings_screen.dart
├── widgets/
│   ├── book_card.dart
│   └── bookmarks_bottom_sheet.dart
└── utils/
    └── pdf_thumbnail_generator.dart
```

## 📖 Usage

1. **Add Books**: Tap the '+' button and select PDF files from your device
2. **Read Books**: Tap on any book card to start reading
3. **Navigate**: Swipe left/right or use navigation buttons
4. **Bookmarks**: Tap bookmark icon to save your place
5. **Customize**: Access settings to adjust themes, language, and reading preferences

## 🔮 Features in Development

- PDF text search
- Reading notes and highlights
- Cloud synchronization
- Book categories and tags
- Export reading data

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

- **Developer**: HruHruStudio (krutoychel24)
- **Website**: [hruhrustudio.site](https://hruhrustudio.site)
- **GitHub**: [@krutoychel24](https://github.com/krutoychel24)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- PDF rendering library maintainers
- Material Design team for UI guidelines
- Open source community for inspiration

---

**Made with ❤️ using Flutter**
