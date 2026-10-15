import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/song.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  Future<List<Song>> getSongs() async {
    final snapshot = await _firestore.collection('songs').get();
    return snapshot.docs
        .map((document) => Song.fromFirestore(document.id, document.data()))
        .toList(growable: false);
  }
}
