/// Configuración de la aplicación
class AppConfig {
  AppConfig._();

  /// Modo de desarrollo con datos mock
  /// Cambiar a false cuando tengas un backend real
  static const bool useMockData = true;

  /// Nombre de la aplicación
  static const String appName = 'Recurseo';

  /// Versión de la aplicación
  static const String appVersion = '1.0.0';

  /// Mostrar logs en consola
  static const bool showLogs = true;
}
