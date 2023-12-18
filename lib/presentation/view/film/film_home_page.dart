import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';

class FilmHomePage extends StatefulWidget {
  const FilmHomePage({super.key});

  @override
  State<FilmHomePage> createState() => _FilmHomePageState();
}

class _FilmHomePageState extends State<FilmHomePage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();
  List<Film> _upcomingFilms = [];
  final List<Film> _topRatedFilms = [];
  final List<Film> _weekTrendingFilms = [];

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
            _upcomingFilms = state.data!.results;
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

    _filmsViewModel.fetchFilms();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
