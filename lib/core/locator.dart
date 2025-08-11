import 'package:get_it/get_it.dart';
import 'package:stage_app/presentation/providers/gloabl_store.dart';

final locator = GetIt.instance;

class DependencyInjection {
  void setupLocator() {
    locator.registerSingleton(GloablStore());
  }
}
