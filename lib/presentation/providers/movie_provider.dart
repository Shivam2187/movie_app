// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stage_app/core/api_service.dart';
import 'package:stage_app/data/models/movie.dart';
import 'package:stage_app/utils/constants.dart';

import '../../core/local_storage.dart';
import '../../core/locator.dart';

ValueNotifier<bool?> isNetworkAvailable = ValueNotifier<bool?>(null);
bool isBackOnlineEnable = false;
bool needToShowNetworkSnackBar = true;

class MovieProvider with ChangeNotifier {
  MovieProvider();

  final ApiService apiService = locator.get<ApiService>();

  /// Get Data form Local DB
  List<Movie> get _getTotalLoadedMovies => LocalStorage.getAllMovies();
  String _searchQuery = '';
  String get getSearchQuery => _searchQuery;

  final List<Movie> _bookmarkMovies = LocalStorage.getBookmark();

  bool isLoading = false;
  bool hasError = false;

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
              .contains(_searchQuery.toLowerCase());
        },
      ).toList();

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
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
  /// Used for fetch movies with two diffrent condition 1st for just
  /// fetch movies and stored in cache for future use and
  /// 2nd for just fetch and show to the screen
  Future<void> fetchMovies() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final currentMovie =
          await apiService.fetchMovies(MovieConstant.apiKey, currentPageNumber);

      if (currentMovie.isListNotEmptyOrNull()) {
        await LocalStorage.addAllMovies(currentMovie!);
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
}
