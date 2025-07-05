import 'dart:convert';
import 'package:ghibli_movies/layers/domain/entity/film/film.dart';

class FilmDto extends Film {
  FilmDto({
    required super.id,
    required super.title,
    required super.originalTitle,
    required super.originalTitleRomanised,
    required super.image,
    required super.movieBanner,
    required super.description,
    required super.director,
    required super.producer,
    required super.releaseDate,
    required super.runningTime,
    required super.rtScore,
    required super.url,
  });

  /// ✅ Jika dapat data string JSON mentah
  factory FilmDto.fromRawJson(String str) => FilmDto.fromJson(json.decode(str));

  /// ✅ Jika dapat data map dari API (sudah di-decode)
  factory FilmDto.fromJson(Map<String, dynamic> json) {
    return FilmDto(
      id: json['id'] as String,
      title: json['title'] as String,
      originalTitle: json['original_title'] as String,
      originalTitleRomanised: json['original_title_romanised'] as String,
      image: json['image'] as String,
      movieBanner: json['movie_banner'] as String,
      description: json['description'] as String,
      director: json['director'] as String,
      producer: json['producer'] as String,
      releaseDate: json['release_date'] as String,
      runningTime: int.tryParse(json['running_time'].toString()) ?? 0,
      rtScore: json['rt_score'] as String,
      url: json['url'] as String,
    );
  }

  /// ✅ Konversi ke JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'original_title': originalTitle,
      'original_title_romanised': originalTitleRomanised,
      'image': image,
      'movie_banner': movieBanner,
      'description': description,
      'director': director,
      'producer': producer,
      'release_date': releaseDate,
      'running_time': runningTime.toString(),
      'rt_score': rtScore,
      'url': url,
    };
  }

  // empty dto
  factory FilmDto.empty() {
    return FilmDto(
      id: '',
      title: '',
      originalTitle: '',
      originalTitleRomanised: '',
      image: '',
      movieBanner: '',
      description: '',
      director: '',
      producer: '',
      releaseDate: '',
      runningTime: 0,
      rtScore: '',
      url: '',
    );
  }
}
