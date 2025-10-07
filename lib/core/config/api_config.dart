/// Configuración de la API
class ApiConfig {
  ApiConfig._();

  // TODO: Reemplazar con tu URL de backend
  static const String baseUrl = 'https://api.recurseo.com';

  // Endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String services = '/services';
  static const String requests = '/requests';
  static const String categories = '/categories';
  static const String conversations = '/conversations';
  static const String messages = '/messages';
  static const String reviews = '/reviews';
  static const String providers = '/providers';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static Map<String, String> get defaultHeaders => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
