import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';

abstract class FilmsRepository {
  Future<FilmResponse> getFilms();

  Future<FilmResponse> getWeekTrendingFilms();

  Future<FilmResponse> getTopRatedFilms();

  Future<FilmResponse> getUpcomingFilms();

  Future<FilmResponse> getFilmsByTitle(String title);

  Future<Film> getFilmDetails(int filmId);

  Future<List<Genre>> getFilmGenres();
}
