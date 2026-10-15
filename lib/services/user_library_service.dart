import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/playlist.dart';
import '../models/song.dart';

class UserLibraryService {
  UserLibraryService({FirebaseFirestore? firestore, FirebaseAuth? firebaseAuth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  CollectionReference<Map<String, dynamic>> get _userCollection {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError(
        'Une connexion est nécessaire pour accéder à la bibliothèque.',
      );
    }
    return _firestore.collection('users').doc(user.uid).collection('favorites');
  }

  CollectionReference<Map<String, dynamic>> get _playlistsCollection {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw StateError(
        'Une connexion est nécessaire pour accéder à la bibliothèque.',
      );
    }
    return _firestore.collection('users').doc(user.uid).collection('playlists');
  }

  Future<List<Song>> getFavorites() async {
    final snapshot = await _userCollection.get();
    return snapshot.docs
        .map((document) => Song.fromFirestore(document.id, document.data()))
        .toList(growable: false);
  }

  Future<void> addFavorite(Song song) {
    return _userCollection.doc(song.id).set(song.toFirestore());
  }

  Future<void> removeFavorite(Song song) {
    return _userCollection.doc(song.id).delete();
  }

  Future<List<Playlist>> getPlaylists() async {
    final snapshot = await _playlistsCollection.get();
    return Future.wait(
      snapshot.docs.map((document) async {
        final songSnapshot = await document.reference.collection('songs').get();
        final playlistName = document.data()['nom'];
        if (playlistName is! String || playlistName.trim().isEmpty) {
          throw FormatException(
            'Le nom de la playlist "${document.id}" est absent ou invalide.',
          );
        }
        return Playlist(
          id: document.id,
          nom: playlistName,
          songs: songSnapshot.docs
              .map((song) => Song.fromFirestore(song.id, song.data()))
              .toList(),
        );
      }),
    );
  }

  Future<String> createPlaylist(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) {
      throw ArgumentError.value(name, 'name', 'Le nom ne peut pas être vide.');
    }

    final reference = _playlistsCollection.doc();
    await reference.set({'id': reference.id, 'nom': trimmedName});
    return reference.id;
  }

  Future<void> addSongToPlaylist(String playlistId, Song song) async {
    final playlist = _playlistsCollection.doc(playlistId);
    final playlistSnapshot = await playlist.get();
    if (!playlistSnapshot.exists) {
      throw StateError('La playlist "$playlistId" est introuvable.');
    }
    await playlist.collection('songs').doc(song.id).set(song.toFirestore());
  }

  Future<void> removeSongFromPlaylist(String playlistId, Song song) {
    return _playlistsCollection
        .doc(playlistId)
        .collection('songs')
        .doc(song.id)
        .delete();
  }
}
