import 'package:get_it/get_it.dart';
import 'package:movies_app/data/film/films_data_impl.dart';
import 'package:movies_app/data/film/local/films_local_impl.dart';
import 'package:movies_app/data/film/remote/films_remote_impl.dart';
import 'package:movies_app/data/remote/network_client.dart';
import 'package:movies_app/domain/films_repository.dart';
import 'package:movies_app/presentation/provider/favourite_films_provider.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';

final inject = GetIt.instance;

class AppModules {
  setup() {
    _setupMainModule();
    _setupFilmModule();
  }

  _setupMainModule() {
    inject.registerSingleton(NetworkClient());
    inject.registerSingleton(FavouriteFilmProvider());
  }

  _setupFilmModule() {
    inject.registerFactory(() => FilmsRemoteImpl(networkClient: inject.get()));
    inject.registerFactory(() => FilmsLocalImpl());
    inject.registerFactory<FilmsRepository>(
        () => FilmsDataImpl(remoteImpl: inject.get(), localImpl: inject.get()));
    inject.registerFactory(() => FilmsViewModel(filmsRepository: inject.get()));
  }
}
