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

  final StreamController<FilmResponseState> getUpcomingFilmsResponseState =
      StreamController();

  final StreamController<FilmResponseState> getTopRatedFilmsResponseState =
      StreamController();

  final StreamController<FilmResponseState> getWeekTrendingFilmsResponseState =
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

  fetchFilms() {
    getFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getFilms()
        .then((value) => getFilmsState.add(ResourceState.success(value)))
        .catchError((error) => getFilmsState.add(ResourceState.error(error)));
  }

  fetchUpcomingFilms() {
    getUpcomingFilmsResponseState.add(ResourceState.loading());

    _filmsRepository
        .getUpcomingFilms()
        .then((value) =>
            getUpcomingFilmsResponseState.add(ResourceState.success(value)))
        .catchError((error) =>
            getUpcomingFilmsResponseState.add(ResourceState.error(error)));
  }

  fetchWeekTrendingFilms() {
    getWeekTrendingFilmsResponseState.add(ResourceState.loading());

    _filmsRepository
        .getWeekTrendingFilms()
        .then((value) =>
            getWeekTrendingFilmsResponseState.add(ResourceState.success(value)))
        .catchError((error) =>
            getWeekTrendingFilmsResponseState.add(ResourceState.error(error)));
  }

  fetchTopRatedFilms() {
    getTopRatedFilmsResponseState.add(ResourceState.loading());

    _filmsRepository
        .getTopRatedFilms()
        .then((value) =>
            getTopRatedFilmsResponseState.add(ResourceState.success(value)))
        .catchError((error) =>
            getTopRatedFilmsResponseState.add(ResourceState.error(error)));
  }

  fetchFilmsByTitle(String title) {
    getFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getFilmsByTitle(title)
        .then((value) => getFilmsState.add(ResourceState.success(value)))
        .catchError((error) => getFilmsState.add(ResourceState.error(error)));
  }

  fetchFilmDetails(int id) {
    getFilmsState.add(ResourceState.loading());

    _filmsRepository
        .getFilmDetails(id)
        .then((value) => getFilmDetailState.add(ResourceState.success(value)))
        .catchError((error) => getFilmsState.add(ResourceState.error(error)));
  }

  fetchHomeFilms() {
    fetchTopRatedFilms();
    fetchUpcomingFilms();
    fetchWeekTrendingFilms();
  }

  @override
  void dispose() {
    getFilmDetailState.close();
    getFilmGenresState.close();
    getFilmsState.close();
  }
}
