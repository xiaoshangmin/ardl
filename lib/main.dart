// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'home_page.dart';
import 'providers/locale_provider.dart';
import 'services/window_service.dart';
import 'services/service_locator.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await windowManager.ensureInitialized();

    // 初始化依赖注入
    await ServiceLocator.setup();

    // 初始化窗口
    await getIt<WindowService>().initializeWindow();

    runApp(
      MultiProvider(
        providers: [
          Provider<AppDatabase>.value(value: getIt<AppDatabase>()),
          ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint('Application initialization error: $e');
    // 处理错误
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, child) {
        return MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          locale: localeProvider.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en'),
            Locale('zh'),
          ],
          home: const MyHomePage(),
        );
      },
    );
  }
}
