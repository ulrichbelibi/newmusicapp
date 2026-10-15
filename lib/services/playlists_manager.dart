import '../models/playlist.dart';
import '../models/song.dart';

class PlaylistsManager {
  static List<Playlist> playlists = [];

  static void createPlaylist(String nom) {
    final title = nom.trim();
    if (title.isEmpty) {
      return;
    }

    playlists.add(
      Playlist(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nom: title,
        songs: [],
      ),
    );
  }

  static void addSongToPlaylist(String playlistId, Song song) {
    final index = playlists.indexWhere((playlist) => playlist.id == playlistId);
    if (index == -1) {
      return;
    }

    final playlist = playlists[index];
    if (!playlist.songs.any((item) => item.id == song.id)) {
      playlist.songs.add(song);
    }
  }
}
