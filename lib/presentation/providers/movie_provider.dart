// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:stage_app/core/api_service.dart';
import 'package:stage_app/data/models/movie.dart';
import 'package:stage_app/utils/constants.dart';

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

  /// Get Data form Local DB
  List<Movie> get _getTotalLoadedMovies => LocalStorage.getAllMovies();
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
  bool hasError = false;
  bool _hasMore = true;

  String currentPageNumber = '1';

  List<Movie> get getMovies => _searchQuery.isEmpty
      ? _getTotalLoadedMovies
      : _getTotalLoadedMovies.where(
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
    if (movie.isBookmark) {
      await LocalStorage.removeBookmark(movie.id);
    } else {
      await LocalStorage.saveBookmark(movie.id);
    }
    notifyListeners();
  }

  /// Used to check current movie is present in Bookmark list
  bool isBookmark(int movieId) {
    return LocalStorage.isBookmark(movieId);
  }

  /// Pagination Logic :-

  Future<void> fetchMovies() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final apiKey = dotenv.env['TMDB_API_READ_KEY'];

      if (apiKey == null) return;

      final response = await apiService.fetchMovies(
        'Bearer $apiKey',
        currentPageNumber,
        'en-US',
      );

      final data = response.data;
      final movieResponse = MovieResponse.fromJson(data);
      final currentPageMovie = movieResponse.results;

      if (currentPageMovie.isListNotEmptyOrNull()) {
        await LocalStorage.addAllMovies(currentPageMovie);
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

  Future<void> fetchDebouncedSearchMovies({
    bool reset = false,
  }) async {
    if (reset) {
      debouncedCurrentPageNumber = '1';
      _totalDebouncedMovies.clear();
      notifyListeners();
    }

    if (!_hasMore) return;

    try {
      final apiKey = dotenv.env['TMDB_API_READ_KEY'];

      if (apiKey == null) return;

      final response = await apiService.fetchMovies(
        apiKey,
        debouncedCurrentPageNumber,
        'en-US',
      );
      final currentMovie = response.data;

      if (currentMovie.isEmpty) {
        _hasMore = false;
      } else if (currentMovie.isListEmptyOrNull()) {
        _totalDebouncedMovies.addAll(currentMovie);
      }

      debouncedCurrentPageNumber =
          ((int.tryParse(debouncedCurrentPageNumber) ?? 0) + 1).toString();
    } catch (e) {
      print(e.toString());
    }

    notifyListeners();
  }
}
