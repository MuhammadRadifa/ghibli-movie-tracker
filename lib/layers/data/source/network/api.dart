import 'package:dio/dio.dart';
import 'package:ghibli_movies/layers/data/dto/film_dto.dart';

abstract class Api {
  Future<List<FilmDto>> loadFilm();
  Future<FilmDto> loadFilmById(String id);
}

class ApiImpl implements Api {
  final dio = Dio();

  @override
  Future<List<FilmDto>> loadFilm() async {
    try {
      final Response response = await dio.get(
        'https://ghibliapi.vercel.app/films',
      );

      final data = response.data;

      if (data is List) {
        final films = data.map((e) => FilmDto.fromJson(e)).toList();
        return films.cast<FilmDto>();
      } else {
        print("Unexpected response format: $data");
        return [];
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Server responded with error:");
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        print("Request error: $e");
      }
    } catch (e) {
      print("Unexpected error: $e");
    }

    return [];
  }

  @override
  Future<FilmDto> loadFilmById(String id) async {
    try {
      final Response response = await dio.get(
        'https://ghibliapi.vercel.app/films/$id',
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        return FilmDto.fromJson(data);
      } else {
        print("Unexpected response format: $data");
        return FilmDto.empty();
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("Server responded with error:");
        print(e.response?.data);
        print(e.response?.statusCode);
      } else {
        print("Request error: $e");
      }
    } catch (e) {
      print("Unexpected error: $e");
    }

    return FilmDto.empty();
  }
}
