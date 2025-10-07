# 🏗️ Arquitectura de Recurseo

## Principios Fundamentales

### 1. Clean Architecture
Separación clara entre capas:
- **Presentation:** UI y manejo de estado
- **Domain:** Lógica de negocio pura
- **Data:** Acceso a datos (APIs, local storage)

### 2. Feature-First Organization
Cada funcionalidad es independiente y autocontenida, facilitando:
- Desarrollo en paralelo por equipos
- Testing aislado
- Mantenimiento y escalabilidad

### 3. Dependency Inversion
Las capas externas dependen de las internas, nunca al revés.

## 📂 Estructura Detallada

### Core Layer (`lib/core/`)
Código compartido por toda la aplicación:

#### `config/`
- **api_config.dart:** URLs, timeouts, headers del backend
- **router_config.dart:** Configuración de rutas con go_router

#### `constants/`
- **app_colors.dart:** Paleta de colores (Material 3)
- **app_sizes.dart:** Espaciados, radios, elevaciones

#### `theme/`
- **app_theme.dart:** Tema completo de Material 3

#### `utils/`
- **result.dart:** Tipo Result<T> para manejo de errores funcional
- **logger.dart:** Logger simple para debugging

#### `widgets/`
Widgets reutilizables (botones, cards, etc.) - por crear según necesidad

---

### Features Layer (`lib/features/`)

Cada feature sigue esta estructura estándar:

```
feature_name/
├── data/
│   ├── datasources/
│   │   ├── feature_remote_datasource.dart  # API calls
│   │   └── feature_local_datasource.dart   # SharedPreferences, etc.
│   ├── models/
│   │   └── feature_model.dart              # DTOs + toJson/fromJson
│   └── repositories/
│       └── feature_repository_impl.dart    # Implementación
├── domain/
│   ├── entities/
│   │   └── feature_entity.dart             # Objetos de negocio puros
│   ├── repositories/
│   │   └── feature_repository.dart         # Contratos (abstract)
│   └── usecases/
│       └── get_feature_usecase.dart        # Lógica de negocio
└── presentation/
    ├── providers/
    │   └── feature_provider.dart           # Estado con Riverpod
    ├── screens/
    │   └── feature_screen.dart             # Pantallas completas
    └── widgets/
        └── feature_widget.dart             # Componentes de UI
```

#### Features Implementados:

**1. auth/** - Autenticación y Onboarding
- Splash screen
- Welcome screen
- Login/Registro (por implementar)

**2. services/** - Catálogo de Servicios
- Home screen con bottom navigation
- Lista de categorías
- Búsqueda de servicios

**3. requests/** - Sistema de Solicitudes
- Crear solicitud
- Ver solicitudes
- Gestión de estados

**4. profile/** - Perfil de Usuario
- Perfil del cliente
- Perfil del proveedor
- Configuración

---

### Shared Layer (`lib/shared/`)

Lógica compartida entre features:

#### `models/`
Modelos de datos compartidos (User, Category, etc.)

#### `providers/`
- **dio_provider.dart:** Cliente HTTP configurado con interceptores

#### `repositories/`
Repositorios compartidos si son necesarios

---

## 🔄 Flujo de Datos

### Lectura (Query)
```
UI (Screen/Widget)
  ↓ consume
Provider (Riverpod)
  ↓ llama
UseCase
  ↓ usa
Repository (Interface)
  ↓ implementa
Repository Implementation
  ↓ consulta
DataSource (Remote/Local)
  ↓ retorna
Result<Entity>
```

### Escritura (Command)
```
UI (Screen/Widget)
  ↓ dispara acción
Provider (Riverpod)
  ↓ llama
UseCase
  ↓ valida y ejecuta
Repository
  ↓ persiste
DataSource
  ↓ retorna
Result<void>
```

---

## 🎯 Patrón Result<T>

Usamos `Result<T>` para manejo de errores sin excepciones:

```dart
Result<User> result = await getUserUseCase.execute(id);

// Pattern matching (Dart 3)
switch (result) {
  case Success(data: final user):
    // Manejar éxito
    print(user.name);
  case Failure(message: final error):
    // Manejar error
    print(error);
}

// O con helpers
result.whenSuccess((user) => print(user.name));
result.whenFailure((error) => showError(error));
```

---

## 🔌 State Management con Riverpod

### Providers Comunes:

```dart
// Provider simple (inmutable)
final configProvider = Provider<AppConfig>((ref) {
  return AppConfig();
});

// StateProvider (estado mutable simple)
final counterProvider = StateProvider<int>((ref) => 0);

// FutureProvider (datos asíncronos)
final userProvider = FutureProvider<User>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return await repo.getCurrentUser();
});

// StateNotifierProvider (estado complejo)
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
```

---

## 🛣️ Routing con go_router

### Definición de Rutas:
```dart
GoRoute(
  path: '/services/:id',
  name: 'service-detail',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ServiceDetailScreen(serviceId: id);
  },
)
```

### Navegación:
```dart
// Navegar
context.go('/services/123');
context.push('/services/123');  // Preserva historial

// Con parámetros
context.goNamed('service-detail', pathParameters: {'id': '123'});

// Regresar
context.pop();
```

---

## 🎨 Theming

### Uso de Colores:
```dart
// Desde constants
Container(color: AppColors.primary)

// Desde tema
Container(color: Theme.of(context).colorScheme.primary)
```

### Uso de Tamaños:
```dart
Padding(padding: EdgeInsets.all(AppSizes.paddingMd))
BorderRadius.circular(AppSizes.radiusMd)
```

---

## 📝 Convenciones de Código

### Nombres de Archivos:
- Screens: `*_screen.dart`
- Widgets: `*_widget.dart`
- Providers: `*_provider.dart`
- Models: `*_model.dart`
- Entities: `*_entity.dart`

### Nombres de Clases:
```dart
// Screens
class HomeScreen extends StatelessWidget { }

// Providers
final servicesProvider = FutureProvider<List<Service>>(...);

// Repositories
abstract class ServiceRepository { }
class ServiceRepositoryImpl implements ServiceRepository { }
```

### Imports:
```dart
// 1. Dart
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages
import 'package:riverpod/riverpod.dart';

// 4. Internos (absolute imports)
import 'package:recurseo/core/utils/result.dart';
```

---

## 🧪 Testing Strategy

### Unit Tests
Testear UseCases y lógica de negocio pura

### Widget Tests
Testear componentes individuales

### Integration Tests
Testear flujos completos de usuario

### Ejemplo:
```dart
test('getUserUseCase returns user when successful', () async {
  // Arrange
  final mockRepo = MockUserRepository();
  final useCase = GetUserUseCase(mockRepo);

  // Act
  final result = await useCase.execute('123');

  // Assert
  expect(result, isA<Success<User>>());
});
```

---

## 🔐 Seguridad

### API Keys
- **Nunca** hardcodear en código
- Usar variables de entorno o configuración externa
- Encriptar tokens en local storage

### Autenticación
- JWT tokens con refresh token
- Almacenar en secure storage (flutter_secure_storage)
- Interceptor de Dio para agregar token automáticamente

---

## 🚀 Build & Deploy

### Ambientes:
- Development: `flutter run`
- Staging: `flutter run --flavor staging`
- Production: `flutter build apk --release`

### Versionado:
Seguir Semantic Versioning (semver):
- MAJOR: Cambios incompatibles
- MINOR: Nueva funcionalidad compatible
- PATCH: Bug fixes

---

## 📚 Recursos

- [Flutter Docs](https://docs.flutter.dev/)
- [Riverpod Docs](https://riverpod.dev/)
- [go_router Docs](https://pub.dev/packages/go_router)
- [Material 3 Guidelines](https://m3.material.io/)

---

**Última actualización:** 2025-10-07
