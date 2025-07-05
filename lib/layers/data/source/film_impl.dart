import 'package:ghibli_movies/layers/data/dto/film_dto.dart';
import 'package:ghibli_movies/layers/data/source/network/api.dart';
import 'package:ghibli_movies/layers/domain/repository/film_repository.dart';

class FilmImpl extends FilmRepository {
  final Api _api;

  FilmImpl({required Api api}) : _api = api;

  @override
  Future<List<FilmDto>> getFilms() async {
    try {
      final films = await _api.loadFilm();
      return films;
    } catch (e) {
      print("Error loading films: $e");
      return [];
    }
  }

  @override
  Future<FilmDto> getFilmById(String id) async {
    try {
      final film = await _api.loadFilmById(id);
      return film;
    } catch (e) {
      print("Error loading film by ID: $e");
      return FilmDto.empty(); // Return an empty FilmDto in case of error
    }
  }
}
