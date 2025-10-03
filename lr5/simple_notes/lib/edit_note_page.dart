import 'package:flutter/material.dart';
import 'models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note? existing;
  const EditNotePage({super.key, this.existing});

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title = widget.existing?.title ?? '';
  late String _body = widget.existing?.body ?? '';

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final result = (widget.existing == null)
        ? Note(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            title: _title,
            body: _body,
          )
        : widget.existing!.copyWith(title: _title, body: _body);

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 37, 37, 37),
      appBar: AppBar(
        title: Text(
          isEdit ? 'Редактировать' : 'Новая заметка',
          style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
        ),
        backgroundColor: const Color.fromARGB(71, 255, 7, 7),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: const InputDecoration(
                  labelText: 'Заголовок',
                  labelStyle: TextStyle(color: Colors.white),
                ),
                style: const TextStyle(color: Colors.white),
                onSaved: (v) => _title = v!.trim(),
              ),
              const SizedBox(height: 12),
              Container(
                // width: 200,

                // height: 300,
                color: const Color.fromARGB(271, 255, 7, 7),

                child: Center(
                  child: TextFormField(
                    initialValue: _body,
                    decoration: const InputDecoration(
                      labelText: 'Текст',
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    minLines: 5,
                    maxLines: 10,
                    style: const TextStyle(color: Colors.white),
                    onSaved: (v) => _body = v!.trim(),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Введите текст заметки'
                        : null,
                  ),
                ),
              ),
              // TextFormField(
              //   initialValue: _body,
              //   decoration: const InputDecoration(
              //     labelText: 'Текст',
              //     labelStyle: TextStyle(color: Colors.white),
              //   ),
              //   minLines: 3,
              //   maxLines: 6,
              //   onSaved: (v) => _body = v!.trim(),
              //   validator: (v) => (v == null || v.trim().isEmpty)
              //       ? 'Введите текст заметки'
              //       : null,
              // ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Сохранить'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(144, 244, 67, 54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
