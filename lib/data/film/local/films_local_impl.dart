import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/model/production_company.dart';
import 'package:sqflite/sqflite.dart';

class FilmsLocalImpl {
  static const String filmsTable = "films";
  static const String genresTable = "genres";
  static const String companiesTable = "companies";
  Database? _db;

  FilmsLocalImpl();

  Future<List<Film>> getFavouriteFilms() async {
    Database db = await _getDb();
    //Collect films, genres and production companies
    final filmsData = await db.query(FilmsLocalImpl.filmsTable);
    final genresData = await db.query(FilmsLocalImpl.genresTable);
    final productionCompaniesData =
        await db.query(FilmsLocalImpl.companiesTable);

    //Decode entities
    var favouriteFilms = filmsData.map((e) {
      return Film.fromDBMap(e);
    });
    var favouriteGenres = genresData.map((e) {
      return Genre.fromDBMap(e);
    });
    var favouriteProductionCompanies = productionCompaniesData.map((e) {
      return ProductionCompany.fromDBMap(e);
    });
    await closeDb();

    //Mix films with their genres and companies
    return favouriteFilms.map((film) {
      final filmGenres = favouriteGenres
          .where((element) => element.filmForeignKey == film.id)
          .toList();
      final filmProductionCompanies = favouriteProductionCompanies
          .where((element) => element.filmForeignKey == film.id)
          .toList();
      return Film.convertFromDatabase(
          film, filmGenres, filmProductionCompanies);
    }).toList();
  }

  Future removeFilmFromFavourites(int filmId) async {
    Database db = await _getDb();

    await db.delete(
      FilmsLocalImpl.filmsTable,
      where: 'id = ?',
      whereArgs: [filmId],
    );
    await db.delete(
      FilmsLocalImpl.genresTable,
      where: 'filmForeignKey = ?',
      whereArgs: [filmId],
    );
    await db.delete(
      FilmsLocalImpl.companiesTable,
      where: 'filmForeignKey = ?',
      whereArgs: [filmId],
    );
    await closeDb();
  }

  Future addFilmToFavourites(Film film) async {
    Database db = await _getDb();
    await db.insert(FilmsLocalImpl.filmsTable, film.toMap());
    if (film.genres != null) {
      for (var genre in film.genres!) {
        await db.insert(FilmsLocalImpl.genresTable, genre.toDBMap(film.id));
      }
    }
    if (film.productionCompanies != null) {
      for (var productionCompany in film.productionCompanies!) {
        await db.insert(
            FilmsLocalImpl.companiesTable, productionCompany.toDBMap(film.id));
      }
    }
    await closeDb();
  }

  Future<bool> getIsFavouriteFilm(int filmId) async {
    Database db = await _getDb();

    final filmsData = await db.query(FilmsLocalImpl.filmsTable);
    var favouriteFilms = filmsData.map((e) {
      return Film.fromDBMap(e);
    });

    await closeDb();

    return favouriteFilms.toList().any((element) => element.id == filmId);
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
    db.execute(
        "CREATE TABLE IF NOT EXISTS $genresTable (id INTEGER, name TEXT, filmForeignKey INTEGER, PRIMARY KEY (id, filmForeignKey))");
    db.execute(
        "CREATE TABLE IF NOT EXISTS $companiesTable (id INTEGER, name TEXT, logoPath TEXT, originCountry TEXT, filmForeignKey INTEGER, PRIMARY KEY (id, filmForeignKey))");
  }
}
