import 'package:flutter/material.dart';
import 'package:stage_app/presentation/providers/movie_provider.dart';
import 'package:stage_app/presentation/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/presentation/widgets/movie_card.dart';
import 'package:stage_app/utils/constants.dart';

class BookmarkPage extends StatelessWidget {
  const BookmarkPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context: context,
        title: 'Bookmarks Movies',
        showBackButton: true,
      ),
      body: Consumer<MovieProvider>(
        builder: (context, provider, child) {
          final bookmarkMovies = provider.getBookmarkMovies;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: _textFieldDecoration(),
                  onChanged: provider.setSearchQuery,
                  initialValue: provider.getSearchQuery,
                ),
              ),
              if (bookmarkMovies.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        provider.getSearchQuery.isEmpty
                            ? 'No Bookmarks Available'
                            : '${MovieConstant.notMatchingWithSearch} ${provider.getSearchQuery} ',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              Expanded(
                child: GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: bookmarkMovies.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
                    final movie = bookmarkMovies[index];

                    return MovieCard(
                      movie: movie,
                      onPressed: () => provider.toggleBookmark(movie),
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
}
