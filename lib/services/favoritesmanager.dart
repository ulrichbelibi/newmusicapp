import '../models/song.dart';

class FavoritesManager {
  static List<Song> favorites = [];

 static void add(Song song) {
  if (!isFavorite(song)) {
    favorites.add(song);
  }
}
 static void remove(Song song) {
  favorites.removeWhere((s) => s.id == song.id);
}
 static bool isFavorite(Song song) {
  return favorites.any((s) => s.id == song.id);
}
}