import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movie_provider.dart';
import 'movie_card.dart';

class TrendingMoviesTab extends StatefulWidget {
  const TrendingMoviesTab({
    super.key,
  });

  @override
  State<TrendingMoviesTab> createState() => _TrendingMoviesTabState();
}

class _TrendingMoviesTabState extends State<TrendingMoviesTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchMovie(MovieProvider provider) async {
    /// Avoide multiple call
    if (provider.trendingMovies.isEmpty) {
      await provider.fetchTrendingMovie();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MovieProvider>(context, listen: false);

    return FutureBuilder(
      future: fetchMovie(provider),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return ErrorWidget(snapshot.error!);
        } else if (provider.trendingMovies.isEmpty) {
          return const Center(child: Text('No movies found'));
        }
        return GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(8.0),
          itemCount: provider.trendingMovies.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
          ),
          itemBuilder: (context, index) {
            final movie = provider.trendingMovies[index];
            return Consumer<MovieProvider>(builder: (context, provider, child) {
              return MovieCard(
                movie: movie,
                onPressed: () {
                  provider.toggleBookmark(movie.id);
                },
                isBookmarked: provider.isBookmark(movie.id),
              );
            });
          },
        );
      },
    );
  }
}
