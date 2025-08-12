// import 'package:flutter_test/flutter_test.dart';
// import 'package:movie_app/data/models/movie.dart';
// import 'package:movie_app/presentation/providers/provider.dart';

// void main() {
//   late MovieProvider favoriteMoviesProvider;
//   late MovieResponse testMovie;

//   setUp(() {
//     favoriteMoviesProvider = MovieProvider();
//     testMovie = MovieResponse(
//       id: 1,
//       title: "Test Movie",
//       moviePoster: "/test.jpg",
//       overview: "Test Overview",
//       genre: "Action",
//       rating: "8.0",
//       releaseDate: "2021-01-01",
//     );
//   });

//   test('Toggle favorite adds movie to favorites', () {
//     favoriteMoviesProvider.toggleFavorite(testMovie);
//     expect(favoriteMoviesProvider.favoriteMovies.contains(testMovie), isTrue);
//   });

//   test('Toggle favorite removes movie from favorites', () {
//     favoriteMoviesProvider.toggleFavorite(testMovie);
//     favoriteMoviesProvider.toggleFavorite(testMovie);
//     expect(favoriteMoviesProvider.favoriteMovies.contains(testMovie), isFalse);
//   });
// }
