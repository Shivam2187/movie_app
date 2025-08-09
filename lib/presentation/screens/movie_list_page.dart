import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/presentation/screens/error_screen.dart';
import 'package:stage_app/presentation/widgets/appbar.dart' show buildAppBar;

import '../../core/connectivity_service.dart';
import '../../utils/constants.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'favourite_page.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({
    super.key,
  });

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  bool showFavorites = false;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    inIt();
  }

  @override
  void dispose() {
    ConnectivityService().dispose();
    super.dispose();
  }

  void inIt() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        ConnectivityService().startListening();
        final provider = Provider.of<MovieProvider>(context, listen: false);
        await provider.fetchMovies();
        _controller.addListener(() {
          if (_controller.position.pixels ==
                  _controller.position.maxScrollExtent &&
              !provider.isLoading) {
            provider.fetchMovies();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieProvider>(
      builder: (context, movieProvider, child) {
        return ValueListenableBuilder<bool?>(
          valueListenable: isNetworkAvailable,
          builder: (context, hasError, child) {
            if (needToShowNetworkSnackBar) {
              internetStatusSnackbar();
            }

            if (isNetworkAvailable.value == false) {
              return const FavouriteScreen();
            }
            // Api error handling
            if (movieProvider.hasError) {
              return ErrorScreen(
                onPressed: () {
                  movieProvider.fetchMovies();
                },
              );
            } else if (movieProvider.isLoading) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            return Scaffold(
              backgroundColor: Colors.white,
              appBar: buildAppBar(
                context: context,
                title: MovieConstant.movieScreenAppbarTiltle,
                showFavorites: showFavorites,
                onChanged: (value) {
                  setState(() {
                    showFavorites = value;
                  });
                },
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: _textFieldDecoration(),
                      onChanged: movieProvider.setSearchQuery,
                    ),
                  ),
                  if (showFavorites && movieProvider.bookmarkMovies.isEmpty)
                    const Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            MovieConstant.noFavouriteMovies,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (movieProvider.movies.isEmpty && !showFavorites)
                    const Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            MovieConstant.notMatchingWithSearch,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: GridView.builder(
                      controller: _controller,
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: const EdgeInsets.all(8.0),
                      itemCount: showFavorites
                          ? movieProvider.bookmarkMovies.length
                          : movieProvider.movies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        final movie = showFavorites
                            ? movieProvider.bookmarkMovies[index]
                            : movieProvider.movies[index];

                        return MovieCard(
                          movie: movie,
                          isBookmark: movieProvider.isBookmark(movie.id),
                          onPressed: () => movieProvider.toggleBookmark(movie),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  InputDecoration _textFieldDecoration() {
    return const InputDecoration(
      hintText: MovieConstant.searchMoviesHintText,
      prefixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
    );
  }

  void internetStatusSnackbar() {
    if (isNetworkAvailable.value == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text(MovieConstant.noInternetConnection)),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
    if (isBackOnlineEnable && isNetworkAvailable.value == true) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(child: Text(MovieConstant.backOnline)),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      });
    }
    needToShowNetworkSnackBar = false;
  }
}
