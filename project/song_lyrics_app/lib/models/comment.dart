import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String id;
  final String songId;
  final String text;
  final String authorId;
  final String authorUsername;
  final Timestamp createdAt;

  Comment({
    required this.id,
    required this.songId,
    required this.text,
    required this.authorId,
    required this.authorUsername,
    required this.createdAt,
  });

  factory Comment.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Comment(
      id: doc.id,
      songId: data['songId'] ?? doc.reference.parent.parent!.id,
      text: data['text'] as String,
      authorId: data['authorId'] as String,
      authorUsername: data['authorUsername'] as String? ?? 'Аноним',
      createdAt: data['createdAt'] as Timestamp,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'text': text,
      'authorId': authorId,
      'authorUsername': authorUsername,
      'createdAt': createdAt,
    };
  }
}
