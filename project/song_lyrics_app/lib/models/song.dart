import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  final String id;
  final String title;
  final String? artist;
  final String lyrics;
  final String? coverBase64;
  final String authorId;
  final Timestamp createdAt;

  Song({
    required this.id,
    required this.title,
    this.artist,
    required this.lyrics,
    this.coverBase64,
    required this.authorId,
    required this.createdAt,
  });

  factory Song.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Song(
      id: doc.id,
      title: data['title'] as String,
      artist: data['artist'] as String?,
      lyrics: data['lyrics'] as String,
      coverBase64: data['cover_base64'] as String?,
      authorId: data['authorId'] as String,
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'artist': artist,
      'lyrics': lyrics,
      'cover_base64': coverBase64,
      'authorId': authorId,
      'createdAt': createdAt,
    };
  }
}
