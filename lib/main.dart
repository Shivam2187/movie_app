import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stage_app/core/local_storage.dart';
import 'package:stage_app/core/locator.dart';

import 'core/connectivity_service.dart';
import 'presentation/providers/movie_provider.dart';
import 'utils/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Local DB
  await LocalStorage.init();

  DependencyInjection().setupLocator();

  ConnectivityService().checkConnectivity();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => MovieProvider(),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: routerConfig,
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
