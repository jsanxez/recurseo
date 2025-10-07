import 'package:recurseo/core/utils/logger.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/domain/entities/user_entity.dart';
import 'package:recurseo/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:recurseo/features/profile/domain/entities/provider_profile_entity.dart';
import 'package:recurseo/features/profile/domain/entities/service_entity.dart';
import 'package:recurseo/features/profile/domain/repositories/profile_repository.dart';

/// Implementación del repositorio de perfiles
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource _remoteDataSource;
  final _logger = const Logger('ProfileRepositoryImpl');

  ProfileRepositoryImpl({
    required ProfileRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  @override
  Future<Result<UserEntity>> updateUserProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? photoUrl,
  }) async {
    try {
      final user = await _remoteDataSource.updateUserProfile(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        photoUrl: photoUrl,
      );

      _logger.success('User profile updated successfully');
      return Success(user);
    } catch (e, st) {
      _logger.error('Failed to update user profile', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProviderProfileEntity>> getProviderProfile(
      String userId) async {
    try {
      final profile = await _remoteDataSource.getProviderProfile(userId);

      _logger.success('Provider profile fetched successfully');
      return Success(profile);
    } catch (e, st) {
      _logger.error('Failed to fetch provider profile', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ProviderProfileEntity>> updateProviderProfile({
    required String userId,
    String? businessName,
    String? description,
    String? location,
    List<String>? services,
    List<String>? certifications,
  }) async {
    try {
      final profile = await _remoteDataSource.updateProviderProfile(
        userId: userId,
        businessName: businessName,
        description: description,
        location: location,
        services: services,
        certifications: certifications,
      );

      _logger.success('Provider profile updated successfully');
      return Success(profile);
    } catch (e, st) {
      _logger.error('Failed to update provider profile', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<String>> uploadProfilePhoto({
    required String userId,
    required String filePath,
  }) async {
    try {
      final photoUrl = await _remoteDataSource.uploadProfilePhoto(
        userId: userId,
        filePath: filePath,
      );

      _logger.success('Profile photo uploaded successfully');
      return Success(photoUrl);
    } catch (e, st) {
      _logger.error('Failed to upload profile photo', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> addPortfolioPhoto({
    required String userId,
    required String filePath,
  }) async {
    try {
      await _remoteDataSource.addPortfolioPhoto(
        userId: userId,
        filePath: filePath,
      );

      _logger.success('Portfolio photo added successfully');
      return const Success(null);
    } catch (e, st) {
      _logger.error('Failed to add portfolio photo', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> removePortfolioPhoto({
    required String userId,
    required String photoUrl,
  }) async {
    try {
      await _remoteDataSource.removePortfolioPhoto(
        userId: userId,
        photoUrl: photoUrl,
      );

      _logger.success('Portfolio photo removed successfully');
      return const Success(null);
    } catch (e, st) {
      _logger.error('Failed to remove portfolio photo', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<List<ServiceEntity>>> getProviderServices(
      String providerId) async {
    try {
      final services = await _remoteDataSource.getProviderServices(providerId);

      _logger.success('Provider services fetched successfully');
      return Success(services);
    } catch (e, st) {
      _logger.error('Failed to fetch provider services', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ServiceEntity>> createService({
    required String providerId,
    required String categoryId,
    required String title,
    required String description,
    double? priceFrom,
    double? priceTo,
    String? priceUnit,
  }) async {
    try {
      final service = await _remoteDataSource.createService(
        providerId: providerId,
        categoryId: categoryId,
        title: title,
        description: description,
        priceFrom: priceFrom,
        priceTo: priceTo,
        priceUnit: priceUnit,
      );

      _logger.success('Service created successfully');
      return Success(service);
    } catch (e, st) {
      _logger.error('Failed to create service', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<ServiceEntity>> updateService({
    required String serviceId,
    String? title,
    String? description,
    double? priceFrom,
    double? priceTo,
    String? priceUnit,
    bool? isActive,
  }) async {
    try {
      final service = await _remoteDataSource.updateService(
        serviceId: serviceId,
        title: title,
        description: description,
        priceFrom: priceFrom,
        priceTo: priceTo,
        priceUnit: priceUnit,
        isActive: isActive,
      );

      _logger.success('Service updated successfully');
      return Success(service);
    } catch (e, st) {
      _logger.error('Failed to update service', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<Result<void>> deleteService(String serviceId) async {
    try {
      await _remoteDataSource.deleteService(serviceId);

      _logger.success('Service deleted successfully');
      return const Success(null);
    } catch (e, st) {
      _logger.error('Failed to delete service', e, st);
      return Failure(
        message: e.toString().replaceAll('Exception: ', ''),
        error: e,
        stackTrace: st,
      );
    }
  }
}
