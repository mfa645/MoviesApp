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

  fetchFilms(int? selectedGenre) {
    getFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getFilms(selectedGenre)
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

  fetchFilmsByTitle(String title) {
    getFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getFilmsByTitle(title)
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
  }
}
