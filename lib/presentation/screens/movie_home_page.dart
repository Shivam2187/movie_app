import 'package:flutter/material.dart';
import 'package:movie_app/core/connectivity_service.dart';
import 'package:movie_app/presentation/providers/movie_provider.dart';
import 'package:movie_app/presentation/widgets/now_playing_movies_tab.dart';

import 'package:movie_app/presentation/widgets/trending_movies_tab.dart';
import 'package:movie_app/presentation/widgets/movie_dashboard_appbar.dart';
import 'package:provider/provider.dart';

class MovieHomePage extends StatefulWidget {
  const MovieHomePage({
    super.key,
  });

  @override
  State<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends State<MovieHomePage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MovieProvider>(context, listen: false);

      ///set all Local DB movies to  totalMovies List(Display)
      provider.setInitialTotalMovies();
      ConnectivityService.instance.startListening();
    });
    _tabController = TabController(length: tabWidgets.length, vsync: this);
  }

  @override
  void dispose() {
    ConnectivityService.instance.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> tabWidgets = [
    const NowPlayingMoviesTab(),
    const TrendingMoviesTab(),
  ];
  List<Widget> tabsName = [
    const Tab(
      icon: Icon(
        Icons.movie_outlined,
        size: 18,
      ),
      child: Text(
        'Now Playing',
        style: TextStyle(fontSize: 12),
      ),
    ),
    const Tab(
      icon: Icon(
        Icons.trending_up,
        size: 18,
      ),
      child: Text(
        'Trending Movies',
        style: TextStyle(fontSize: 12),
      ),
    ),

    // Tab(text: 'Call History'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: movieDashboardAppBar(
        context: context,
        tabsName: tabsName,
        title: 'Movies',
        tabController: _tabController,
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabWidgets,
      ),
    );
  }
}
