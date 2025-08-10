import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/presentation/screens/error_page.dart';
import 'package:stage_app/presentation/widgets/appbar.dart' show buildAppBar;

import '../../core/connectivity_service.dart';
import '../../utils/constants.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class MovieCatalogHomePage extends StatefulWidget {
  const MovieCatalogHomePage({
    super.key,
  });

  @override
  State<MovieCatalogHomePage> createState() => _MovieCatalogHomePageState();
}

class _MovieCatalogHomePageState extends State<MovieCatalogHomePage> {
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
        provider.setSearchQuery('');
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
    return ValueListenableBuilder<bool?>(
      valueListenable: isNetworkAvailable,
      builder: (context, hasError, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: buildAppBar(
            context: context,
            title: MovieConstant.movieScreenAppbarTiltle,
          ),
          body: Consumer<MovieProvider>(
            builder: (context, movieProvider, child) {
              if (needToShowNetworkSnackBar) {
                internetStatusSnackbar();
              }

              // if (isNetworkAvailable.value == false) {
              //   return const Center(
              //     child: Text(
              //       'You are Offline!',
              //       style: TextStyle(
              //         fontSize: 20,
              //         fontWeight: FontWeight.bold,
              //       ),
              //     ),
              //   );
              // }
              // Api error handling
              if (movieProvider.hasError) {
                return ErrorPage(
                  onPressed: () {
                    movieProvider.fetchMovies();
                  },
                );
              } else if (movieProvider.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  /// Search bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        context.push(NavigationPaths.debouncedSearchedMoies);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: TextEditingController(
                            text: movieProvider.getSearchQuery,
                          ),
                          decoration: _textFieldDecoration(),
                          onChanged: movieProvider.setSearchQuery,
                        ),
                      ),
                    ),
                  ),
                  if (movieProvider.getMovies.isEmpty)
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            movieProvider.getSearchQuery.isEmpty
                                ? MovieConstant.notMovieToDisplay
                                : '${MovieConstant.notMatchingWithSearch} ${movieProvider.getSearchQuery}',
                            style: const TextStyle(
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
                      itemCount: movieProvider.getMovies.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        final movie = movieProvider.getMovies[index];

                        return MovieCard(
                          movie: movie,
                          onPressed: () => movieProvider.toggleBookmark(movie),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.push(NavigationPaths.bookmarkPage);
            },
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
            ),
            label: const Text(
              'Saved Movies',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
          ),
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
