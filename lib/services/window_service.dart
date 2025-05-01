import 'dart:io';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

class WindowService {
  Future<void> initializeWindow() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        WindowOptions windowOptions = const WindowOptions(
          size: Size(1000, 800),
          minimumSize: Size(600, 500),
          center: true,
          backgroundColor: Colors.transparent,
          skipTaskbar: false,
          titleBarStyle: TitleBarStyle.normal,
        );
        await windowManager.waitUntilReadyToShow(windowOptions, () async {
          await windowManager.show();
          await windowManager.focus();
        });
      } catch (e) {
        debugPrint('Window initialization error: $e');
        // 处理错误
      }
    }
  }
}
