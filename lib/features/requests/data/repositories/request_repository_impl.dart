import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/config/app_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/requests/data/datasources/request_mock_datasource.dart';
import 'package:recurseo/features/requests/data/datasources/request_remote_datasource.dart';
import 'package:recurseo/features/requests/domain/entities/request_entity.dart';
import 'package:recurseo/features/requests/domain/repositories/request_repository.dart';

/// Implementación del repositorio de solicitudes
class RequestRepositoryImpl implements RequestRepository {
  final RequestRemoteDataSource? _remoteDataSource;
  final RequestMockDataSource? _mockDataSource;
  final Ref _ref;
  final _logger = const Logger('RequestRepositoryImpl');

  RequestRepositoryImpl({
    RequestRemoteDataSource? remoteDataSource,
    RequestMockDataSource? mockDataSource,
    required Ref ref,
  })  : _remoteDataSource = remoteDataSource,
        _mockDataSource = mockDataSource,
        _ref = ref {
    if (AppConfig.useMockData) {
      _logger.info('🎭 Using MOCK data for requests');
    }
  }

  String get _currentUserId {
    final authState = _ref.read(authNotifierProvider);
    if (authState is Authenticated) {
      return authState.user.id;
    }
    throw Exception('Usuario no autenticado');
  }

  @override
  Future<Result<RequestEntity>> createRequest({
    required String providerId,
    required String serviceId,
    required String title,
    required String description,
    String? location,
    DateTime? preferredDate,
    double? budgetFrom,
    double? budgetTo,
  }) async {
    try {
      final request = AppConfig.useMockData
          ? await _mockDataSource!.createRequest(
              clientId: _currentUserId,
              providerId: providerId,
              serviceId: serviceId,
              title: title,
              description: description,
              location: location,
              preferredDate: preferredDate,
              budgetFrom: budgetFrom,
              budgetTo: budgetTo,
            )
          : await _remoteDataSource!.createRequest(
              clientId: _currentUserId,
              providerId: providerId,
              serviceId: serviceId,
              title: title,
              description: description,
              location: location,
              preferredDate: preferredDate,
              budgetFrom: budgetFrom,
              budgetTo: budgetTo,
            );
      return Success(request);
    } catch (e) {
      return Failure(
        message: 'Error al crear la solicitud',
        error: e,
      );
    }
  }

  @override
  Future<Result<List<RequestEntity>>> getClientRequests(
      String clientId) async {
    try {
      final requests = AppConfig.useMockData
          ? await _mockDataSource!.getClientRequests(clientId)
          : await _remoteDataSource!.getClientRequests(clientId);
      return Success(requests);
    } catch (e) {
      return Failure(
        message: 'Error al obtener solicitudes del cliente',
        error: e,
      );
    }
  }

  @override
  Future<Result<List<RequestEntity>>> getProviderRequests(
      String providerId) async {
    try {
      final requests = AppConfig.useMockData
          ? await _mockDataSource!.getProviderRequests(providerId)
          : await _remoteDataSource!.getProviderRequests(providerId);
      return Success(requests);
    } catch (e) {
      return Failure(
        message: 'Error al obtener solicitudes del proveedor',
        error: e,
      );
    }
  }

  @override
  Future<Result<RequestEntity>> getRequestById(String id) async {
    try {
      final request = AppConfig.useMockData
          ? await _mockDataSource!.getRequestById(id)
          : await _remoteDataSource!.getRequestById(id);
      return Success(request);
    } catch (e) {
      return Failure(
        message: 'Error al obtener la solicitud',
        error: e,
      );
    }
  }

  @override
  Future<Result<RequestEntity>> acceptRequest({
    required String requestId,
    String? response,
  }) async {
    try {
      final request = AppConfig.useMockData
          ? await _mockDataSource!.acceptRequest(
              requestId: requestId,
              response: response,
            )
          : await _remoteDataSource!.updateRequestStatus(
              requestId,
              'accepted',
              response: response,
            );
      return Success(request);
    } catch (e) {
      return Failure(
        message: 'Error al aceptar la solicitud',
        error: e,
      );
    }
  }

  @override
  Future<Result<RequestEntity>> rejectRequest({
    required String requestId,
    required String reason,
  }) async {
    try {
      final request = AppConfig.useMockData
          ? await _mockDataSource!.rejectRequest(
              requestId: requestId,
              response: reason,
            )
          : await _remoteDataSource!.updateRequestStatus(
              requestId,
              'rejected',
              response: reason,
            );
      return Success(request);
    } catch (e) {
      return Failure(
        message: 'Error al rechazar la solicitud',
        error: e,
      );
    }
  }

  @override
  Future<Result<RequestEntity>> markAsInProgress(String requestId) async {
    try {
      final request = AppConfig.useMockData
          ? await _mockDataSource!.markInProgress(requestId)
          : await _remoteDataSource!.updateRequestStatus(
              requestId,
              'in_progress',
            );
      return Success(request);
    } catch (e) {
      return Failure(
        message: 'Error al marcar solicitud en progreso',
        error: e,
      );
    }
  }

  @override
  Future<Result<RequestEntity>> markAsCompleted(String requestId) async {
    try {
      final request = AppConfig.useMockData
          ? await _mockDataSource!.markCompleted(requestId)
          : await _remoteDataSource!.updateRequestStatus(
              requestId,
              'completed',
            );
      return Success(request);
    } catch (e) {
      return Failure(
        message: 'Error al marcar solicitud como completada',
        error: e,
      );
    }
  }

  @override
  Future<Result<RequestEntity>> cancelRequest(String requestId) async {
    try {
      if (AppConfig.useMockData) {
        await _mockDataSource!.cancelRequest(requestId);
        final request = await _mockDataSource.getRequestById(requestId);
        return Success(request);
      } else {
        final request = await _remoteDataSource!.updateRequestStatus(
          requestId,
          'cancelled',
        );
        return Success(request);
      }
    } catch (e) {
      return Failure(
        message: 'Error al cancelar la solicitud',
        error: e,
      );
    }
  }
}
