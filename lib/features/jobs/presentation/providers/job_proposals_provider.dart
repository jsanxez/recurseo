import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/proposal_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado de las propuestas de una oferta de trabajo
class JobProposalsState {
  final List<ProposalEntity> proposals;
  final bool isLoading;
  final String? error;
  final ProposalStatus? filterStatus;

  const JobProposalsState({
    this.proposals = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus,
  });

  JobProposalsState copyWith({
    List<ProposalEntity>? proposals,
    bool? isLoading,
    String? error,
    ProposalStatus? filterStatus,
    bool clearError = false,
    bool clearFilter = false,
  }) {
    return JobProposalsState(
      proposals: proposals ?? this.proposals,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
    );
  }

  /// Obtener estadísticas de propuestas
  Map<String, int> get stats {
    return {
      'total': proposals.length,
      'pending': proposals.where((p) => p.status == ProposalStatus.pending).length,
      'accepted': proposals.where((p) => p.status == ProposalStatus.accepted).length,
      'rejected': proposals.where((p) => p.status == ProposalStatus.rejected).length,
    };
  }
}

/// Notifier para gestionar propuestas de una oferta
class JobProposalsNotifier extends StateNotifier<JobProposalsState> {
  final ProposalRepository _repository;
  final String _jobPostId;

  JobProposalsNotifier(this._repository, this._jobPostId)
      : super(const JobProposalsState()) {
    loadProposals();
  }

  /// Cargar propuestas de la oferta
  Future<void> loadProposals() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getJobPostProposals(_jobPostId);

    if (result is Success<List<ProposalEntity>>) {
      // Filtrar por estado si hay filtro activo
      var filteredProposals = result.data;
      if (state.filterStatus != null) {
        filteredProposals = result.data
            .where((p) => p.status == state.filterStatus)
            .toList();
      }

      state = state.copyWith(
        proposals: filteredProposals,
        isLoading: false,
      );
    } else if (result is Failure<List<ProposalEntity>>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Actualizar (pull to refresh)
  Future<void> refresh() => loadProposals();

  /// Filtrar por estado
  void filterByStatus(ProposalStatus? status) {
    state = state.copyWith(filterStatus: status);
    loadProposals();
  }

  /// Limpiar filtros
  void clearFilters() {
    state = state.copyWith(clearFilter: true);
    loadProposals();
  }

  /// Aceptar una propuesta
  Future<bool> acceptProposal(String proposalId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.acceptProposal(proposalId);

    if (result is Success<ProposalEntity>) {
      // Recargar la lista
      await loadProposals();
      return true;
    } else if (result is Failure<ProposalEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    return false;
  }

  /// Rechazar una propuesta
  Future<bool> rejectProposal(String proposalId, {String? reason}) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.rejectProposal(
      proposalId: proposalId,
      reason: reason,
    );

    if (result is Success<ProposalEntity>) {
      // Recargar la lista
      await loadProposals();
      return true;
    } else if (result is Failure<ProposalEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
      return false;
    }

    return false;
  }
}

/// Provider del notifier
final jobProposalsProvider = StateNotifierProvider.family
    .autoDispose<JobProposalsNotifier, JobProposalsState, String>(
  (ref, jobPostId) {
    final repository = ref.watch(proposalRepositoryProvider);
    return JobProposalsNotifier(repository, jobPostId);
  },
);
