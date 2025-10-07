import 'package:dio/dio.dart';
import 'package:recurseo/core/config/api_config.dart';
import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/features/requests/data/models/request_model.dart';

/// DataSource remoto para solicitudes
class RequestRemoteDataSource {
  final Dio _dio;
  final _logger = const Logger('RequestRemoteDataSource');

  RequestRemoteDataSource(this._dio);

  Future<RequestModel> createRequest({
    required String clientId,
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
      final response = await _dio.post(
        ApiConfig.requests,
        data: {
          'client_id': clientId,
          'provider_id': providerId,
          'service_id': serviceId,
          'title': title,
          'description': description,
          if (location != null) 'location': location,
          if (preferredDate != null)
            'preferred_date': preferredDate.toIso8601String(),
          if (budgetFrom != null) 'budget_from': budgetFrom,
          if (budgetTo != null) 'budget_to': budgetTo,
        },
      );

      return RequestModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      _logger.error('Create request failed', e);
      throw _handleError(e);
    }
  }

  Future<List<RequestModel>> getClientRequests(String clientId) async {
    try {
      final response = await _dio.get(
        ApiConfig.requests,
        queryParameters: {'client_id': clientId},
      );

      return (response.data as List<dynamic>)
          .map((json) => RequestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<RequestModel>> getProviderRequests(String providerId) async {
    try {
      final response = await _dio.get(
        ApiConfig.requests,
        queryParameters: {'provider_id': providerId},
      );

      return (response.data as List<dynamic>)
          .map((json) => RequestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RequestModel> getRequestById(String id) async {
    try {
      final response = await _dio.get('${ApiConfig.requests}/$id');
      return RequestModel.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<RequestModel> updateRequestStatus(
    String requestId,
    String status, {
    String? response,
  }) async {
    try {
      final result = await _dio.put(
        '${ApiConfig.requests}/$requestId',
        data: {
          'status': status,
          if (response != null) 'provider_response': response,
        },
      );

      return RequestModel.fromJson(result.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    final message = e.response?.data['message'] as String?;
    return Exception(message ?? 'Error de conexión');
  }
}
