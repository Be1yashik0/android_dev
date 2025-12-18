import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/comment.dart';
import '../models/song.dart';

class FirebaseService {
  static final FirebaseService instance = FirebaseService._();
  FirebaseService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<User?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  CollectionReference get _usersCollection => _firestore.collection('users');

  Future<void> createUserProfile(String uid, String username) async {
    await _usersCollection.doc(uid).set({
      'username': username.trim(),
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }

  CollectionReference get _songsCollection => _firestore.collection('songs');

  Future<void> addSong(Song song) async {
    await _songsCollection.add(song.toFirestore());
  }

  Stream<List<Song>> getSongsStream() {
    return _songsCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Song.fromFirestore(doc)).toList(),
        );
  }

  CollectionReference commentsCollection(String songId) =>
      _songsCollection.doc(songId).collection('comments');

  Future<void> addComment(String songId, Comment comment) async {
    await commentsCollection(songId).add(comment.toFirestore());
  }

  Stream<List<Comment>> getCommentsStream(String songId) {
    return commentsCollection(songId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => Comment.fromFirestore(doc)).toList(),
        );
  }
}
