import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/navigation/navigation_routes.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/film/film_list_row.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';

class FilmFavouritesPage extends StatefulWidget {
  const FilmFavouritesPage({Key? key}) : super(key: key);
  @override
  State<FilmFavouritesPage> createState() => _FilmFavouritesPageState();
}

final GlobalKey<_FilmFavouritesPageState> myStreamPageKey =
    GlobalKey<_FilmFavouritesPageState>();

class _FilmFavouritesPageState extends State<FilmFavouritesPage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();

  List<Film> _films = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _filmsViewModel.getFavouriteFilms.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _films = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchFavouriteFilms();
          });
          break;
      }
    });
    _filmsViewModel.fetchFavouriteFilms();
  }

  void resetState() {
    _filmsViewModel.fetchFavouriteFilms();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _filmsViewModel.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text("Favourites",
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  Icon(
                    Icons.star,
                    size: 40,
                    color: Colors.yellowAccent,
                  ),
                  Icon(
                    Icons.movie,
                    size: 40,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _films.length,
                itemBuilder: (_, index) {
                  final film = _films[index];
                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Dismissible(
                          key: Key(film.id.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ],
                            ),
                          ),
                          onDismissed: (_) {
                            _filmsViewModel.removeFilmFromFavourites(film.id);
                          },
                          child: FilmListRow(
                            film: film,
                            route:
                                NavigationRoutes.FILM_FAVOURITES_DETAIL_ROUTE,
                          )));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
