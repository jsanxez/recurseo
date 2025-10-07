/// Clase para manejar resultados de operaciones que pueden fallar
/// Basada en el patrón Result/Either
sealed class Result<T> {
  const Result();
}

/// Resultado exitoso
class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

/// Resultado con error
class Failure<T> extends Result<T> {
  final String message;
  final dynamic error;
  final StackTrace? stackTrace;

  const Failure({
    required this.message,
    this.error,
    this.stackTrace,
  });
}

/// Extensiones útiles para Result
extension ResultExtension<T> on Result<T> {
  /// Verifica si el resultado es exitoso
  bool get isSuccess => this is Success<T>;

  /// Verifica si el resultado es un error
  bool get isFailure => this is Failure<T>;

  /// Obtiene los datos si es exitoso, null si es error
  T? get dataOrNull => switch (this) {
        Success(data: final data) => data,
        Failure() => null,
      };

  /// Obtiene el mensaje de error si falló, null si fue exitoso
  String? get errorOrNull => switch (this) {
        Success() => null,
        Failure(message: final message) => message,
      };

  /// Ejecuta una función cuando el resultado es exitoso
  void whenSuccess(void Function(T data) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
  }

  /// Ejecuta una función cuando el resultado es un error
  void whenFailure(void Function(String message) action) {
    if (this is Failure<T>) {
      action((this as Failure<T>).message);
    }
  }

  /// Transforma el resultado aplicando una función
  Result<R> map<R>(R Function(T) transform) {
    return switch (this) {
      Success(data: final data) => Success(transform(data)),
      Failure(
        message: final message,
        error: final error,
        stackTrace: final stackTrace
      ) =>
        Failure(message: message, error: error, stackTrace: stackTrace),
    };
  }
}
