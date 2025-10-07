/// Validadores de formularios
class Validators {
  Validators._();

  /// Valida que el campo no esté vacío
  static String? Function(String?) required([String? message]) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return message ?? 'Este campo es requerido';
      }
      return null;
    };
  }

  /// Valida formato de email
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'El email es requerido';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Ingresa un email válido';
    }

    return null;
  }

  /// Valida longitud mínima de contraseña
  static String? password(String? value, {int minLength = 6}) {
    if (value == null || value.isEmpty) {
      return 'La contraseña es requerida';
    }

    if (value.length < minLength) {
      return 'La contraseña debe tener al menos $minLength caracteres';
    }

    return null;
  }

  /// Valida que dos contraseñas coincidan
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Confirma tu contraseña';
    }

    if (value != originalPassword) {
      return 'Las contraseñas no coinciden';
    }

    return null;
  }

  /// Valida formato de teléfono (básico)
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Opcional
    }

    final phoneRegex = RegExp(r'^\+?[\d\s-]{8,}$');

    if (!phoneRegex.hasMatch(value)) {
      return 'Ingresa un número de teléfono válido';
    }

    return null;
  }

  /// Valida longitud mínima
  static String? minLength(String? value, int min, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length < min) {
      return '${fieldName ?? 'Este campo'} debe tener al menos $min caracteres';
    }

    return null;
  }

  /// Valida longitud máxima
  static String? maxLength(String? value, int max, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (value.length > max) {
      return '${fieldName ?? 'Este campo'} no puede exceder $max caracteres';
    }

    return null;
  }

  /// Combina múltiples validadores
  static String? Function(String?) compose(
    List<String? Function(String?)> validators,
  ) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }
}
