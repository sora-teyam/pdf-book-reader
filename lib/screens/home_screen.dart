import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/book_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/book_card.dart';
import '../generated/l10n.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    
    return Scaffold(
      appBar: _isSearching ? _buildSearchAppBar(s) : _buildNormalAppBar(s),
      body: Consumer2<BookProvider, SettingsProvider>(
        builder: (context, bookProvider, settingsProvider, child) {
          if (bookProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (bookProvider.books.isEmpty) {
            return _buildEmptyState(s);
          }

          return Column(
            children: [
              // Статистика
              _buildStatsCard(bookProvider, s),
              
              // Табы
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(text: s.recentBooks),
                  Tab(text: s.allBooks),
                ],
              ),
              
              // Контент табов
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildRecentBooksGrid(bookProvider, s),
                    _buildAllBooksGrid(bookProvider, settingsProvider, s),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _pickAndAddBook(context),
        icon: const Icon(Icons.add),
        label: Text(S.of(context).addBook),
      ),
    );
  }

  PreferredSizeWidget _buildNormalAppBar(S s) {
    return AppBar(
      title: Text(s.appTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => setState(() => _isSearching = true),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSearchAppBar(S s) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => setState(() {
          _isSearching = false;
          _searchQuery = '';
        }),
      ),
      title: TextField(
        autofocus: true,
        decoration: InputDecoration(
          hintText: s.searchInBook,
          border: InputBorder.none,
        ),
        onChanged: (query) => setState(() => _searchQuery = query),
      ),
      actions: [
        if (_searchQuery.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => setState(() => _searchQuery = ''),
          ),
      ],
    );
  }

  Widget _buildEmptyState(S s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_stories_outlined,
            size: 120,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 20),
          Text(
            s.noBooksTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            s.noBooksSubtitle,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          const SizedBox(height: 40),
          FilledButton.icon(
            onPressed: () => _pickAndAddBook(context),
            icon: const Icon(Icons.add),
            label: Text(s.addBook),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BookProvider bookProvider, S s) {
    if (bookProvider.totalBooks == 0) {
      return const SizedBox.shrink(); // Скрываем статистику если нет книг
    }
    
    return Container(
      margin: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                '${bookProvider.totalBooks}',
                'Всего книг',
                Icons.library_books,
                Colors.blue,
              ),
              _buildStatItem(
                '${bookProvider.inProgressBooks}',
                'В процессе',
                Icons.bookmark_outline,
                Colors.orange,
              ),
              _buildStatItem(
                '${bookProvider.completedBooks}',
                'Прочитано',
                Icons.check_circle_outline,
                Colors.green,
              ),
              _buildStatItem(
                '${(bookProvider.averageProgress * 100).round()}%',
                'Средний прогресс',
                Icons.trending_up,
                Colors.purple,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentBooksGrid(BookProvider bookProvider, S s) {
    final recentBooks = bookProvider.getRecentBooks();
    final filteredBooks = _filterBooks(recentBooks);

    if (filteredBooks.isEmpty && _searchQuery.isNotEmpty) {
      return _buildNoSearchResults(s);
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, // Увеличили высоту карточек
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: filteredBooks.length,
      itemBuilder: (context, index) {
        return BookCard(book: filteredBooks[index]);
      },
    );
  }

  Widget _buildAllBooksGrid(BookProvider bookProvider, SettingsProvider settingsProvider, S s) {
    final sortedBooks = bookProvider.getSortedBooks(
      settingsProvider.sortType,
      settingsProvider.sortAscending,
    );
    final filteredBooks = _filterBooks(sortedBooks);

    if (filteredBooks.isEmpty && _searchQuery.isNotEmpty) {
      return _buildNoSearchResults(s);
    }

    return Column(
      children: [
        // Панель сортировки
        _buildSortPanel(settingsProvider, s),
        
        // Сетка книг
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: filteredBooks.length,
            itemBuilder: (context, index) {
              return BookCard(book: filteredBooks[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSortPanel(SettingsProvider settingsProvider, S s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(s.sortBy, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(width: 8),
          DropdownButton<BookSortType>(
            value: settingsProvider.sortType,
            onChanged: (BookSortType? newValue) {
              if (newValue != null) {
                settingsProvider.setSortType(newValue);
              }
            },
            items: [
              DropdownMenuItem(value: BookSortType.name, child: Text(s.sortByName)),
              DropdownMenuItem(value: BookSortType.dateAdded, child: Text(s.sortByDate)),
              DropdownMenuItem(value: BookSortType.progress, child: Text(s.sortByProgress)),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: Icon(settingsProvider.sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
            onPressed: () => settingsProvider.setSortAscending(!settingsProvider.sortAscending),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSearchResults(S s) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Theme.of(context).colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'Ничего не найдено',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Попробуйте изменить поисковый запрос',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  List<dynamic> _filterBooks(List<dynamic> books) {
    if (_searchQuery.isEmpty) return books;
    
    return books.where((book) {
      return book.title.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  Future<void> _pickAndAddBook(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        final bookProvider = Provider.of<BookProvider>(context, listen: false);
        
        // Показываем индикатор загрузки
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(
            child: CircularProgressIndicator(),
          ),
        );

        final success = await bookProvider.addBook(
          result.files.single.path!,
          result.files.single.name,
        );

        Navigator.of(context).pop(); // Закрываем диалог загрузки

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).bookAddedSuccess),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).bookAddedError),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      Navigator.of(context).pop(); // Закрываем диалог загрузки если есть
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${S.of(context).error}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}