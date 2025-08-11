import 'package:flutter/material.dart';
import 'package:stage_app/presentation/providers/movie_provider.dart';
import 'package:stage_app/presentation/widgets/appbar.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/presentation/widgets/movie_card.dart';
import 'package:stage_app/utils/constants.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({
    super.key,
  });

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  void initState() {
    super.initState();
    inIt();
  }

  void inIt() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        final provider = Provider.of<MovieProvider>(context, listen: false);
        provider.setBookmarkSearchQuery('');
      },
    );
  }

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
                  controller: TextEditingController(
                      text: provider.getBookmarkSearchQuery),
                  decoration: _textFieldDecoration(),
                  onChanged: provider.setBookmarkSearchQuery,
                ),
              ),
              if (bookmarkMovies.isEmpty)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        provider.getBookmarkSearchQuery.isEmpty
                            ? 'No Bookmarks Available'
                            : '${MovieConstant.notMatchingWithSearch} ${provider.getBookmarkSearchQuery} ',
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
      hintText: 'Search Saved Movies...',
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
