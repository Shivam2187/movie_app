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
  final List<Movie> _totalLoadedMovies = [];
  List<Movie> get getTotalLoadedMovies => _totalLoadedMovies;
  String _searchQuery = '';

  List<Movie> _bookmarkMovies = LocalStorage.getBookmark();

  bool isLoading = false;
  bool hasError = false;

  String currentPageNumber = '1';

  List<Movie> get movies => _searchQuery.isEmpty
      ? _totalLoadedMovies
      : _totalLoadedMovies.where(
          (movie) {
            if (movie.title == null) {
              return false;
            }
            return movie.title!
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
          },
        ).toList();

  List<Movie> get bookmarkMovies => _bookmarkMovies.where(
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
  void toggleBookmark(Movie movie) {
    movie.isBookmark = !movie.isBookmark;
    if (movie.isBookmark) {
      LocalStorage.saveBookmark(movie);
      _bookmarkMovies = [..._bookmarkMovies, movie];
    } else {
      LocalStorage.removeBookmark(movie.id);
      _bookmarkMovies = _bookmarkMovies.where((m) => m.id != movie.id).toList();
    }
    notifyListeners();
  }

  /// Used to check current movie is present in Bookmark list
  bool isBookmark(int movieId) {
    return _bookmarkMovies.any((movie) => movie.id == movieId);
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
        _totalLoadedMovies.addAll(currentMovie!);
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
