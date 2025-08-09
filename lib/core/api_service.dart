import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stage_app/data/models/movie.dart';
import 'package:stage_app/utils/constants.dart';

class ApiService {
  /// Fetches popular movies from the TMDB API
  Future<List<Movie>?> fetchMovies(String apiKey, String page) async {
    final url = 'https://api.themoviedb.org/3/movie/popular?page=$page';

    return MovieConstant.movies;

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json;charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Failed to Load Movies');
    }
  }
}
