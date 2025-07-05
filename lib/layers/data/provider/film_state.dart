import 'package:flutter/material.dart';

class FilmState extends ChangeNotifier {
  String? _filmId;

  String? get filmId => _filmId;

  void setFilmId(String id) {
    _filmId = id;
    notifyListeners();
  }
}
