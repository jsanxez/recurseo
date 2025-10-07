import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/requests/data/datasources/request_mock_datasource.dart';
import 'package:recurseo/features/requests/data/datasources/request_remote_datasource.dart';
import 'package:recurseo/features/requests/data/repositories/request_repository_impl.dart';
import 'package:recurseo/features/requests/domain/entities/request_entity.dart';
import 'package:recurseo/features/requests/domain/repositories/request_repository.dart';
import 'package:recurseo/shared/providers/dio_provider.dart';

/// Provider del remote datasource
final requestRemoteDataSourceProvider =
    Provider<RequestRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return RequestRemoteDataSource(dio);
});

/// Provider del mock datasource
final requestMockDataSourceProvider = Provider<RequestMockDataSource>((ref) {
  return RequestMockDataSource();
});

/// Provider del repositorio de solicitudes
final requestRepositoryProvider = Provider<RequestRepository>((ref) {
  if (AppConfig.useMockData) {
    final mockDataSource = ref.watch(requestMockDataSourceProvider);
    return RequestRepositoryImpl(
      mockDataSource: mockDataSource,
      ref: ref,
    );
  } else {
    final remoteDataSource = ref.watch(requestRemoteDataSourceProvider);
    return RequestRepositoryImpl(
      remoteDataSource: remoteDataSource,
      ref: ref,
    );
  }
});

/// Provider de solicitudes del cliente actual
final clientRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final repository = ref.watch(requestRepositoryProvider);
  final authState = ref.watch(authNotifierProvider);

  if (authState is! Authenticated) {
    return [];
  }

  final result = await repository.getClientRequests(authState.user.id);

  return switch (result) {
    Success(data: final requests) => requests,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de solicitudes recibidas por el proveedor actual
final providerRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final repository = ref.watch(requestRepositoryProvider);
  final authState = ref.watch(authNotifierProvider);

  if (authState is! Authenticated) {
    return [];
  }

  final result = await repository.getProviderRequests(authState.user.id);

  return switch (result) {
    Success(data: final requests) => requests,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de solicitud por ID
final requestByIdProvider =
    FutureProvider.family<RequestEntity, String>((ref, requestId) async {
  final repository = ref.watch(requestRepositoryProvider);
  final result = await repository.getRequestById(requestId);

  return switch (result) {
    Success(data: final request) => request,
    Failure(message: final message) => throw Exception(message),
  };
});

/// Provider de solicitudes pendientes (cliente)
final pendingClientRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final requests = await ref.watch(clientRequestsProvider.future);
  return requests.where((r) => r.status == RequestStatus.pending).toList();
});

/// Provider de solicitudes activas (cliente)
final activeClientRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final requests = await ref.watch(clientRequestsProvider.future);
  return requests.where((r) =>
    r.status == RequestStatus.accepted ||
    r.status == RequestStatus.inProgress
  ).toList();
});

/// Provider de solicitudes completadas (cliente)
final completedClientRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final requests = await ref.watch(clientRequestsProvider.future);
  return requests.where((r) => r.status == RequestStatus.completed).toList();
});

/// Provider de solicitudes pendientes de respuesta (proveedor)
final pendingProviderRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final requests = await ref.watch(providerRequestsProvider.future);
  return requests.where((r) => r.status == RequestStatus.pending).toList();
});

/// Provider de solicitudes activas (proveedor)
final activeProviderRequestsProvider = FutureProvider<List<RequestEntity>>((ref) async {
  final requests = await ref.watch(providerRequestsProvider.future);
  return requests.where((r) =>
    r.status == RequestStatus.accepted ||
    r.status == RequestStatus.inProgress
  ).toList();
});
