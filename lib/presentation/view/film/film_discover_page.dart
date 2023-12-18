import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';

class FilmsDiscoverPage extends StatefulWidget {
  const FilmsDiscoverPage({super.key});

  @override
  State<FilmsDiscoverPage> createState() => _FilmsDiscoverPageState();
}

class _FilmsDiscoverPageState extends State<FilmsDiscoverPage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();
  List<Film> _films = [];
  List<Genre> _genres = [];

  @override
  void initState() {
    super.initState();

    _filmsViewModel.getFilmsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _films = state.data!.results;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchFilms();
          });
          break;
      }
    });

    _filmsViewModel.getFilmGenresState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _genres = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchFilmGenres();
          });
          break;
      }
    });

    _filmsViewModel.fetchFilms();
    _filmsViewModel.fetchFilmGenres();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Films"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _genres.length,
          itemBuilder: (_, index) {
            final genre = _genres[index];
            return ListTile(
              title: Text(genre.name),
            );
          },
        ),
      ),
    );
  }
}
