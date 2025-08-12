import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/presentation/screens/error_page.dart';
import 'package:stage_app/presentation/widgets/appbar.dart' show buildAppBar;
import 'package:stage_app/utils/enum.dart';

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
  final TextEditingController _textController = TextEditingController();
  bool isLocalSearch = false;
  String _searchMode = SearchType.local.name;

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
        _textController.text = provider.getSearchQuery;
        provider.setSearchQuery('');

        ///get first local DB movies
        await provider.setInitialTotalMovies();
        await provider.fetchMovies();

        _controller.addListener(() async {
          /// while search operation api call will be block
          if (provider.getSearchQuery.trim().isNotEmpty) return;

          if (_controller.position.pixels >=
                  _controller.position.maxScrollExtent - 100 &&
              !provider.isLoading &&
              provider.hasMoviesMore) {
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
              // Api error handling
              if (movieProvider.hasError) {
                return ErrorPage(
                  onPressed: () {
                    movieProvider.fetchMovies();
                  },
                );
              } else if (movieProvider.isLoading &&
                  movieProvider.getMovies.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Column(
                children: [
                  /// Search bar
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: _searchMode == SearchType.local.name
                              ? TextFormField(
                                  controller: _textController,
                                  decoration: _textFieldDecoration(
                                    hintText: 'Search Loacl Movie...',
                                  ),
                                  onChanged: movieProvider.setSearchQuery,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    context.push(
                                        NavigationPaths.debouncedSearchedMoies);
                                  },
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: _textFieldDecoration(
                                        hintText: 'Search Network Movie...',
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.grey),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _searchMode,
                              icon: const Icon(Icons.arrow_drop_down,
                                  color: Colors.grey),
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 12),
                              items: [
                                DropdownMenuItem(
                                  value: SearchType.local.name,
                                  child: const Text("Local"),
                                ),
                                DropdownMenuItem(
                                  value: SearchType.network.name,
                                  child: const Text("Network"),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  setState(() => _searchMode = value);
                                }
                              },
                            ),
                          ),
                        )
                      ],
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
                                : '${MovieConstant.notMatchingWithSearch} \' ${movieProvider.getSearchQuery} \'',
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
                      itemCount: movieProvider.getMovies.length +
                          (movieProvider.isLoading &&
                                  movieProvider.getMovies.isNotEmpty
                              ? 1
                              : 0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                      ),
                      itemBuilder: (context, index) {
                        if (index < movieProvider.getMovies.length) {
                          final movie = movieProvider.getMovies[index];
                          return MovieCard(
                            movie: movie,
                            onPressed: () =>
                                movieProvider.toggleBookmark(movie.id),
                            isBookmarked: movieProvider.isBookmark(movie.id),
                          );
                        } else {
                          // Loader at the bottom
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                  if (!movieProvider.hasMoviesMore)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No More Movies...',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    )
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

  InputDecoration _textFieldDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText ?? MovieConstant.searchMoviesHintText,
      prefixIcon: const Icon(Icons.search),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14.0),
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
