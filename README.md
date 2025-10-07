# Recurseo 🔧

Marketplace de servicios profesionales - Similar a GetNinjas/Timbrit

## 📱 Sobre el Proyecto

Recurseo es una aplicación móvil que conecta clientes con profesionales de servicios. El proyecto está enfocado en crear un MVP (Producto Mínimo Viable) funcional con arquitectura escalable.

## 🏗️ Arquitectura

El proyecto utiliza **Clean Architecture** combinada con una estructura **Feature-First**:

```
lib/
├── core/              # Funcionalidades compartidas
│   ├── config/       # Configuraciones (API, Router)
│   ├── constants/    # Constantes (colores, tamaños)
│   ├── theme/        # Tema personalizado Material 3
│   ├── utils/        # Utilidades (Result, Logger)
│   └── widgets/      # Widgets reutilizables
│
├── features/          # Módulos por funcionalidad
│   ├── auth/         # Autenticación y onboarding
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── services/     # Catálogo de servicios
│   ├── requests/     # Sistema de solicitudes
│   └── profile/      # Perfil de usuario
│
└── shared/            # Lógica compartida
    ├── models/       # Modelos de datos
    ├── providers/    # Providers globales (Riverpod)
    └── repositories/ # Repositorios de datos
```

## 🛠️ Stack Tecnológico

- **Framework:** Flutter 3.35.5
- **State Management:** Riverpod 2.6.1
- **Routing:** go_router 14.8.1
- **HTTP Client:** Dio 5.7.0
- **Local Storage:** SharedPreferences 2.3.3

## 🚀 Comenzar

### Prerrequisitos

- Flutter SDK 3.35.5 o superior
- Dart 3.9.2 o superior

### Instalación

```bash
# Clonar repositorio
git clone [url-del-repo]

# Instalar dependencias
flutter pub get

# Ejecutar en debug
flutter run

# Ejecutar en un dispositivo específico
flutter run -d [device-id]
```

### Comandos Útiles

```bash
# Analizar código
flutter analyze

# Formatear código
flutter format lib/

# Ejecutar tests
flutter test

# Generar build
flutter build apk  # Android
flutter build ios  # iOS
```

## 📦 Estructura de Features

Cada feature sigue esta estructura:

```
feature_name/
├── data/
│   ├── datasources/    # APIs, local storage
│   ├── models/         # DTOs y mappers
│   └── repositories/   # Implementación de repos
├── domain/
│   ├── entities/       # Entidades de negocio
│   ├── repositories/   # Contratos de repos
│   └── usecases/       # Casos de uso
└── presentation/
    ├── providers/      # Estado con Riverpod
    ├── screens/        # Pantallas
    └── widgets/        # Widgets específicos
```

## 🎨 Tema y Diseño

- **Design System:** Material 3
- **Paleta de colores:** Indigo (Primary) + Verde (Secondary)
- **Fuente:** Sistema por defecto
- **Componentes:** Totalmente personalizados

## 📋 Roadmap - MVP

### ✅ Fase 1: Fundación & Arquitectura
- [x] Estructura de carpetas
- [x] Configuración de dependencias
- [x] Sistema de tema Material 3
- [x] Arquitectura base (Providers, Result, Logger)
- [x] Pantallas base y routing

### 🔄 Fase 2: Autenticación (Próximo)
- [ ] Pantallas de Login/Registro
- [ ] Integración con backend
- [ ] Persistencia de sesión

### 📝 Fase 3: Perfiles de Usuario
- [ ] Perfil de Cliente
- [ ] Perfil de Proveedor
- [ ] Edición de perfil

### 🛍️ Fase 4: Catálogo de Servicios
- [ ] Lista de categorías
- [ ] Búsqueda y filtrado
- [ ] Detalle de servicio

### 📮 Fase 5: Sistema de Solicitudes
- [ ] Crear solicitud
- [ ] Ver solicitudes (cliente)
- [ ] Responder solicitudes (proveedor)

### 💬 Fase 6: Comunicación
- [ ] Chat básico
- [ ] Notificaciones push

## 🔧 Configuración del Backend

Por defecto, el proyecto apunta a:
```dart
// lib/core/config/api_config.dart
static const String baseUrl = 'https://api.recurseo.com';
```

Modifica esta URL según tu backend.

## 🧪 Testing

```bash
# Ejecutar todos los tests
flutter test

# Ejecutar con cobertura
flutter test --coverage
```

## 📝 Convenciones de Código

- **Nombres:** PascalCase para clases, camelCase para variables
- **Archivos:** snake_case.dart
- **Imports:** Ordenados (dart, flutter, packages, relative)
- **Comentarios:** Solo cuando sea necesario explicar "por qué", no "qué"

## 🤝 Contribuir

Este es un proyecto en desarrollo activo. Sugerencias y mejoras son bienvenidas.

## 📄 Licencia

Proyecto privado - Todos los derechos reservados

---

**Versión Actual:** 0.1.0 (MVP en desarrollo)
**Última Actualización:** 2025-10-07
