import 'package:flutter/material.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/model/genre.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/navigation/navigation_routes.dart';
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
  final _textFieldController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  int _page = 1;
  int _totalPages = -1;

  List<Film> _films = [];
  List<Genre> _genres = [];

  Genre? selectedGenre;

  @override
  void dispose() {
    super.dispose();
    _filmsViewModel.dispose();
  }

  @override
  void initState() {
    super.initState();

/*
    _filmsViewModel.getFilmsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          final end = _page == state.data!.totalPages;
          if (end) {
            _pagingController.appendLastPage([]);
            return;
          }

          _pagingController.appendPage(state.data!.results, ++_page);
          setState(() {});
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchFilms(null, 1);
          });
          break;
      }
    });*/

    _filmsViewModel.getFilmsState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            if (_page > 1) {
              _films.addAll(state.data!.results);
            } else {
              _totalPages = state.data!.totalPages;
              _films = state.data!.results;
              _scrollController.jumpTo(0.0);
            }
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          _page < _totalPages) {
        _page++;
        _addFilms(_page);
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
                      _page = 1;
                      text.isEmpty
                          ? _filmsViewModel.fetchFilms(null, 1)
                          : _filmsViewModel.fetchFilmsByTitle(text, 1);
                      setState(() {});
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
                                        selectedGenre = genre;
                                        _page = 1;
                                        _filmsViewModel.fetchFilms(
                                            genre.id, _page);
                                        setState(() {});
                                      },
                                      child: GenreListRow(genre: genre));
                                }),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                  selectedGenre!.name,
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
                          child: Scrollbar(
                            controller: _scrollController,
                            child: ListView.separated(
                              controller: _scrollController,
                              itemCount: _films.length,
                              itemBuilder: (context, index) {
                                final item = _films[index];
                                return FilmListRow(
                                  film: item,
                                  route: NavigationRoutes
                                      .FILM_DISCOVER_DETAIL_ROUTE,
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const Divider();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
          ]),
        ),
      ),
    );
  }

  Future<void> _addFilms(int page) async {
    if (page == 1) {
      _films.clear();
    }

    if (_textFieldController.text.isNotEmpty) {
      _filmsViewModel.fetchFilmsByTitle(_textFieldController.text, page);
    } else {
      if (selectedGenre != null) {
        _filmsViewModel.fetchFilms(selectedGenre!.id, page);
      } else {}
    }
    setState(() {});
  }
}
