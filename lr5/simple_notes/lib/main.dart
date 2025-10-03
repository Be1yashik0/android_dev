import 'package:flutter/material.dart';
import 'models/note.dart';
import 'edit_note_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simple Notes',
      theme: ThemeData(useMaterial3: true),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final List<Note> _notes = [
    // Note(id: '1', title: 'Пример', body: 'Это пример заметки'),
  ];

  String _searchQuery = '';

  Future<void> _addNote() async {
    final newNote = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage()),
    );
    if (newNote != null) {
      setState(() => _notes.add(newNote));
    }
  }

  Future<void> _edit(Note note) async {
    final updated = await Navigator.push<Note>(
      context,
      MaterialPageRoute(builder: (_) => EditNotePage(existing: note)),
    );
    if (updated != null) {
      setState(() {
        final i = _notes.indexWhere((n) => n.id == updated.id);
        if (i != -1) _notes[i] = updated;
      });
    }
  }

  void _delete(Note note) {
    setState(() {
      _notes.removeWhere((n) => n.id == note.id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Заметка удалена'),
        action: SnackBarAction(
          label: 'Отменить',
          onPressed: () {
            setState(() => _notes.add(note));
          },
        ),
      ),
    );
  }

  List<Note> _filteredNotes() {
    if (_searchQuery.isEmpty) return _notes;
    return _notes
        .where(
          (note) =>
              note.title.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = _filteredNotes();
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        title: const Text(
          'Simple Notes',
          style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
        ),
        backgroundColor: const Color.fromARGB(71, 255, 7, 7),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              final query = await showSearch<String>(
                context: context,
                delegate: NoteSearchDelegate(_notes),
              );
              if (query != null && mounted) {
                setState(() => _searchQuery = query);
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: const Color.fromARGB(123, 244, 67, 54),
        child: const Icon(Icons.add, color: Color.fromARGB(207, 255, 255, 255)),
      ),
      body: filteredNotes.isEmpty
          ? const Center(
              child: Text(
                'Пока нет заметок. Нажмите +',
                style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              ),
            )
          : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, i) {
                final note = filteredNotes[i];
                return Dismissible(
                  key: ValueKey(note.id),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Color.fromARGB(255, 252, 252, 252),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => _delete(note),

                  child: ListTile(
                    key: ValueKey(note.id),
                    title: Text(
                      note.title.isEmpty ? '(без названия)' : note.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      note.body,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => _edit(note),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Color.fromARGB(255, 252, 252, 252),
                      ),
                      onPressed: () => _delete(note),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class NoteSearchDelegate extends SearchDelegate<String> {
  final List<Note> notes;

  NoteSearchDelegate(this.notes);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = notes
        .where((note) => note.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, i) {
        final note = results[i];
        return ListTile(
          title: Text(note.title.isEmpty ? '(без названия)' : note.title),
          subtitle: Text(
            note.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () => close(context, note.title),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return buildResults(context);
  }
}
