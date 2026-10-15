import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newmusicapp/models/songdata.dart';
import 'package:newmusicapp/pages/favorites_page.dart';
import 'package:newmusicapp/services/favoritesmanager.dart';

void main() {
  setUp(() {
    FavoritesManager.favorites.clear();
  });

  testWidgets('retirer le dernier favori affiche le message de liste vide', (
    tester,
  ) async {
    FavoritesManager.add(localSongs.first);

    await tester.pumpWidget(const MaterialApp(home: FavoritesPage()));

    expect(find.text(localSongs.first.titre), findsOneWidget);

    await tester.tap(find.byIcon(Icons.favorite));
    await tester.pumpAndSettle();

    expect(find.text(localSongs.first.titre), findsNothing);
    expect(find.text('Aucun favori pour le moment'), findsOneWidget);
  });
}
