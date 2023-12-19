import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/film_list_row.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';

class FilmsDiscoverPage extends StatefulWidget {
  const FilmsDiscoverPage({super.key});

  @override
  State<FilmsDiscoverPage> createState() => _FilmsDiscoverPageState();
}

class _FilmsDiscoverPageState extends State<FilmsDiscoverPage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();
  List<Film> _films = [];
  final _textFieldController = TextEditingController();
  final List<Genre> _genres = [];

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
            _films = state.data!.results;
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

    _filmsViewModel.fetchWeekTrendingFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
      ),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search films here!",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black54))),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _films.length,
              itemBuilder: (_, index) {
                final film = _films[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilmListRow(film: film),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}
