import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/utils/debouncer/text_field_debouncer.dart';
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
  List<Genre> _genres = [];
  int? selectedGenre;

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
            _filmsViewModel.fetchFilms(selectedGenre);
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

    _filmsViewModel.fetchFilmGenres();
    _filmsViewModel.fetchFilms(null);
  }

  @override
  Widget build(BuildContext context) {
    final debouncer =
        TextFieldDebouncer(milliseconds: 1500, action: (String text) {});
    return Scaffold(
      appBar: AppBar(
        title: const Text("Discover"),
      ),
      body: SafeArea(
        child: SizedBox(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 50,
                child: TextField(
                  cursorColor: Colors.black54,
                  controller: _textFieldController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    label: const Text("Search films here!"),
                    labelStyle: const TextStyle(
                      letterSpacing: 0.2,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Colors.black54),
                    ),
                  ),
                  onChanged: (text) {
                    if (selectedGenre != null) {
                      selectedGenre = null;
                    }
                    debouncer.run(() {
                      text.isEmpty
                          ? _filmsViewModel.fetchFilms(selectedGenre)
                          : _filmsViewModel.fetchFilmsByTitle(text);
                    });
                  },
                ),
              ),
            ),
            selectedGenre == null && _textFieldController.text.isEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _genres.length,
                      itemBuilder: (_, index) {
                        final genre = _genres[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                              onTap: () {
                                selectedGenre = genre.id;
                                _filmsViewModel.fetchFilms(genre.id);
                              },
                              child: Text(genre.name)),
                        );
                      },
                    ),
                  )
                : _films.isNotEmpty
                    ? Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: selectedGenre != null
                                    ? MainAxisAlignment.spaceBetween
                                    : MainAxisAlignment.end,
                                children: [
                                  if (selectedGenre != null)
                                    Text("Genre : $selectedGenre"),
                                  GestureDetector(
                                      onTap: () {
                                        selectedGenre != null
                                            ? selectedGenre = null
                                            : _textFieldController.text = "";
                                        setState(() {});
                                      },
                                      child: const Text("Go back"))
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
                                    child: FilmListRow(film: film),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Text("No films availables for your search"),
          ]),
        ),
      ),
    );
  }
}
