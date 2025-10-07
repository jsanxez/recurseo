import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Provider de SharedPreferences
/// Este provider se inicializa en main.dart con una instancia real
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider debe ser inicializado en main.dart',
  );
});
