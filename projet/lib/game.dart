class Game {
  final String id;
  final String name;
  final String released;
  final double rating;
  final List<String> genres;
  final String backgroundImage;
  final String description;

  Game({
    required this.id,
    required this.name,
    required this.released,
    required this.rating,
    required this.genres,
    required this.backgroundImage,
    required this.description,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'].toString(),
      name: json['name'],
      released: json['released'] ?? 'Unknown',
      rating: (json['rating'] as num).toDouble(),
      genres: (json['genres'] as List)
          .map((genre) => genre['name'] as String)
          .toList(),
      backgroundImage: json['background_image'] ?? '',
      description: json['description_raw'] ?? 'No description available',
    );
  }
}
