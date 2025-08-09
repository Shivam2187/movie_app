import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/data/models/movie.dart';

import '../../utils/constants.dart';
import '../providers/movie_provider.dart';

class MovieDetailScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailScreen({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 12,
        backgroundColor: Colors.blue,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.75,
                      child: CachedNetworkImage(
                          imageUrl: MovieConstant.baseImageUrl +
                              (movie.backdropPath ?? ''),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: double.infinity,
                          fit: BoxFit.fill,
                          placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              )),
                    ),
                    Positioned(
                      top: 16,
                      left: 10,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 10,
                      child: IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
            MovieImageWithRating(movie: movie),
            const Divider(
              thickness: 2,
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Movie Overview',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(movie.overview ?? '',
                  style: const TextStyle(color: Colors.black)),
            ),
            const Divider(
              thickness: 2,
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(MovieConstant.trailers,
                  style: TextStyle(color: Colors.red, fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }
}

class MovieImageWithRating extends StatelessWidget {
  final Movie movie;
  const MovieImageWithRating({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              movieProvider.isBookmark(movie.id)
                  ? Icons.bookmark
                  : Icons.bookmark_border,
              color: Colors.red,
              size: 32,
            ),
            onPressed: () => movieProvider.toggleBookmark(movie),
          ),
          const SizedBox(width: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                movie.title ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(movie.releaseDate ?? '',
                  style: const TextStyle(color: Colors.black)),
              Row(
                children: [
                  Text(movie.voteAverage?.toStringAsPrecision(2) ?? '',
                      style: const TextStyle(color: Colors.black)),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 20),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
