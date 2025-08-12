import 'package:flutter/material.dart';
import 'package:stage_app/core/connectivity_service.dart';
import 'package:stage_app/presentation/widgets/now_playing_movies_tab.dart';

import 'package:stage_app/presentation/widgets/trending_movies_tab.dart';
import 'package:stage_app/presentation/widgets/movie_dashboard_appbar.dart';

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
      ConnectivityService().startListening();
    });
    _tabController = TabController(length: tabWidgets.length, vsync: this);
  }

  @override
  void dispose() {
    ConnectivityService().dispose();
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
