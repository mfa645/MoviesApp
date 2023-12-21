import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/data/remote/network_constants.dart';
import 'package:movies_app/di/app_modules.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/model/resource_state.dart';
import 'package:movies_app/presentation/view/film/viewmodel/films_view_model.dart';
import 'package:movies_app/presentation/widget/error/error_view.dart';
import 'package:movies_app/presentation/widget/loading/loading_view.dart';
import 'package:movies_app/presentation/widget/star_rating.dart';

class FilmDetailPage extends StatefulWidget {
  const FilmDetailPage({super.key, required this.filmId});
  final int filmId;
  @override
  State<FilmDetailPage> createState() => _FilmDetailPageState();
}

class _FilmDetailPageState extends State<FilmDetailPage> {
  final FilmsViewModel _filmsViewModel = inject<FilmsViewModel>();

  Film? _film;
  bool _isFavourite = false;

  @override
  void initState() {
    super.initState();

    _filmsViewModel.getFilmDetailState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _film = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchFilmDetails(widget.filmId);
          });
          break;
      }
    });
    _filmsViewModel.getIsFavouriteFilm.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          LoadingView.show(context);
          break;
        case Status.SUCCESS:
          LoadingView.hide();
          setState(() {
            _isFavourite = state.data!;
          });
          break;
        case Status.ERROR:
          LoadingView.hide();
          ErrorView.show(context, state.exception!.toString(), () {
            _filmsViewModel.fetchFilmDetails(widget.filmId);
          });
          break;
      }
    });
    _filmsViewModel.fetchFilmDetails(widget.filmId);
    _filmsViewModel.fetchIsFavouriteFilm(widget.filmId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0.0,
            leading: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                  onPressed: () {
                    if (_film != null) {
                      _isFavourite
                          ? _filmsViewModel
                              .removeFilmFromFavourites(widget.filmId)
                          : _filmsViewModel.addFilmToFavourites(_film!);
                    }
                  },
                  icon: Icon(
                    _isFavourite ? Icons.favorite : Icons.favorite_outline,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ]),
        body: Container(
            constraints: const BoxConstraints.expand(),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 196, 196, 196), Colors.white],
                stops: [0.3, 0.7],
              ),
            ),
            child: SingleChildScrollView(
                child: _film == null
                    ? const Center(
                        child: Text("There was an error loading the film"),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            SizedBox(
                              height: 300,
                              child: _film!.backdropPath != null
                                  ? CachedNetworkImage(
                                      imageUrl: NetworkConstants.IMAGES_PATH +
                                          _film!.backdropPath!,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Image.asset(
                                      "assets/images/default_movie.png"),
                            ),
                            Container(
                              height: 300,
                              color: Colors.black.withOpacity(0.15),
                            )
                          ]),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _film!.title,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w800),
                                ),
                                if (_film!.tagline != null &&
                                    _film!.tagline!.isNotEmpty)
                                  Text(
                                    _film!.tagline!,
                                    textAlign: TextAlign.justify,
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.w400),
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    StarRating(
                                        rating: _film!.voteAverage ?? 0.0),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    const Icon(Icons.access_time_outlined),
                                    Text("${_film!.runtime!.toString()} min"),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    const Icon(Icons.calendar_month),
                                    Text(DateTime.parse(_film!.releaseDate)
                                        .year
                                        .toString()),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 20,
                                  children: List.generate(
                                    _film!.productionCompanies!.length,
                                    (index) {
                                      return _film!.productionCompanies![index]
                                                  .logoPath !=
                                              null
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 20,
                                                child: CachedNetworkImage(
                                                  imageUrl: NetworkConstants
                                                          .IMAGES_PATH +
                                                      _film!
                                                          .productionCompanies![
                                                              index]
                                                          .logoPath!,
                                                  fit: BoxFit.fitHeight,
                                                ),
                                              ),
                                            )
                                          : const SizedBox(
                                              height: 0,
                                              width: 0,
                                            );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Wrap(
                                  alignment: WrapAlignment.start,
                                  spacing: 0,
                                  children: List.generate(
                                    _film!.genres!.length,
                                    (index) {
                                      return Card(
                                        color: const Color.fromARGB(
                                            195, 221, 212, 212),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            _film!.genres![index].name,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                _divider(),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _gridText(
                                              "Original language : ${_film!.originalLanguage.isNotEmpty ? _film!.originalLanguage : "NA"}"),
                                          _gridText(
                                              "Adult: ${_film!.adult! ? "Yes" : "No"}"),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _gridText(
                                              "Budget : ${_film!.budget == null ? "NA" : _film!.budget!.toString()}"),
                                          _gridText(
                                              "Status : ${_film!.status != null && _film!.status!.isNotEmpty ? _film!.status : "NA"}"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                _divider(),
                                Text(
                                  _film!.overview,
                                  textAlign: TextAlign.justify,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                          )
                        ],
                      ))),
      ),
    );
  }

  Widget _gridText(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: const TextStyle(
            color: Color.fromARGB(255, 102, 100, 100),
            fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      thickness: 1.5,
      height: 10,
      color: Colors.grey,
    );
  }
}
