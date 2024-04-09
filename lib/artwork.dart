class Artwork {
  final int? id;
  final String title;
  final String imageUrl;
  final String artistName;

  Artwork({
    this.id,
    required this.title,
    required this.imageUrl,
    required this.artistName,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'artistName': artistName,
    };
  }

  factory Artwork.fromMap(Map<String, dynamic> map) {
    return Artwork(
      id: map['id'] as int?,
      title: map['title'],
      imageUrl: map['imageUrl'],
      artistName: map['artistName'],
    );
  }
}
