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
    return movieBox.values.toList();
  }

  static void saveBookmark(Movie movie) {
    movieBox.put(movie.id, movie);
  }

  static void removeBookmark(int id) {
    movieBox.delete(id);
  }
}
