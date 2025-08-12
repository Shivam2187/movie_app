// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:movie_app/core/api_service.dart';
import 'package:movie_app/data/models/movie.dart';
import 'package:movie_app/utils/constants.dart';

import '../../core/local_storage.dart';

ValueNotifier<bool?> isNetworkAvailable = ValueNotifier<bool?>(null);
bool isBackOnlineEnable = false;
bool needToShowNetworkSnackBar = true;

class MovieProvider with ChangeNotifier {
  late final ApiService apiService;
  MovieProvider() {
    final dio = Dio()..options.headers['accept'] = 'application/json';
    apiService = ApiService(dio);
  }

  List<Movie> totalMovies = [];
  List<Movie> trendingMovies = [];

  String _searchQuery = '';
  String get getSearchQuery => _searchQuery;

  String _bookmarkSearchQuery = '';
  String get getBookmarkSearchQuery => _bookmarkSearchQuery;

  String _debouncedSearchQuery = '';
  String get getDebouncedSearchQuery => _debouncedSearchQuery;
  final List<Movie> _totalDebouncedMovies = [];
  List<Movie> get getTotalDebouncedMovies => _totalDebouncedMovies;
  String debouncedCurrentPageNumber = '1';

  List<Movie> get _bookmarkMovies => LocalStorage.getBookmark();

  bool isLoading = false;
  bool isDebouncedLoading = false;
  bool hasError = false;
  bool hasMoviesMore = true;
  bool hasDebouncedMoviesMore = true;

  String currentPageNumber = '1';

  List<Movie> get getMovies => _searchQuery.isEmpty
      ? totalMovies
      : totalMovies.where(
          (movie) {
            if (movie.title == null) {
              return false;
            }
            return movie.title!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          },
        ).toList();

  List<Movie> get getBookmarkMovies => _bookmarkMovies.where(
        (movie) {
          if (movie.title == null) {
            return false;
          }
          return movie.title!
              .toLowerCase()
              .contains(_bookmarkSearchQuery.toLowerCase());
        },
      ).toList();

  /// Set Data form Local DB to totalMovies
  Future<void> setInitialTotalMovies() async {
    totalMovies = LocalStorage.getAllMovies();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void setDebouncedSearchQuery(String query) {
    _debouncedSearchQuery = query.trim();
    notifyListeners();
  }

  void setBookmarkSearchQuery(String query) {
    _bookmarkSearchQuery = query.trim();
    notifyListeners();
  }

  /// Adding and removing movie from Bookmark list
  Future<void> toggleBookmark(Movie movie) async {
    await LocalStorage.toggleBookmark(movie);
    notifyListeners();
  }

  /// Used to check current movie is present in Bookmark list
  bool isBookmark(int movieId) {
    return LocalStorage.isBookmark(movieId);
  }

  /// Pagination Logic :-
  Future<void> fetchNowPlayingMovie() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final apiKey = dotenv.env['TMDB_API_READ_KEY'];

      if (apiKey == null || !hasMoviesMore) return;

      final response = await apiService.fetchNowPlayingMovies(
        'Bearer $apiKey',
        currentPageNumber,
        'en-US',
      );

      final data = response.data;
      final movieResponse = MovieResponse.fromJson(data);
      final currentPageMovie = movieResponse.results;
      if (currentPageMovie.isEmpty) {
        hasMoviesMore = false;
      } else if (currentPageMovie.isListNotEmptyOrNull()) {
        addUniqueMovies(currentPageMovie);
        LocalStorage.addAllMovies(currentPageMovie);
      }

      currentPageNumber =
          ((int.tryParse(currentPageNumber) ?? 0) + 1).toString();
    } catch (e) {
      hasError = true;
      print(e.toString());
    }

    isLoading = false;
    notifyListeners();
  }

  void addUniqueMovies(List<Movie> newMovies) {
    for (int i = 0; i < newMovies.length; i++) {
      final item = newMovies[i];

      final exists = totalMovies.any((e) => e.id == item.id);
      if (!exists) {
        totalMovies.add(item);
      }
    }
  }

  Future<void> fetchDebouncedSearchMovies({
    bool reset = false,
    required String query,
  }) async {
    isDebouncedLoading = true;
    if (reset) {
      debouncedCurrentPageNumber = '1';
      _totalDebouncedMovies.clear();
      notifyListeners();
      hasDebouncedMoviesMore = true;
    }
    final apiKey = dotenv.env['TMDB_API_READ_KEY'];

    if (apiKey == null || !hasDebouncedMoviesMore) return;

    try {
      final response = await apiService.fetchDebouncedSearchMovies(
        'Bearer $apiKey',
        debouncedCurrentPageNumber,
        'en-US',
        query.trim(),
      );
      final data = response.data;
      final movieResponse = MovieResponse.fromJson(data);
      final currentPageMovie = movieResponse.results;

      if (currentPageMovie.isEmpty) {
        hasDebouncedMoviesMore = false;
      } else if (currentPageMovie.isListNotEmptyOrNull()) {
        _totalDebouncedMovies.addAll(currentPageMovie);
      }

      for (var i = 0; i < _totalDebouncedMovies.length; i++) {
        print(_totalDebouncedMovies[i].title);
      }

      debouncedCurrentPageNumber =
          ((int.tryParse(debouncedCurrentPageNumber) ?? 0) + 1).toString();
    } catch (e) {
      print(e.toString());
    }
    isDebouncedLoading = false;
    notifyListeners();
  }

  void clearDebouncedMovies() {
    _totalDebouncedMovies.clear();
    notifyListeners();
  }

  /// Get Trending Movies
  Future<void> fetchTrendingMovie() async {
    try {
      final apiKey = dotenv.env['TMDB_API_READ_KEY'];

      if (apiKey == null || !hasMoviesMore) return;

      final response = await apiService.fetchTrendingMovie(
        'Bearer $apiKey',
        'en-US',
      );

      final data = response.data;
      final movieResponse = MovieResponse.fromJson(data);
      final currentPageMovie = movieResponse.results;

      trendingMovies.addAll(currentPageMovie);
      LocalStorage.addAllMovies(currentPageMovie);
    } catch (e) {
      print(e.toString());
    }
  }
}
