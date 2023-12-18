import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';

class FilmsSearchPage extends StatefulWidget {
  const FilmsSearchPage({super.key});

  @override
  State<FilmsSearchPage> createState() => _FilmsSearchPageState();
}

class _FilmsSearchPageState extends State<FilmsSearchPage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();
  List<Film> _films = [];

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

    _filmsViewModel.fetchFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Films"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _films.length,
          itemBuilder: (_, index) {
            final film = _films[index];

            return ListTile(
              title: Text(film.title),
            );
          },
        ),
      ),
    );
  }
}
