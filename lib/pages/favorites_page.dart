import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../common/widgets/songcard.dart';
import '../models/song.dart';
import '../services/favoritesmanager.dart';
import '../services/user_library_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key, this.userLibraryService});

  final UserLibraryService? userLibraryService;

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  Future<List<Song>>? _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = widget.userLibraryService?.getFavorites();
  }

  Future<void> _removeRemoteFavorite(Song song) async {
    try {
      await widget.userLibraryService!.removeFavorite(song);
      if (mounted) {
        setState(() {
          _favoritesFuture = widget.userLibraryService!.getFavorites();
        });
      }
    } on FirebaseException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible de retirer ce favori : ${error.message ?? error.code}',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userLibraryService != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Mes favoris'),
          backgroundColor: const Color.fromARGB(255, 250, 139, 109),
        ),
        body: FutureBuilder<List<Song>>(
          future: _favoritesFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Impossible de charger les favoris : ${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final favorites = snapshot.data!;
            if (favorites.isEmpty) {
              return const Center(child: Text('Aucun favori pour le moment'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final song = favorites[index];
                return SongCard(
                  song: song,
                  isFavorite: true,
                  onFavoriteToggleRemote: () => _removeRemoteFavorite(song),
                );
              },
            );
          },
        ),
      );
    }

    final favorites = FavoritesManager.favorites;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes favoris'),
        backgroundColor: const Color.fromARGB(255, 250, 139, 109),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text(
                'Aucun favori pour le moment',
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return SongCard(
                  song: favorites[index],
                  onFavoriteToggle: () => setState(() {}),
                );
              },
            ),
    );
  }
}
