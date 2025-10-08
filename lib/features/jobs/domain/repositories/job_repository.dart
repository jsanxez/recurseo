import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';

/// Filtros para búsqueda de ofertas
class JobSearchFilters {
  final List<String>? categoryIds;
  final String? location;
  final JobType? type;
  final PaymentType? paymentType;
  final UrgencyLevel? urgency;
  final double? minBudget;
  final double? maxBudget;
  final bool? onlyActive;

  const JobSearchFilters({
    this.categoryIds,
    this.location,
    this.type,
    this.paymentType,
    this.urgency,
    this.minBudget,
    this.maxBudget,
    this.onlyActive = true,
  });
}

/// Opciones de ordenamiento
enum JobSortOption {
  recent, // Más recientes primero
  urgent, // Urgentes primero
  highestBudget, // Mayor presupuesto primero
  lowestBudget, // Menor presupuesto primero
  expiringSoon, // Próximas a expirar primero
}

/// Repositorio de ofertas de trabajo
abstract class JobRepository {
  /// Obtener todas las ofertas (con filtros opcionales)
  Future<Result<List<JobPostEntity>>> getJobPosts({
    JobSearchFilters? filters,
    JobSortOption? sortBy,
    int? limit,
  });

  /// Obtener ofertas creadas por un cliente específico
  Future<Result<List<JobPostEntity>>> getClientJobPosts(String clientId);

  /// Obtener una oferta específica por ID
  Future<Result<JobPostEntity>> getJobPost(String jobPostId);

  /// Crear una nueva oferta de trabajo
  Future<Result<JobPostEntity>> createJobPost({
    required String clientId,
    required List<String> categoryIds,
    required String title,
    required String description,
    required String location,
    required JobType type,
    int? durationDays,
    required PaymentType paymentType,
    double? budgetMin,
    double? budgetMax,
    required UrgencyLevel urgency,
    int? requiredWorkers,
    List<String>? requirements,
    List<String>? photoUrls,
    int? expiresInDays,
  });

  /// Actualizar una oferta existente
  Future<Result<JobPostEntity>> updateJobPost({
    required String jobPostId,
    String? title,
    String? description,
    String? location,
    JobType? type,
    int? durationDays,
    PaymentType? paymentType,
    double? budgetMin,
    double? budgetMax,
    UrgencyLevel? urgency,
    int? requiredWorkers,
    List<String>? requirements,
    List<String>? photoUrls,
  });

  /// Cambiar estado de una oferta
  Future<Result<JobPostEntity>> updateJobPostStatus({
    required String jobPostId,
    required JobPostStatus status,
  });

  /// Cerrar una oferta (ya no acepta propuestas)
  Future<Result<void>> closeJobPost(String jobPostId);

  /// Cancelar una oferta
  Future<Result<void>> cancelJobPost(String jobPostId);

  /// Marcar oferta como cubierta/llena
  Future<Result<void>> markJobPostFilled(String jobPostId);

  /// Incrementar contador de propuestas
  Future<Result<void>> incrementProposalsCount(String jobPostId);

  /// Obtener estadísticas de ofertas del cliente
  Future<Result<ClientJobStats>> getClientJobStats(String clientId);
}

/// Estadísticas de ofertas del cliente
class ClientJobStats {
  final int totalPosts;
  final int activePosts;
  final int closedPosts;
  final int filledPosts;
  final int totalProposalsReceived;

  const ClientJobStats({
    required this.totalPosts,
    required this.activePosts,
    required this.closedPosts,
    required this.filledPosts,
    required this.totalProposalsReceived,
  });
}
