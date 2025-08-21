import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:movie_app/core/local_storage.dart';
import 'package:movie_app/core/locator.dart';

import 'core/connectivity_service.dart';
import 'presentation/providers/movie_provider.dart';
import 'core/route_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Local DB
  await LocalStorage.init();

  DependencyInjection().setupLocator();

  ConnectivityService.instance.checkConnectivity();
  await dotenv.load();
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
        routerConfig: routeConfig,
        title: 'Movie App',
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
