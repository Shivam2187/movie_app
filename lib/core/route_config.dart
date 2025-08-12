import 'package:go_router/go_router.dart';
import 'package:stage_app/presentation/screens/bookmark_page.dart';
import 'package:stage_app/presentation/screens/debounced_searched_moies.dart'
    show DebouncedSearchedMoies;
import 'package:stage_app/presentation/screens/favourite_page.dart';
import 'package:stage_app/presentation/screens/movie_home_page.dart';
import 'package:stage_app/utils/constants.dart';

import '../data/models/movie.dart';
import '../presentation/screens/error_page.dart';
import '../presentation/screens/movie_detail_page.dart';

final routeConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const MovieHomePage(),
    ),
    GoRoute(
      name: 'Movie Details Screen',
      path: NavigationPaths.movieDetailsScreen,
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailScreen(movie: movie);
      },
    ),
    GoRoute(
      name: 'FavouriteScreen',
      path: NavigationPaths.favouriteScreen,
      builder: (context, state) => const FavouriteScreen(),
    ),
    GoRoute(
      name: 'errorScreen',
      path: NavigationPaths.errorScreen,
      builder: (context, state) => const ErrorPage(),
    ),
    GoRoute(
      name: 'BookmarkPage',
      path: NavigationPaths.bookmarkPage,
      builder: (context, state) => const BookmarkPage(),
    ),
    GoRoute(
      name: 'DebouncedSearchedMoies',
      path: NavigationPaths.debouncedSearchedMoies,
      builder: (context, state) => const DebouncedSearchedMoies(),
    ),
  ],
);
