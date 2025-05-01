import 'package:get_it/get_it.dart';
import '../database/database.dart';
import 'ardl_service.dart';
import 'settings_service.dart';
import 'window_service.dart';
import 'logger_service.dart';

final GetIt getIt = GetIt.instance;

class ServiceLocator {
  static Future<void> setup() async {
    // 数据库
    final db = AppDatabase();
    getIt.registerSingleton<AppDatabase>(db);

    // 服务
    getIt.registerSingleton<ISettingsService>(SettingsService(db));
    getIt.registerSingleton<WindowService>(WindowService());
    getIt.registerSingleton<Logger>(Logger());

    // ArdlService 需要 setState 回调，所以使用工厂模式
    getIt.registerFactoryParam<ArdlService, void Function(void Function()),
        void>(
      (setState, _) => ArdlService(
        db,
        setState,
        getIt<ISettingsService>(),
      ),
    );
  }
}
