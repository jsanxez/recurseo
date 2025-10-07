import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:recurseo/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:recurseo/features/profile/domain/repositories/profile_repository.dart';
import 'package:recurseo/shared/providers/dio_provider.dart';

/// Provider del remote datasource
final profileRemoteDataSourceProvider =
    Provider<ProfileRemoteDataSource>((ref) {
  final dio = ref.watch(dioProvider);
  return ProfileRemoteDataSource(dio);
});

/// Provider del repositorio de perfiles
final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.watch(profileRemoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});
