import 'package:movies_app/data/film/local/films_local_impl.dart';
import 'package:movies_app/data/film/remote/films_remote_impl.dart';
import 'package:movies_app/domain/films_repository.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';

class FilmsDataImpl extends FilmsRepository {
  final FilmsRemoteImpl _remoteImpl;
  // ignore: unused_field
  final FilmsLocalImpl _filmsLocalImpl;

  FilmsDataImpl(
      {required FilmsRemoteImpl remoteImpl, required FilmsLocalImpl localImpl})
      : _remoteImpl = remoteImpl,
        _filmsLocalImpl = localImpl;

  @override
  Future<Film> getFilmDetails(int filmId) {
    return _remoteImpl.getFilmDetails(filmId);
  }

  @override
  Future<List<Genre>> getFilmGenres() {
    return _remoteImpl.getFilmGenres();
  }

  @override
  Future<FilmResponse> getFilms(int? selectedGenre) {
    return _remoteImpl.getFilms(selectedGenre);
  }

  @override
  Future<FilmResponse> getFilmsByTitle(String title) {
    return _remoteImpl.getFilmsByTitle(title);
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
}
