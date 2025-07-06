import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const String _favoriteKey = 'favorite_films';
  static const String _watchedKey = 'watched_films';

  /// Add film to favorites
  Future<void> addFavorite(String filmId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteKey) ?? [];
    if (!favorites.contains(filmId)) {
      favorites.add(filmId);
      await prefs.setStringList(_favoriteKey, favorites);
    }
  }

  /// Remove film from favorites
  Future<void> removeFavorite(String filmId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteKey) ?? [];
    favorites.remove(filmId);
    await prefs.setStringList(_favoriteKey, favorites);
  }

  /// Get all favorite film IDs
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteKey) ?? [];
  }

  /// Mark film as watched
  Future<void> markWatched(String filmId) async {
    final prefs = await SharedPreferences.getInstance();
    final watched = prefs.getStringList(_watchedKey) ?? [];
    if (!watched.contains(filmId)) {
      watched.add(filmId);
      await prefs.setStringList(_watchedKey, watched);
    }
  }

  // remove film from watched list
  Future<void> removeWatched(String filmId) async {
    final prefs = await SharedPreferences.getInstance();
    final watched = prefs.getStringList(_watchedKey) ?? [];
    watched.remove(filmId);
    await prefs.setStringList(_watchedKey, watched);
  }

  /// Get all watched film IDs
  Future<List<String>> getWatched() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_watchedKey) ?? [];
  }

  /// Check if a film is favorite
  Future<bool> isFavorite(String filmId) async {
    final favorites = await getFavorites();
    return favorites.contains(filmId);
  }

  /// Check if a film is watched
  Future<bool> isWatched(String filmId) async {
    final watched = await getWatched();
    return watched.contains(filmId);
  }
}
