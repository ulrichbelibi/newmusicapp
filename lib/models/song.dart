class Song {
  final String id;
  final String titre;
  final String artiste;
  final String imageUrl;
  final String audioUrl;
  final Duration duree;

  Song({
    required this.id,
    required this.titre,
    required this.artiste,
    required this.imageUrl,
    required this.audioUrl,
    required this.duree,
  });

  factory Song.fromFirestore(String documentId, Map<String, dynamic> data) {
    String requiredString(String field) {
      final value = data[field];
      if (value is! String || value.trim().isEmpty) {
        throw FormatException(
          'Le champ "$field" est absent ou invalide dans le document "$documentId".',
        );
      }
      return value;
    }

    final duration = data['dureeSeconds'];
    if (duration is! num || duration < 0 || duration % 1 != 0) {
      throw FormatException(
        'Le champ "dureeSeconds" est absent ou invalide dans le document "$documentId".',
      );
    }

    return Song(
      id: documentId,
      titre: requiredString('titre'),
      artiste: requiredString('artiste'),
      imageUrl: requiredString('imageUrl'),
      audioUrl: requiredString('audioUrl'),
      duree: Duration(seconds: duration.toInt()),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'id': id,
    'titre': titre,
    'artiste': artiste,
    'imageUrl': imageUrl,
    'audioUrl': audioUrl,
    'dureeSeconds': duree.inSeconds,
  };
}
