import 'package:movies_app/data/remote/error/remote_error_mapper.dart';
import 'package:movies_app/data/remote/network_client.dart';
import 'package:movies_app/data/remote/network_constants.dart';
import 'package:movies_app/model/film.dart';

class FilmsRemoteImpl {
  final NetworkClient _networkClient;

  FilmsRemoteImpl({required NetworkClient networkClient})
      : _networkClient = networkClient;

  Future<FilmResponse> getFilms() async {
    try {
      final response =
          await _networkClient.dio.get(NetworkConstants.DISCOVER_MOVIES_PATH);

      final filmsResponse = FilmResponse.fromJson(response.data);

      return filmsResponse;
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }

  Future<Film> getFilmDetails(int filmId) async {
    try {
      final response = await _networkClient.dio
          .get("${NetworkConstants.MOVIES_PATH}/$filmId");

      return Film.fromJson(response.data);
    } catch (e) {
      throw RemoteErrorMapper.getException(e);
    }
  }
}
