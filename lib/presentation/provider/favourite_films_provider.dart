import 'package:flutter/material.dart';
import 'package:movies_app/model/film.dart';

class FavouriteFilmProvider extends ChangeNotifier {
  List<Film> _films = [];
  bool _isFavourite = false;

  void updateFavouriteFilms(List<Film> films) {
    _films = films;
    notifyListeners();
  }

  void updateFilmRemovedFromFavourites(int id) {
    _films.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void updateFilmAddedToFavourites(Film film) {
    _films.add(film);
    notifyListeners();
  }

  void updateIsFavouriteFilm(bool isFavouriteFilm) {
    _isFavourite = isFavouriteFilm;
    notifyListeners();
  }

  List<Film> get favouritesFilmList => _films;
  bool get isFavouriteFilm => _isFavourite;
}
