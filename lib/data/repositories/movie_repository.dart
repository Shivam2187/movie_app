import 'package:stage_app/utils/constants.dart';

import '../models/movie.dart';
import '../../core/api_service.dart';
import '../../core/local_storage.dart';

class MovieRepository {
  final ApiService _apiService;

  MovieRepository(this._apiService);

  Future<List<Movie>> getMovies() async {
    final movies = await _apiService.fetchMovies(MovieConstant.apiKey, '1');
    final favorites = LocalStorage.getFavorites().map((m) => m.id).toSet();

    for (var movie in movies) {
      if (favorites.contains(movie.id)) {
        movie.isFavorite = true;
      }
    }
    return movies;
  }

  void toggleFavorite(Movie movie) {
    movie.isFavorite = !movie.isFavorite;
    if (movie.isFavorite) {
      LocalStorage.saveFavorite(movie);
    } else {
      LocalStorage.removeFavorite(movie.id);
    }
  }
}
