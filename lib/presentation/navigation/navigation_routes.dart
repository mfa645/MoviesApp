import 'package:go_router/go_router.dart';
import 'package:movies_app/presentation/view/film/film_detail_page.dart';
import 'package:movies_app/presentation/view/film/films_discover_page.dart';
import 'package:movies_app/presentation/view/film/films_favourites_page.dart';
import 'package:movies_app/presentation/view/film/films_home_page.dart';
import 'package:movies_app/presentation/view/navigation_page.dart';
import 'package:movies_app/presentation/view/splash/splash_page.dart';

class NavigationRoutes {
  static const SPLASH_ROUTE = "/splash";
  static const HOME_ROUTE = "/home";
  static const DISCOVER_ROUTE = "/discover";
  static const FAVOURITES_ROUTE = "/favourites";
  static const FILM_HOME_DETAIL_ROUTE = "$HOME_ROUTE/$_FILM_DETAIL_PATH";
  static const FILM_DISCOVER_DETAIL_ROUTE =
      "$DISCOVER_ROUTE/$_FILM_DETAIL_PATH2";
  static const FILM_FAVOURITES_DETAIL_ROUTE =
      "$FAVOURITES_ROUTE/$_FILM_DETAIL_PATH3";

  static const _FILM_DETAIL_PATH = "detail";
  static const _FILM_DETAIL_PATH2 = "detail2";
  static const _FILM_DETAIL_PATH3 = "detail3";
}

final GoRouter router =
    GoRouter(initialLocation: NavigationRoutes.SPLASH_ROUTE, routes: [
  GoRoute(
    path: NavigationRoutes.SPLASH_ROUTE,
    builder: (context, state) => const SplashPage(),
  ),
  StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => NavigationPage(
            navigationShell: navigationShell,
          ),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: NavigationRoutes.HOME_ROUTE,
            builder: (context, state) => const FilmsHomePage(),
            routes: [
              GoRoute(
                path: NavigationRoutes._FILM_DETAIL_PATH,
                builder: (context, state) => FilmDetailPage(
                  filmId: state.extra as int,
                ),
              )
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: NavigationRoutes.DISCOVER_ROUTE,
              builder: (context, state) => const FilmsDiscoverPage(),
              routes: [
                GoRoute(
                    path: NavigationRoutes._FILM_DETAIL_PATH2,
                    builder: (context, state) {
                      return FilmDetailPage(
                        filmId: state.extra as int,
                      );
                    })
              ])
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
              path: NavigationRoutes.FAVOURITES_ROUTE,
              builder: (context, state) {
                return const FilmFavouritesPage();
              },
              routes: [
                GoRoute(
                  path: NavigationRoutes._FILM_DETAIL_PATH3,
                  builder: (context, state) => FilmDetailPage(
                    filmId: state.extra as int,
                  ),
                )
              ])
        ])
      ])
]);
