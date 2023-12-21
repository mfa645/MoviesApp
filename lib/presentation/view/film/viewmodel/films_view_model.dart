import 'dart:async';

import 'package:movies_app/domain/films_repository.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/presentation/base/base_view_model.dart';
import 'package:movies_app/presentation/model/resource_state.dart';

typedef FilmResponseState = ResourceState<FilmResponse>;

class FilmsViewModel extends BaseViewModel {
  final FilmsRepository _filmsRepository;

  final StreamController<ResourceState<List<Genre>>> getFilmGenresState =
      StreamController();

  final StreamController<ResourceState<Film>> getFilmDetailState =
      StreamController();

  final StreamController<FilmResponseState> getFilmsState = StreamController();

  final StreamController<ResourceState<List<Film>>> getFavouriteFilms =
      StreamController();

  final StreamController<ResourceState<bool>> getIsFavouriteFilm =
      StreamController();

  final StreamController<FilmResponseState> getUpcomingFilmsState =
      StreamController();
  final StreamController<FilmResponseState> getTopRatedFilmsState =
      StreamController();
  final StreamController<FilmResponseState> getWeekTrendingFilmsState =
      StreamController();

  FilmsViewModel({required FilmsRepository filmsRepository})
      : _filmsRepository = filmsRepository;

  fetchFilmGenres() {
    getFilmGenresState.add(ResourceState.loading());

    _filmsRepository
        .getFilmGenres()
        .then((value) => getFilmGenresState.add(ResourceState.success(value)))
        .catchError(
            (error) => getFilmGenresState.add(ResourceState.error(error)));
  }

  fetchFilms(int? selectedGenre, int page) {
    getFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getFilms(selectedGenre, page)
        .then((value) => getFilmsState.add(ResourceState.success(value)))
        .catchError((error) => getFilmsState.add(ResourceState.error(error)));
  }

  fetchTopRatedFilms() {
    getTopRatedFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getTopRatedFilms()
        .then(
            (value) => getTopRatedFilmsState.add(ResourceState.success(value)))
        .catchError(
            (error) => getTopRatedFilmsState.add(ResourceState.error(error)));
  }

  fetchFavouriteFilms() {
    getFavouriteFilms.add(ResourceState.loading());

    _filmsRepository
        .getFavouriteFilms()
        .then((value) => getFavouriteFilms.add(ResourceState.success(value)))
        .catchError(
            (error) => getFavouriteFilms.add(ResourceState.error(error)));
  }

  removeFilmFromFavourites(int id) async {
    await _filmsRepository.removeFilmFromFavourites(id);
    fetchIsFavouriteFilm(id);
  }

  addFilmToFavourites(Film film) async {
    await _filmsRepository.addFilmToFavourites(film);
    fetchIsFavouriteFilm(film.id);
  }

  fetchIsFavouriteFilm(int filmId) {
    _filmsRepository
        .getIsFavouriteFilm(filmId)
        .then((value) => getIsFavouriteFilm.add(ResourceState.success(value)))
        .catchError(
            (error) => getIsFavouriteFilm.add(ResourceState.error(error)));
  }

  fetchWeekTrendingFilms() {
    getWeekTrendingFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getWeekTrendingFilms()
        .then((value) =>
            getWeekTrendingFilmsState.add(ResourceState.success(value)))
        .catchError((error) =>
            getWeekTrendingFilmsState.add(ResourceState.error(error)));
  }

  fetchUpcomingFilms() {
    getUpcomingFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getUpcomingFilms()
        .then(
            (value) => getUpcomingFilmsState.add(ResourceState.success(value)))
        .catchError(
            (error) => getUpcomingFilmsState.add(ResourceState.error(error)));
  }

  fetchFilmsByTitle(String title, int page) {
    getFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getFilmsByTitle(title, page)
        .then((value) => getFilmsState.add(ResourceState.success(value)))
        .catchError((error) => getFilmsState.add(ResourceState.error(error)));
  }

  fetchFilmDetails(int id) {
    getFilmDetailState.add(ResourceState.loading());

    _filmsRepository
        .getFilmDetails(id)
        .then((value) => getFilmDetailState.add(ResourceState.success(value)))
        .catchError((error) => getFilmsState.add(ResourceState.error(error)));
  }

  @override
  void dispose() {
    getFilmDetailState.close();
    getFilmGenresState.close();
    getUpcomingFilmsState.close();
    getTopRatedFilmsState.close();
    getWeekTrendingFilmsState.close();
    getFilmsState.close();
    getFavouriteFilms.close();
    getIsFavouriteFilm.close();
  }
}
