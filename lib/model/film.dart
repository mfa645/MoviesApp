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
  List<ProductionCompany>? productionCompanies;
  String overview;
  double popularity;
  String? posterPath;
  String releaseDate;
  int? runtime;
  String? status;
  String? tagline;
  String title;
  double voteAverage;

  Film({
    required this.adult,
    required this.backdropPath,
    required this.budget,
    required this.genres,
    required this.id,
    required this.originalLanguage,
    required this.originalTitle,
    required this.productionCompanies,
    required this.overview,
    required this.popularity,
    required this.releaseDate,
    required this.runtime,
    required this.posterPath,
    required this.status,
    required this.tagline,
    required this.title,
    required this.voteAverage,
  });

  factory Film.fromMap(Map<String, dynamic> filmJson) => Film(
        adult: filmJson["adult"] is int
            ? filmJson["adult"] == 1
                ? true
                : false
            : filmJson["adult"],
        backdropPath: filmJson["backdrop_path"],
        budget: filmJson["budget"],
        genres: filmJson["genres"] != null
            ? List<Genre>.from(
                (filmJson["genres"]).map((x) => Genre.fromJson(x)))
            : null,
        productionCompanies: filmJson["production_companies"] != null
            ? List<ProductionCompany>.from(filmJson["production_companies"]
                .map((x) => ProductionCompany.fromJson(x)))
            : null,
        id: filmJson["id"],
        originalLanguage: filmJson["original_language"],
        originalTitle: filmJson["original_title"],
        overview: filmJson["overview"],
        popularity: filmJson["popularity"]?.toDouble(),
        posterPath: filmJson["poster_path"],
        releaseDate: filmJson["release_date"],
        runtime: filmJson["runtime"],
        status: filmJson["status"],
        tagline: filmJson["tagline"],
        title: filmJson["title"],
        voteAverage: filmJson["vote_average"] + 0.0,
      );

  Map<String, dynamic> toMap() => {
        "adult": adult == null
            ? adult!
                ? 1
                : 0
            : null,
        "backdropPath": backdropPath,
        "budget": budget,
        "genres": genres != null
            ? List<dynamic>.from(genres!.map((x) => x.toJson())).toString()
            : null,
        "productionCompanies": productionCompanies != null
            ? List<dynamic>.from(productionCompanies!.map((x) => x.toJson()))
                .toString()
            : null,
        "id": id,
        "originalLanguage": originalLanguage,
        "originalTitle": originalTitle,
        "overview": overview,
        "popularity": popularity,
        "posterPath": posterPath,
        "releaseDate": releaseDate,
        "runtime": runtime,
        "status": status,
        "tagline": tagline,
        "title": title,
        "voteAverage": voteAverage,
      };
}

class ProductionCompany {
  int id;
  String? logoPath;
  String name;
  String originCountry;

  ProductionCompany({
    required this.id,
    required this.logoPath,
    required this.name,
    required this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) =>
      ProductionCompany(
        id: json["id"],
        logoPath: json["logo_path"],
        name: json["name"],
        originCountry: json["origin_country"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "logo_path": logoPath,
        "name": name,
        "origin_country": originCountry,
      };
}
