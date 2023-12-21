class GenreResponse {
  List<Genre> genres;

  GenreResponse({
    required this.genres,
  });

  factory GenreResponse.fromJson(Map<String, dynamic> json) => GenreResponse(
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
      );
}

class Genre {
  int id;
  String name;
  int? filmForeignKey;

  Genre({
    required this.id,
    required this.name,
    required this.filmForeignKey,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
      id: json["id"],
      name: json["name"],
      filmForeignKey: json["filmForeignKey"]);

  factory Genre.fromDBMap(Map<String, dynamic> json) => Genre(
      id: json["id"],
      name: json["name"],
      filmForeignKey: json["filmForeignKey"]);

  Map<String, dynamic> toDBMap(int filmId) =>
      {"id": id, "name": name, "filmForeignKey": filmForeignKey};
}
