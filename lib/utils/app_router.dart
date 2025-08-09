import 'package:go_router/go_router.dart';
import 'package:stage_app/presentation/screens/bookmark_page.dart';
import 'package:stage_app/presentation/screens/favourite_page.dart';
import 'package:stage_app/utils/constants.dart';

import '../data/models/movie.dart';
import '../presentation/screens/error_screen.dart';
import '../presentation/screens/movie_detail_page.dart';
import '../presentation/screens/movie_list_page.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      name:
          'home', // Optional, add name to your routes. Allows you navigate by name instead of path
      path: '/',
      builder: (context, state) => const MovieListScreen(),
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
      builder: (context, state) => const ErrorScreen(),
    ),
    GoRoute(
      name: 'BookmarkPage',
      path: NavigationPaths.bookmarkPage,
      builder: (context, state) => const BookmarkPage(),
    ),
  ],
);
