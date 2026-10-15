import 'song.dart';

class Playlist {
  final String id;
  final String nom;
  final List<Song> songs;

  Playlist({
    required this.id,
    required this.nom,
    required this.songs,
  });
}