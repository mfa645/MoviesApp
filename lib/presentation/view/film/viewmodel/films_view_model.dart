import 'dart:async';

import 'package:movies_app/domain/films_repository.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/presentation/base/base_view_model.dart';
import 'package:movies_app/presentation/model/resource_state.dart';

class FilmsViewModel extends BaseViewModel {
  final FilmsRepository _filmsRepository;

  final StreamController<ResourceState<List<Genre>>> getFilmGenresState =
      StreamController();

  final StreamController<ResourceState<Film>> getFilmDetailState =
      StreamController();

  final StreamController<ResourceState<FilmResponse>> getFilmsState =
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

  @override
  void dispose() {
    getFilmDetailState.close();
    getFilmGenresState.close();
    getFilmsState.close();
  }
}
