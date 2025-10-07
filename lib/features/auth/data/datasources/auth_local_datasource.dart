import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/auth/data/models/user_model.dart';

/// DataSource local para almacenar datos de autenticación
class AuthLocalDataSource {
  final SharedPreferences _prefs;
  final _logger = const Logger('AuthLocalDataSource');

  static const String _keyAccessToken = 'auth_access_token';
  static const String _keyRefreshToken = 'auth_refresh_token';
  static const String _keyUser = 'auth_user';
  static const String _keyExpiresAt = 'auth_expires_at';

  AuthLocalDataSource(this._prefs);

  /// Guardar tokens y usuario
  Future<void> saveAuthData({
    required String accessToken,
    required String refreshToken,
    required UserModel user,
    required DateTime expiresAt,
  }) async {
    try {
      await Future.wait([
        _prefs.setString(_keyAccessToken, accessToken),
        _prefs.setString(_keyRefreshToken, refreshToken),
        _prefs.setString(_keyUser, jsonEncode(user.toJson())),
        _prefs.setString(_keyExpiresAt, expiresAt.toIso8601String()),
      ]);
      _logger.success('Auth data saved successfully');
    } catch (e, st) {
      _logger.error('Error saving auth data', e, st);
      rethrow;
    }
  }

  /// Obtener access token
  String? getAccessToken() {
    return _prefs.getString(_keyAccessToken);
  }

  /// Obtener refresh token
  String? getRefreshToken() {
    return _prefs.getString(_keyRefreshToken);
  }

  /// Obtener usuario guardado
  UserModel? getUser() {
    try {
      final userJson = _prefs.getString(_keyUser);
      if (userJson == null) return null;

      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      return UserModel.fromJson(userMap);
    } catch (e, st) {
      _logger.error('Error getting user from storage', e, st);
      return null;
    }
  }

  /// Obtener fecha de expiración
  DateTime? getExpiresAt() {
    final expiresAtStr = _prefs.getString(_keyExpiresAt);
    if (expiresAtStr == null) return null;

    try {
      return DateTime.parse(expiresAtStr);
    } catch (e) {
      _logger.error('Error parsing expires_at', e);
      return null;
    }
  }

  /// Verificar si el token está expirado
  bool isTokenExpired() {
    final expiresAt = getExpiresAt();
    if (expiresAt == null) return true;

    return DateTime.now().isAfter(expiresAt);
  }

  /// Limpiar todos los datos de autenticación
  Future<void> clearAuthData() async {
    try {
      await Future.wait([
        _prefs.remove(_keyAccessToken),
        _prefs.remove(_keyRefreshToken),
        _prefs.remove(_keyUser),
        _prefs.remove(_keyExpiresAt),
      ]);
      _logger.info('Auth data cleared');
    } catch (e, st) {
      _logger.error('Error clearing auth data', e, st);
      rethrow;
    }
  }

  /// Verificar si hay sesión activa
  bool hasActiveSession() {
    return getAccessToken() != null && !isTokenExpired();
  }
}
