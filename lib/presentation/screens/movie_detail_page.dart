import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/data/models/movie.dart';

import '../../utils/constants.dart';
import '../providers/provider.dart';

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
            Stack(
              children: [
                Column(
                  children: [
                    AspectRatio(
                      aspectRatio: 1.75,
                      child: CachedNetworkImage(
                          imageUrl: MovieConstant.baseImageUrl +
                              (movie.backdropPath ?? ''),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(),
                              )),
                    ),
                    const SizedBox(
                      height: 200,
                    ),
                  ],
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: MovieImageWithRating(
                    movie: movie,
                  ),
                )
              ],
            ),
            const Divider(
              thickness: 2,
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
    final favoriteProvider = Provider.of<MovieProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          SizedBox(
            height: 200,
            child: AspectRatio(
              aspectRatio: .7,
              child: CachedNetworkImage(
                  imageUrl:
                      MovieConstant.baseImageUrl + (movie.posterPath ?? ''),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      )),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(movie.title ?? '',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
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
              const SizedBox(width: 24),
              IconButton(
                icon: Icon(
                  favoriteProvider.isFavorite(movie.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Colors.red,
                  size: 32,
                ),
                onPressed: () => favoriteProvider.toggleFavorite(movie),
              )
            ],
          ),
        ],
      ),
    );
  }
}
