import 'package:movies_app/model/genre.dart';

class FilmResponse {
  int page;
  List<Film> results;
  int totalPages;
  int totalResults;

  FilmResponse({
    required this.page,
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  factory FilmResponse.fromJson(Map<String, dynamic> json) => FilmResponse(
        page: json["page"],
        results: List<Film>.from(json["results"].map((x) => Film.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "results": List<dynamic>.from(results.map((x) => x.toMap())),
        "total_pages": totalPages,
        "total_results": totalResults,
      };
}

class Film {
  bool? adult;
  String? backdropPath;
  int? budget;
  List<Genre>? genres;
  int id;
  String originalLanguage;
  String originalTitle;
  String overview;
  double popularity;
  String? posterPath;
  DateTime releaseDate;
  int? runtime;
  String? status;
  String? tagline;
  String title;
  double voteAverage;
  int voteCount;

  Film({
    required this.adult,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.runtime,
    required this.posterPath,
    required this.status,
    required this.tagline,
    required this.title,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Film.fromMap(Map<String, dynamic> json) => Film(
        adult: json["adult"] ? null : json["adult"],
        backdropPath: json["backdrop_path"],
        budget: json["budget"],
        genres: json["genres"] != null
            ? List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x)))
            : null,
        id: json["id"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: DateTime.parse(json["release_date"]),
        runtime: json["runtime"],
        status: json["status"],
        tagline: json["tagline"],
        title: json["title"],
        voteAverage: json["vote_average"] + 0.0,
        voteCount: json["vote_count"],
      );

  Map<String, dynamic> toMap() => {
        "adult": adult ?? false,
        "backdrop_path": backdropPath,
        "budget": budget,
        "genres": genres != null
            ? List<dynamic>.from(genres!.map((x) => x.toJson()))
            : null,
        "id": id,
        "original_language": originalLanguage,
        "original_title": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "release_date":
            "${releaseDate.year.toString().padLeft(4, '0')}-${releaseDate.month.toString().padLeft(2, '0')}-${releaseDate.day.toString().padLeft(2, '0')}",
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "vote_average": voteAverage,
        "vote_count": voteCount,
      };
}
