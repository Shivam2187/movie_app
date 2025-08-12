import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/presentation/providers/movie_provider.dart';
import 'package:stage_app/presentation/widgets/movie_card.dart';
import 'package:stage_app/utils/constants.dart';

class DebouncedSearchedMoies extends StatefulWidget {
  const DebouncedSearchedMoies({
    super.key,
  });

  @override
  State<DebouncedSearchedMoies> createState() => _DebouncedSearchedMoiesState();
}

class _DebouncedSearchedMoiesState extends State<DebouncedSearchedMoies> {
  late ScrollController _controller;
  final TextEditingController _textController = TextEditingController();

  Timer? _debounce;
  bool isDebounceSearchActive = false;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
    inIt();
  }

  void inIt() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final provider = Provider.of<MovieProvider>(context, listen: false);
        _textController.text = provider.getDebouncedSearchQuery;
        provider.setDebouncedSearchQuery('');
        _controller.addListener(() {
          if (_controller.position.pixels ==
                  _controller.position.maxScrollExtent &&
              !provider.isLoading) {
            provider.fetchDebouncedSearchMovies();
          }
        });
      },
    );
  }

  void _onSearchChanged(String query) {
    if (query.length < 3) return;
    setState(() {
      isDebounceSearchActive = true;
    });
    // Cancel previous timer if still active
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Start a new debounce timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final provider = Provider.of<MovieProvider>(context, listen: false);

      await provider.fetchDebouncedSearchMovies(reset: true);
      setState(() {
        isDebounceSearchActive = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          return Column(
            children: [
              /// Search bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _textController,
                  decoration: _textFieldDecoration(),
                  onChanged: (value) {
                    movieProvider.setDebouncedSearchQuery(value);
                    _onSearchChanged(value);
                  },
                  autofocus: true,
                ),
              ),
              if (isDebounceSearchActive)
                const Expanded(
                  child: Center(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator()),
                  ),
                ),
              if (!isDebounceSearchActive &&
                  movieProvider.getTotalDebouncedMovies.isEmpty &&
                  movieProvider.getDebouncedSearchQuery.length > 2)
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        '${MovieConstant.notMatchingWithSearch} ${movieProvider.getDebouncedSearchQuery}',
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
                  itemCount: movieProvider.getTotalDebouncedMovies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    final movie = movieProvider.getTotalDebouncedMovies[index];

                    return MovieCard(
                      movie: movie,
                      onPressed: () => movieProvider.toggleBookmark(movie.id),
                      isBookmarked: movieProvider.isBookmark(movie.id),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  InputDecoration _textFieldDecoration() {
    return const InputDecoration(
      hintText: "Type a movie name...",
      prefixIcon: Icon(Icons.search),
      helper: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(
          'Enter at least 3 characters to search...',
          style: TextStyle(color: Colors.brown),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
    );
  }
}
