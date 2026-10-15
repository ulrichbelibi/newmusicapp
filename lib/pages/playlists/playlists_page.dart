import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/playlist.dart';
import '../../services/playlists_manager.dart';
import '../../services/user_library_service.dart';

class PlaylistsPage extends StatefulWidget {
  const PlaylistsPage({super.key, this.userLibraryService});

  final UserLibraryService? userLibraryService;

  @override
  State<PlaylistsPage> createState() => _PlaylistsPageState();
}

class _PlaylistsPageState extends State<PlaylistsPage> {
  final TextEditingController _controller = TextEditingController();
  Future<List<Playlist>>? _playlistsFuture;
  bool _isCreating = false;

  @override
  void initState() {
    super.initState();
    _refreshRemotePlaylists();
  }

  void _refreshRemotePlaylists() {
    final service = widget.userLibraryService;
    if (service != null) {
      _playlistsFuture = service.getPlaylists();
    }
  }

  void _showCreatePlaylistDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Créer une playlist'),
          content: TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Nom de la playlist'),
            onSubmitted: (_) => _createPlaylist(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _controller.clear();
              },
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: _createPlaylist,
              child: const Text('Créer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createPlaylist() async {
    final value = _controller.text.trim();
    if (value.isEmpty) {
      return;
    }

    setState(() => _isCreating = true);
    try {
      final service = widget.userLibraryService;
      if (service == null) {
        PlaylistsManager.createPlaylist(value);
      } else {
        await service.createPlaylist(value);
      }
    } on FirebaseException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Impossible de créer la playlist : ${error.message ?? error.code}',
            ),
          ),
        );
      }
      return;
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }

    _controller.clear();
    if (mounted) {
      setState(_refreshRemotePlaylists);
      Navigator.of(context).pop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final remoteLibrary = widget.userLibraryService != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes playlists'),
        backgroundColor: const Color.fromARGB(255, 250, 139, 109),
      ),
      body: remoteLibrary
          ? FutureBuilder<List<Playlist>>(
              future: _playlistsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Impossible de charger les playlists : ${snapshot.error}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                return _buildPlaylistList(snapshot.data!);
              },
            )
          : _buildPlaylistList(PlaylistsManager.playlists),
      floatingActionButton: FloatingActionButton(
        onPressed: _isCreating ? null : _showCreatePlaylistDialog,
        backgroundColor: Colors.pink,
        tooltip: 'Créer une playlist',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPlaylistList(List<Playlist> playlists) {
    return playlists.isEmpty
        ? const Center(child: Text('Aucune playlist pour le moment'))
        : ListView.builder(
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.library_music, color: Colors.pink),
                  title: Text(playlist.nom),
                  subtitle: Text(
                    '${playlist.songs.length} chanson${playlist.songs.length > 1 ? 's' : ''}',
                  ),
                ),
              );
            },
          );
  }
}
