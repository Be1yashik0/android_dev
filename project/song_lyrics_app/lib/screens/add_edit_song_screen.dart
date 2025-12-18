import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';
import '../models/song.dart';

class AddEditSongScreen extends ConsumerStatefulWidget {
  final Song? existingSong;

  const AddEditSongScreen({super.key, this.existingSong});

  @override
  ConsumerState<AddEditSongScreen> createState() => _AddEditSongScreenState();
}

class _AddEditSongScreenState extends ConsumerState<AddEditSongScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _artistController = TextEditingController();
  final _lyricsController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.existingSong != null) {
      _titleController.text = widget.existingSong!.title;
      _artistController.text = widget.existingSong!.artist ?? '';
      _lyricsController.text = widget.existingSong!.lyrics;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _artistController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final firebaseService = ref.read(firebaseServiceProvider);
      final currentUser = firebaseService.currentUser;

      if (currentUser == null) throw Exception('Пользователь не авторизован');

      String? coverBase64;
      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        if (bytes.length > 700 * 1024) {
          // Ограничение ~700 КБ
          throw Exception(
            'Изображение слишком большое. Выберите файл меньшего размера.',
          );
        }
        coverBase64 = base64Encode(bytes);
      }

      final song = Song(
        id: '',
        title: _titleController.text.trim(),
        artist: _artistController.text.trim().isEmpty
            ? null
            : _artistController.text.trim(),
        lyrics: _lyricsController.text.trim(),
        coverBase64: coverBase64,
        authorId: currentUser.uid,
        createdAt: Timestamp.now(),
      );

      await firebaseService.addSong(song);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Песня успешно добавлена')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: ${e.toString()}')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Добавить песню')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Название песни *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  filled: true,
                ),
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _artistController,
                decoration: const InputDecoration(
                  labelText: 'Исполнитель',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  filled: true,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lyricsController,
                decoration: const InputDecoration(
                  labelText: 'Текст песни *',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  alignLabelWithHint: true,
                  filled: true,
                ),
                maxLines: 10,
                validator: (value) =>
                    value?.trim().isEmpty ?? true ? 'Обязательное поле' : null,
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Обложка (опционально)',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.grey[200],
                      ),
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Center(
                              child: Icon(Icons.add_photo_alternate, size: 50),
                            ),
                    ),
                  ),
                  if (_selectedImage != null) ...[
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => setState(() => _selectedImage = null),
                      child: const Text('Удалить изображение'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Сохранить песню',
                          style: TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
