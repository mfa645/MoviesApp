import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/navigation/navigation_routes.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/film/film_horizontal_list.dart';
import 'package:movies_app/presentation/widget/film/upcoming_films_horizontal_list.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';

class FilmsHomePage extends StatefulWidget {
  const FilmsHomePage({super.key});

  @override
  State<FilmsHomePage> createState() => _FilmsHomePageState();
}

class _FilmsHomePageState extends State<FilmsHomePage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();
  List<Film> _upcomingFilms = [];
  List<Film> _topRatedFilms = [];
  List<Film> _weekTrendingFilms = [];

  @override
  void dispose() {
    super.dispose();
    _filmsViewModel.dispose();
  }

  @override
  void initState() {
    super.initState();

    _filmsViewModel.getWeekTrendingFilmsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _weekTrendingFilms = state.data!.results;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchWeekTrendingFilms();
          });
          break;
      }
    });
    _filmsViewModel.getUpcomingFilmsState.stream.listen((state) {
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
            _filmsViewModel.fetchUpcomingFilms();
          });
          break;
      }
    });
    _filmsViewModel.getTopRatedFilmsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _topRatedFilms = state.data!.results;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchTopRatedFilms();
          });
          break;
      }
    });

    _filmsViewModel.fetchWeekTrendingFilms();
    _filmsViewModel.fetchUpcomingFilms();
    _filmsViewModel.fetchTopRatedFilms();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UpcomingFilmsHorizontalList(
                  films: _upcomingFilms,
                  route: NavigationRoutes.FILM_HOME_DETAIL_ROUTE,
                ),
                FilmHorizontalList(
                  title: "WEEK TRENDS",
                  films: _weekTrendingFilms,
                ),
                FilmHorizontalList(
                  title: "TOP RATED",
                  films: _topRatedFilms,
                ),
              ],
            ),
          ),
        ));
  }
}
