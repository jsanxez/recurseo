/// Configuración global de la aplicación
class AppConfig {
  AppConfig._();

  /// Usar datos mock en lugar de API real
  /// true = modo desarrollo con datos de prueba
  /// false = modo producción con API real
  static const bool useMockData = true;

  /// URL base de la API (cuando useMockData = false)
  static const String apiBaseUrl = 'https://api.recurseo.com';

  /// Timeout para requests HTTP (en segundos)
  static const int requestTimeout = 30;

  /// Habilitar logs detallados
  static const bool enableDetailedLogs = true;
}
