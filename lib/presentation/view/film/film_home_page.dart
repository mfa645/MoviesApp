import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/film_horizontal_list.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';
import 'package:movies_app/presentation/widget/upcoming_films_horizontal_list.dart';

class FilmHomePage extends StatefulWidget {
  const FilmHomePage({super.key});

  @override
  State<FilmHomePage> createState() => _FilmHomePageState();
}

class _FilmHomePageState extends State<FilmHomePage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();
  List<Film> _upcomingFilms = [];
  List<Film> _topRatedFilms = [];
  List<Film> _weekTrendingFilms = [];

  @override
  void initState() {
    super.initState();

    _filmsViewModel.getUpcomingFilmsResponseState.stream.listen((state) {
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
    _filmsViewModel.getTopRatedFilmsResponseState.stream.listen((state) {
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
    _filmsViewModel.getWeekTrendingFilmsResponseState.stream.listen((state) {
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

    _filmsViewModel.fetchHomeFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Films"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UpcomingFilmsHorizontalList(films: _upcomingFilms),
            FilmHorizontalList(
              title: "TOP RATED",
              films: _topRatedFilms,
            ),
            FilmHorizontalList(
              title: "WEEK TRENDS",
              films: _weekTrendingFilms,
            ),
          ],
        ),
      )),
    );
  }
}
