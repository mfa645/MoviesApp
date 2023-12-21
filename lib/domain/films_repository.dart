import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';

abstract class FilmsRepository {
  Future<FilmResponse> getFilms(int? selectedGenre, int page);

  Future<FilmResponse> getWeekTrendingFilms();

  Future<FilmResponse> getTopRatedFilms();

  Future<FilmResponse> getUpcomingFilms();

  Future<FilmResponse> getFilmsByTitle(String title, int page);

  Future<Film> getFilmDetails(int filmId);

  Future<List<Genre>> getFilmGenres();

  Future addFilmToFavourites(Film film);
  Future removeFilmFromFavourites(int filmId);
  Future<List<Film>> getFavouriteFilms();

  Future<bool> getIsFavouriteFilm(int filmId);
}
