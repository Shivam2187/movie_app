import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/connectivity_service.dart';
import '../../utils/constants.dart';
import '../providers/provider.dart';
import '../widgets/movie_card.dart';
import 'favourite_page.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ConnectivityService().startListening();
      final provider = Provider.of<MovieProvider>(context, listen: false);

      provider.fetchMovies();
      provider.currentPageNumber =
          ((int.tryParse(provider.currentPageNumber) ?? 0) + 1).toString();
      provider.fetchMovies(isPrefetch: true);

      _controller.addListener(() {
        if (_controller.position.pixels ==
                _controller.position.maxScrollExtent &&
            !provider.isLoading) {
          provider.loadMoreMovies();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    // Api error handling
    if (movieProvider.hasError) {
      Future.microtask(() {
        context.push(NavigationPaths.errorScreen).then((value) {
          if (value == true) {
            movieProvider.fetchMovies();
            movieProvider.fetchMovies(isPrefetch: true);
          }
        });
      });
    }

    return ValueListenableBuilder<bool?>(
      valueListenable: isNetworkAvailable,
      builder: (context, hasError, child) {
        if (needToShowNetworkSnackBar) {
          internetStatusSnackbar();
        }

        if (isNetworkAvailable.value == false) {
          return const FavouriteScreen();
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _appBar(),
          body: movieProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: _textFieldDecoration(),
                        onChanged: movieProvider.setSearchQuery,
                      ),
                    ),
                    if (showFavorites && movieProvider.favoriteMovies.isEmpty)
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
                            ? movieProvider.favoriteMovies.length
                            : movieProvider.movies.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.6,
                        ),
                        itemBuilder: (context, index) {
                          final movie = showFavorites
                              ? movieProvider.favoriteMovies[index]
                              : movieProvider.movies[index];

                          return MovieCard(
                            movie: movie,
                            isFavourite: movieProvider.isFavorite(movie.id),
                            onPressed: () =>
                                movieProvider.toggleFavorite(movie),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 48,
      title: const Text(
        MovieConstant.movieScreenAppbarTiltle,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
      actions: [
        Switch(
          value: showFavorites,
          onChanged: (value) {
            setState(() {
              showFavorites = value;
            });
          },
          activeColor: Colors.red,
          inactiveThumbColor: Colors.white,
        )
      ],
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu, color: Colors.white),
      ),
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
