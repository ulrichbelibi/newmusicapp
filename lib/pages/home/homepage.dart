import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import "../../common/widgets/songcard.dart";
import '../../models/song.dart';
import "../../models/songdata.dart";
import '../../pages/profile_page.dart';
import '../../services/firestore_service.dart';
import '../../services/user_library_service.dart';
import '../favorites_page.dart';
import '../playlists/playlists_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.firestoreService, this.userLibraryService});

  final FirestoreService? firestoreService;
  final UserLibraryService? userLibraryService;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirestoreService? _firestoreService;
  late final UserLibraryService? _userLibraryService;
  Future<List<Song>>? _songs;
  final Set<String> _favoriteIds = {};

  bool get _usesFirebase =>
      _firestoreService != null && _userLibraryService != null;

  @override
  void initState() {
    super.initState();
    _firestoreService = widget.firestoreService;
    _userLibraryService = widget.userLibraryService;
    _songs = _firestoreService?.getSongs();
    if (_userLibraryService != null) _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _userLibraryService!.getFavorites();
      if (mounted) {
        setState(() {
          _favoriteIds
            ..clear()
            ..addAll(favorites.map((song) => song.id));
        });
      }
    } on FirebaseException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible de charger les favoris : ${error.message ?? error.code}',
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleFavorite(Song song) async {
    final wasFavorite = _favoriteIds.contains(song.id);
    setState(() {
      if (wasFavorite) {
        _favoriteIds.remove(song.id);
      } else {
        _favoriteIds.add(song.id);
      }
    });

    try {
      if (wasFavorite) {
        await _userLibraryService!.removeFavorite(song);
      } else {
        await _userLibraryService!.addFavorite(song);
      }
    } on FirebaseException catch (error) {
      if (mounted) {
        setState(() {
          if (wasFavorite) {
            _favoriteIds.add(song.id);
          } else {
            _favoriteIds.remove(song.id);
          }
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible d’enregistrer le favori : ${error.message ?? error.code}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil: Découvrez vos chansons'),
        backgroundColor: const Color.fromARGB(255, 250, 139, 109),
        actions: [
          IconButton(
            tooltip: 'Favoris',
            icon: const Icon(Icons.favorite),
            color: Colors.pink,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FavoritesPage(userLibraryService: _userLibraryService),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Playlists',
            icon: const Icon(Icons.library_music),
            color: Colors.pink,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      PlaylistsPage(userLibraryService: _userLibraryService),
                ),
              );
            },
          ),
          if (_usesFirebase)
            IconButton(
              tooltip: 'Mon profil',
              icon: const Icon(Icons.account_circle),
              color: Colors.pink,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
            ),
        ],
      ),
      body: _usesFirebase
          ? FutureBuilder<List<Song>>(
              future: _songs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Impossible de charger les chansons : ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                final songs = snapshot.data!;
                if (songs.isEmpty) {
                  return const Center(child: Text('Aucune chanson disponible'));
                }
                return ListView.builder(
                  itemCount: songs.length,
                  itemBuilder: (context, index) {
                    final song = songs[index];
                    return SongCard(
                      song: song,
                      isFavorite: _favoriteIds.contains(song.id),
                      onFavoriteToggleRemote: () => _toggleFavorite(song),
                    );
                  },
                );
              },
            )
          : ListView.builder(
              itemCount: localSongs.length,
              itemBuilder: (context, index) => SongCard(
                song: localSongs[index],
                onFavoriteToggle: () => setState(() {}),
              ),
            ),
    );
  }
}
