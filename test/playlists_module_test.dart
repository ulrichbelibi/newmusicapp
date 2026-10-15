import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmusicapp/models/songdata.dart';
import 'package:newmusicapp/pages/playlists/playlists_page.dart';
import 'package:newmusicapp/services/playlists_manager.dart';

void main() {
  setUp(() {
    PlaylistsManager.playlists.clear();
  });

  test('creates a named playlist and adds a song only once', () {
    PlaylistsManager.createPlaylist('  Favoris jazz  ');

    final playlist = PlaylistsManager.playlists.single;
    expect(playlist.nom, 'Favoris jazz');
    expect(playlist.songs, isEmpty);

    PlaylistsManager.addSongToPlaylist(playlist.id, localSongs.first);
    PlaylistsManager.addSongToPlaylist(playlist.id, localSongs.first);

    expect(playlist.songs, [localSongs.first]);
  });

  test('ignores blank names and unknown playlist ids', () {
    PlaylistsManager.createPlaylist('  ');
    PlaylistsManager.addSongToPlaylist('unknown', localSongs.first);

    expect(PlaylistsManager.playlists, isEmpty);
  });

  testWidgets('creates a playlist from the page dialog', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: PlaylistsPage()),
    );

    expect(find.text('Aucune playlist pour le moment'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Ma playlist');
    await tester.tap(find.text('Créer'));
    await tester.pumpAndSettle();

    expect(find.text('Ma playlist'), findsOneWidget);
    expect(find.text('0 chanson'), findsOneWidget);
    expect(find.text('Aucune playlist pour le moment'), findsNothing);
  });
}
