import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../models/note.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  late Future<List<Note>> _notesFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    setState(() {
      _notesFuture = DBHelper.fetchNotes();
    });
  }

  Future<void> _showNoteDialog({Note? note}) async {
    final titleCtrl = TextEditingController(text: note?.title ?? '');
    final bodyCtrl = TextEditingController(text: note?.body ?? '');
    final isEditing = note != null;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 37, 37, 37),
        title: Text(isEditing ? 'Редактировать' : 'Новая заметка', style: const TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Заголовок',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
            TextField(
              controller: bodyCtrl,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Текст',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white70)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Отмена', style: TextStyle(color: Colors.white)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color.fromARGB(144, 244, 67, 54),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final now = DateTime.now();
      if (isEditing) {
        final updatedNote = note.copyWith(
          title: titleCtrl.text,
          body: bodyCtrl.text,
          updatedAt: now,
        );
        await DBHelper.updateNote(updatedNote);
      } else {
        final newNote = Note(
          title: titleCtrl.text,
          body: bodyCtrl.text,
          createdAt: now,
          updatedAt: now,
        );
        await DBHelper.insertNote(newNote);
      }
      _reload();
    }
  }

  Future<void> _deleteNote(int id) async {
    await DBHelper.deleteNote(id);
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        title: const Text(
          'SQLite Notes',
          style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
        ),
        backgroundColor: const Color.fromARGB(71, 255, 7, 7),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        backgroundColor: const Color.fromARGB(123, 244, 67, 54),
        child: const Icon(Icons.add, color: Color.fromARGB(207, 255, 255, 255)),
      ),
      body: FutureBuilder<List<Note>>(
        future: _notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ошибка загрузки: ${snapshot.error}', style: const TextStyle(color: Colors.white)));
          }

          final notes = snapshot.data!;

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                'Пока нет заметок. Нажмите +',
                style: TextStyle(color: Color.fromARGB(255, 226, 226, 226)),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: notes.length,
            separatorBuilder: (context, i) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final note = notes[i];
              return Card(
                color: const Color.fromARGB(255, 60, 60, 60),
                child: ListTile(
                  title: Text(
                    note.title.isEmpty ? '(без названия)' : note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  subtitle: Text(
                    note.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () => _showNoteDialog(note: note),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _deleteNote(note.id!),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
