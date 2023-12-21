import 'package:movies_app/data/film/local/films_local_impl.dart';
import 'package:movies_app/data/film/remote/films_remote_impl.dart';
import 'package:movies_app/domain/films_repository.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';

class FilmsDataImpl extends FilmsRepository {
  final FilmsRemoteImpl _remoteImpl;
  final FilmsLocalImpl _localImpl;

  FilmsDataImpl(
      {required FilmsRemoteImpl remoteImpl, required FilmsLocalImpl localImpl})
      : _remoteImpl = remoteImpl,
        _localImpl = localImpl;

  @override
  Future<Film> getFilmDetails(int filmId) {
    return _remoteImpl.getFilmDetails(filmId);
  }

  @override
  Future<List<Genre>> getFilmGenres() {
    return _remoteImpl.getFilmGenres();
  }

  @override
  Future<FilmResponse> getFilms(int? selectedGenre, int page) {
    return _remoteImpl.getFilms(selectedGenre, page);
  }

  @override
  Future<FilmResponse> getFilmsByTitle(String title, int page) {
    return _remoteImpl.getFilmsByTitle(title, page);
  }

  @override
  Future<FilmResponse> getTopRatedFilms() {
    return _remoteImpl.getTopRatedFilms();
  }

  @override
  Future<FilmResponse> getUpcomingFilms() {
    return _remoteImpl.getUpcomingFilms();
  }

  @override
  Future<FilmResponse> getWeekTrendingFilms() {
    return _remoteImpl.getWeekTrendingFilms();
  }

  @override
  Future addFilmToFavourites(Film film) {
    return _localImpl.addFilmToFavourites(film);
  }

  @override
  Future<List<Film>> getFavouriteFilms() {
    return _localImpl.getFavouriteFilms();
  }

  @override
  Future removeFilmFromFavourites(int filmId) {
    return _localImpl.removeFilmFromFavourites(filmId);
  }

  @override
  Future<bool> getIsFavouriteFilm(int filmId) {
    return _localImpl.getIsFavouriteFilm(filmId);
  }
}
