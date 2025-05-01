import 'package:flutter/material.dart';

class Logger {
  void error(String message, [Exception? error, StackTrace? stackTrace]) {
    // 实现错误日志记录
    debugPrint('ERROR: $message');
    if (error != null) debugPrint('$error');
    if (stackTrace != null) debugPrint('$stackTrace');
  }
}
