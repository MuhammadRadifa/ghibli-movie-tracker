import 'package:ghibli_movies/layers/domain/entity/film/film.dart';

abstract class FilmRepository {
  Future<List<Film>> getFilms();
  Future<Film> getFilmById(String id);
}
