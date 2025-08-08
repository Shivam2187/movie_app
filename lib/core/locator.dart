import 'package:get_it/get_it.dart';
import 'package:stage_app/core/api_service.dart';

final locator = GetIt.instance;

class DependencyInjection {
  void setupLocator() {
    locator.registerSingleton(ApiService());
  }
}
