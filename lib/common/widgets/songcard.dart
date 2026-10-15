import "package:flutter/material.dart";
import '../../models/song.dart';
import '../../pages/home/songpage.dart';
import "../../services/favoritesmanager.dart";

class SongCard extends StatelessWidget {
  final Song song;
  final bool? isFavorite;
  final VoidCallback? onFavoriteToggle;
  final Future<void> Function()? onFavoriteToggleRemote;

  const SongCard({
    super.key,
    required this.song,
    this.isFavorite,
    this.onFavoriteToggle,
    this.onFavoriteToggleRemote,
  });

  @override
  Widget build(BuildContext context) {
    final favorite = isFavorite ?? FavoritesManager.isFavorite(song);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SongPage(song: song)),
        );
      },

      child: Card(
        color: const Color.fromARGB(255, 250, 236, 210),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(song.imageUrl, width: 60, height: 60),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.titre,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.pink,
                      fontFamily: "tahoma",
                    ),
                  ),
                  Text(
                    song.artiste,
                    style: TextStyle(
                      fontFamily: "times new roman",
                      color: const Color.fromARGB(255, 47, 46, 46),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                favorite ? Icons.favorite : Icons.favorite_border,
                color: favorite ? Colors.pink : Colors.grey,
              ),
              onPressed: () async {
                if (onFavoriteToggleRemote != null) {
                  await onFavoriteToggleRemote!();
                  return;
                }
                if (FavoritesManager.isFavorite(song)) {
                  FavoritesManager.remove(song);
                } else {
                  FavoritesManager.add(song);
                }
                onFavoriteToggle?.call();
              },
            ),
          ],
        ),
      ),
    );
  }
}
