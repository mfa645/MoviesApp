import 'package:movies_app/data/remote/error/remote_error_mapper.dart';
import 'package:movies_app/data/remote/network_client.dart';
import 'package:movies_app/data/remote/network_constants.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';

class FilmsRemoteImpl {
  final NetworkClient _networkClient;
  final Map<String, String> apiKey = {
    "api_key": "61becde29835d009c9dafbe82839fd83"
  };

  FilmsRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<FilmResponse> getRequestResponseFilms(String path) async {
    try {
      final response =
          await _networkClient.dio.get(path, queryParameters: apiKey);

      final filmsResponse = FilmResponse.fromJson(response.data);

      return filmsResponse;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<FilmResponse> getFilms(int? selectedGenre, int page) async {
    final Map<String, dynamic> searchQueryParams = {
      "page": page,
      "with_genres": selectedGenre
    };
    searchQueryParams.addAll(apiKey);
    try {
      final response = await _networkClient.dio.get(
          NetworkConstants.DISCOVER_FILMS_PATH,
          queryParameters: searchQueryParams);
      final filmsResponse = FilmResponse.fromJson(response.data);
      return filmsResponse;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<FilmResponse> getWeekTrendingFilms() async {
    return getRequestResponseFilms(NetworkConstants.WEEK_TRENDING_FILMS_PATH);
  }

  Future<FilmResponse> getTopRatedFilms() async {
    return getRequestResponseFilms(NetworkConstants.TOP_RATED_FILMS_PATH);
  }

  Future<FilmResponse> getUpcomingFilms() async {
    return getRequestResponseFilms(NetworkConstants.UPCOMING_FILMS_PATH);
  }

  Future<FilmResponse> getFilmsByTitle(String title, int page) async {
    final Map<String, dynamic> searchQueryParams = {
      "query": title,
      "page": page
    };
    searchQueryParams.addAll(apiKey);
    try {
      final response = await _networkClient.dio.get(
          NetworkConstants.SEARCH_FILMS_PATH,
          queryParameters: searchQueryParams);
      final filmsResponse = FilmResponse.fromJson(response.data);
      return filmsResponse;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<Film> getFilmDetails(int filmId) async {
    try {
      final response = await _networkClient.dio.get(
          "${NetworkConstants.FILMS_PATH}/$filmId",
          queryParameters: apiKey);
      final film = Film.fromMap(response.data);
      return film;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<List<Genre>> getFilmGenres() async {
    try {
      final response = await _networkClient.dio
          .get(NetworkConstants.GENRES_PATH, queryParameters: apiKey);

      final genres = GenreResponse.fromJson(response.data).genres;

      return genres;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}
