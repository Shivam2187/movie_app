import 'package:stage_app/data/models/movie.dart';

class NavigationPaths {
  static const errorScreen = '/errorScreen';
  static const favouriteScreen = '/favouriteScreen';
  static const movieDetailsScreen = '/movieDetailsScreen';
}

class MovieConstant {
  static const movieScreenAppbarTiltle = 'Movies';
  static const searchMoviesHintText = 'Search movies...';
  static const failedtoload = 'Failed to load movies';
  static const trailers = 'Trailers';
  static const errorScreenTitle = 'Error Screen';
  static const somethingWentWrong =
      'Something Went Wrong While fetching Movies';

  static const favouriteMovies = 'Favourite Movies';
  static const noFavouriteMovies = 'Oops! Couldn\'t find any favorites...';
  static const noInternetConnection = 'No Internet Connection';
  static const retry = 'Retry';
  static const backOnline = 'Back online';
  static const notMatchingWithSearch =
      'Oops! We couldn\'t find anything for that search....';

  static const ratingText = 'Rating : ';
  static const apiKey = '8109e1095288aec7bfe2b22f2f41c63e';

  static const baseImageUrl = 'https://image.tmdb.org/t/p/w500';

  static final movies = [
    Movie(
      id: 1,
      title: 'The Godfather',
      overview:
          '''The Godfather "Don" Vito Corleone is the head of the Corleone mafia family in New York. He is at the event of his daughter's wedding. Michael, Vito's youngest son and a decorated WWII Marine is also present at the wedding. Michael seems to be uninterested in being a part of the family business. Vito is a powerful man, and is kind to all those who give him respect but is ruthless against''',
      posterPath: '/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      backdropPath: '/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      isBookmark: false,
      //genre: 'Action, Science Fiction, Drama',
      voteAverage: 4.5,
      releaseDate: 'March 2010',
    ),
    Movie(
      id: 2,
      title: 'Dark Knight',
      overview:
          '''Set within a year after the events of Batman Begins (2005), Batman, Lieutenant James Gordon, and new District Attorney Harvey Dent successfully begin to round up the criminals that plague Gotham City, until a mysterious and sadistic criminal mastermind known only as "The Joker" appears in Gotham, creating a new wave of chaos. Batman's struggle against The Joker becomes deeply personal, forcing him to''',
      posterPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      backdropPath: '/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      isBookmark: false,
      //genre: 'Action, Science Fiction, Drama',
      voteAverage: 4.5,
      releaseDate: 'March 2008',
    ),
    Movie(
      id: 3,
      title: 'Pulp Fiction',
      overview:
          '''Jules Winnfield (Samuel L. Jackson) and Vincent Vega (John Travolta) are two hitmen who are out to retrieve a suitcase stolen from their employer, mob boss Marsellus Wallace (Ving Rhames). Wallace has also asked Vincent to take his wife Mia (Uma Thurman) out a few days later when Wallace himself will be out of town. Butch Coolidge (Bruce Willis) is an aging boxer who is p''',
      posterPath: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      backdropPath: '/d5iIlFn5s0ImszYzBPb8JPIfbXD.jpg',
      isBookmark: false,
      //genre: 'Action, Science Fiction, Drama',
      voteAverage: 4.5,
      releaseDate: 'March 2004',
    ),
    Movie(
      id: 4,
      title: 'The Godfather 2',
      overview:
          '''The Godfather "Don" Vito Corleone is the head of the Corleone mafia family in New York. He is at the event of his daughter's wedding. Michael, Vito's youngest son and a decorated WWII Marine is also present at the wedding. Michael seems to be uninterested in being a part of the family business. Vito is a powerful man, and is kind to all those who give him respect but is ruthless against''',
      posterPath: '/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      backdropPath: '/3bhkrj58Vtu7enYsRolD1fZdja1.jpg',
      isBookmark: false,
      //genre: 'Action, Science Fiction, Drama',
      voteAverage: 4.5,
      releaseDate: 'March 2010',
    ),
  ];
}

extension ListValidation on List? {
  bool isListEmptyOrNull() => this == null || this!.isEmpty;
  bool isListNotEmptyOrNull() => this != null && this!.isNotEmpty;
}
