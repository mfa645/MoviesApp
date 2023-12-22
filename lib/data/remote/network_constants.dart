class NetworkConstants {
  static const BASE_URL = "https://api.themoviedb.org/3";

  static const FILMS_PATH = "$BASE_URL/movie";
  static const IMAGES_PATH = "https://image.tmdb.org/t/p/w500";

  static const DISCOVER_FILMS_PATH = "$BASE_URL/discover/movie";

  static const TOP_RATED_FILMS_PATH = "$FILMS_PATH/top_rated";
  static const WEEK_TRENDING_FILMS_PATH = "$BASE_URL/trending/movie/week";
  static const UPCOMING_FILMS_PATH = "$FILMS_PATH/upcoming";

  static const SEARCH_FILMS_PATH = "$BASE_URL/search/movie";

  static const GENRES_PATH = "$BASE_URL/genre/movie/list";
}
