import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/presentation/widgets/movie_card.dart';
import 'package:stage_app/utils/constants.dart';

import '../providers/movie_provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: favoriteProvider.getBookmarkMovies.isNotEmpty
          ? Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: favoriteProvider.getBookmarkMovies.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      final movie = favoriteProvider.getBookmarkMovies[index];
                      return MovieCard(
                        movie: movie,
                        onPressed: () => favoriteProvider.toggleBookmark(movie),
                        isBookmarked: favoriteProvider.isBookmark(movie.id),
                      );
                    },
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(MovieConstant.noFavouriteMovies),
            ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      toolbarHeight: 48,
      title: const Text(
        MovieConstant.favouriteMovies,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            )),
      ],
      leading: IconButton(
        onPressed: () {},
        icon: const Icon(Icons.menu, color: Colors.white),
      ),
    );
  }
}
