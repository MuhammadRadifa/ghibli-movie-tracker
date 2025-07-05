import 'package:ghibli_movies/layers/domain/entity/film/film.dart';
import 'package:ghibli_movies/layers/domain/repository/film_repository.dart';

class FilmUsecase {
  FilmUsecase({required FilmRepository filmRepository})
    : _filmRepository = filmRepository;

  final FilmRepository _filmRepository;

  Future<List<Film>> getAllFilms() async {
    try {
      final films = await _filmRepository.getFilms();
      return films;
    } catch (e) {
      print("Error fetching films: $e");
      return [];
    }
  }

  Future<Film> getFilmById(String id) async {
    try {
      final film = await _filmRepository.getFilmById(id);
      return film;
    } catch (e) {
      print("Error fetching film by ID: $e");
      return Film.empty(); // Return an empty Film in case of error
    }
  }
}
