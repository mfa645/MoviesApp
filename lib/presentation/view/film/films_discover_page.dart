import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/utils/debouncer/text_field_debouncer.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/custom_searchbar.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/film/film_list_row.dart';
import 'package:movies_app/presentation/widget/genre/genre_list_row.dart';
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
  String? selectedGenre;

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
            _filmsViewModel.fetchFilms(null);
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
  }

  @override
  Widget build(BuildContext context) {
    final debouncer = TextFieldDebouncer(milliseconds: 1500, action: () {});
    return Scaffold(
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Discover",
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold)),
                  ),
                  Icon(
                    Icons.movie,
                    size: 40,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: CustomSearchbar(
                  controller: _textFieldController,
                  label: "Search films here!",
                  onChangedFunction: (String text) {
                    if (selectedGenre != null) {
                      selectedGenre = null;
                    }
                    debouncer.run(() {
                      text.isEmpty
                          ? _filmsViewModel.fetchFilms(null)
                          : _filmsViewModel.fetchFilmsByTitle(text);
                    });
                  }),
            ),
            selectedGenre == null && _textFieldController.text.isEmpty
                ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GridView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: _genres.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 0,
                                  mainAxisSpacing: 0,
                                ),
                                itemBuilder: (_, index) {
                                  final genre = _genres[index];
                                  return GestureDetector(
                                      onTap: () {
                                        selectedGenre = genre.name;
                                        _filmsViewModel.fetchFilms(genre.id);
                                      },
                                      child: GenreListRow(genre: genre));
                                }),
                          ),
                        ],
                      ),
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
                                    : MainAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      selectedGenre != null
                                          ? selectedGenre = null
                                          : _textFieldController.text = "";
                                      setState(() {});
                                    },
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.arrow_back,
                                          size: 25,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selectedGenre != null)
                                    Text(
                                      "$selectedGenre",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                  const SizedBox(
                                    width: 30,
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
