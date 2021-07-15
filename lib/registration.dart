import 'package:get_it/get_it.dart';
import 'package:match_number/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Registration {
  final _getIt = GetIt.instance;
  Future<void> register() async {
    final preference = await SharedPreferences.getInstance();
    _getIt.registerSingleton(preference);
    _getIt.registerFactory(
        () => LocalStorageService(_getIt.get<SharedPreferences>()));
  }
}
