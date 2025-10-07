import 'package:flutter/foundation.dart';

/// Logger simple para la aplicación
class Logger {
  final String className;

  const Logger(this.className);

  /// Log de información
  void info(String message) {
    if (kDebugMode) {
      print('ℹ️ [$className] $message');
    }
  }

  /// Log de error
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('❌ [$className] $message');
      if (error != null) print('Error: $error');
      if (stackTrace != null) print('StackTrace: $stackTrace');
    }
  }

  /// Log de advertencia
  void warning(String message) {
    if (kDebugMode) {
      print('⚠️ [$className] $message');
    }
  }

  /// Log de éxito
  void success(String message) {
    if (kDebugMode) {
      print('✅ [$className] $message');
    }
  }

  /// Log de debug
  void debug(String message) {
    if (kDebugMode) {
      print('🔍 [$className] $message');
    }
  }
}
