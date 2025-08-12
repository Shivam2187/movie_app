import 'package:hive_flutter/hive_flutter.dart';
import '../data/models/movie.dart';

class LocalStorage {
  static late Box<Movie> movieBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(MovieAdapter());
    movieBox = await Hive.openBox<Movie>('favorites');
  }

  static List<Movie> getBookmark() {
    final totalMovies = movieBox.values.toList();
    List<Movie> resultList = [];

    for (int i = 0; i < totalMovies.length; i++) {
      if (totalMovies[i].isBookmark) {
        resultList.add(totalMovies[i]);
      }
    }

    return resultList;
  }

  static Future<void> toggleBookmark(int id) async {
    final currentMovie = movieBox.get(id);
    if (currentMovie == null) return;
    final bookmarkStatus = currentMovie.isBookmark;
    final updatedMovie =
        currentMovie.copyWith(isBookmark: bookmarkStatus ? false : true);
    await movieBox.put(id, updatedMovie); // Overwrites the old movie
  }

  // Add multiple movies at once
  static Future<void> addAllMovies(List<Movie> movies) async {
    for (final movie in movies) {
      if (!movieBox.containsKey(movie.id)) {
        await movieBox.put(movie.id, movie);
      }
    }
  }

  // Get All movies at once
  static List<Movie> getAllMovies() {
    return movieBox.values.toList();
  }

  static bool isBookmark(int id) {
    final movie = movieBox.get(id);
    return movie?.isBookmark ?? false;
  }

  // remove All movies at once
  static Future<int> clearAllMoviesFromLocalDB() async {
    return await movieBox.clear();
  }
}
