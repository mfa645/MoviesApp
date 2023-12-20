import 'dart:convert';

import 'package:movies_app/model/film.dart';
import 'package:sqflite/sqflite.dart';

class FilmsLocalImpl {
  static const String filmsTable = "films";
  static const String genresTable = "genres";
  static const String companiesTable = "companies";
  Database? _db;

  FilmsLocalImpl();

  Future<List<Film>> getFavouriteFilms() async {
    Database db = await _getDb();

    final films = await db.query(FilmsLocalImpl.filmsTable);
    var favouriteFilms = films.map((e) {
      return Film.fromMap(e);
    });

    await closeDb();

    return favouriteFilms.toList();
  }

  Future removeFilmFromFavourites(int filmId) async {
    Database db = await _getDb();

    await db.delete(
      FilmsLocalImpl.filmsTable,
      where: 'id = ?',
      whereArgs: [filmId],
    );

    await closeDb();
  }

  Future addFilmToFavourites(Film film) async {
    Database db = await _getDb();

    await db.insert(FilmsLocalImpl.filmsTable, film.toMap());

    await closeDb();
  }

  Future<Database> _getDb() async {
    if (_db == null || !_db!.isOpen) {
      _db = await openDatabase('films_list.db', version: 1);
    }

    await _createTables(_db!);

    return _db!;
  }

  closeDb() async {
    if (_db != null && _db!.isOpen) {
      await _db!.close();
    }
  }

  _createTables(Database db) async {
    db.execute(
        "CREATE TABLE IF NOT EXISTS $filmsTable (id INTEGER PRIMARY KEY, adult INTEGER, backdropPath TEXT, originalLanguage TEXT, originalTitle TEXT,  budget INTEGER, overview TEXT, popularity DOUBLE, posterPath TEXT, releaseDate TEXT, runtime INTEGER, status TEXT, tagline TEXT, title TEXT, voteAverage DOUBLE, genres TEXT, productionCompanies TEXT)");
  }

  Future<bool> getIsFavouriteFilm(int filmId) async {
    Database db = await _getDb();

    final films = await db.query(FilmsLocalImpl.filmsTable);
    final favouriteFilms = films.map((film) {
      var jsonMap =
          json.decode(film['genres'] as String) as Map<String, dynamic>;
      return Film.fromMap(jsonMap);
    });

    await closeDb();

    return favouriteFilms.toList().any((element) => element.id == filmId);
  }
}
