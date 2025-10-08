import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/proposal_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado de las propuestas del profesional
class MyProposalsState {
  final List<ProposalEntity> proposals;
  final bool isLoading;
  final String? error;
  final ProposalStatus? filterStatus;

  const MyProposalsState({
    this.proposals = const [],
    this.isLoading = false,
    this.error,
    this.filterStatus,
  });

  MyProposalsState copyWith({
    List<ProposalEntity>? proposals,
    bool? isLoading,
    String? error,
    ProposalStatus? filterStatus,
    bool clearError = false,
    bool clearFilter = false,
  }) {
    return MyProposalsState(
      proposals: proposals ?? this.proposals,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      filterStatus: clearFilter ? null : (filterStatus ?? this.filterStatus),
    );
  }
}

/// Notifier para gestionar las propuestas del profesional
class MyProposalsNotifier extends StateNotifier<MyProposalsState> {
  final ProposalRepository _repository;
  final Ref _ref;

  MyProposalsNotifier(this._repository, this._ref)
      : super(const MyProposalsState()) {
    loadProposals();
  }

  /// Cargar propuestas del profesional actual
  Future<void> loadProposals() async {
    state = state.copyWith(isLoading: true, clearError: true);

    // Obtener el usuario actual
    final authState = _ref.read(authNotifierProvider);
    if (authState is! Authenticated) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes iniciar sesión para ver tus propuestas',
      );
      return;
    }

    final professionalId = authState.user.id;

    final result = await _repository.getProfessionalProposals(professionalId);

    if (result is Success<List<ProposalEntity>>) {
      // Filtrar propuestas por estado si hay filtro activo
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

  /// Retirar una propuesta
  Future<void> withdrawProposal(String proposalId) async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.withdrawProposal(proposalId);

    if (result is Success<void>) {
      // Actualizar la lista
      await loadProposals();
    } else if (result is Failure<void>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }
}

/// Provider del notifier
final myProposalsProvider =
    StateNotifierProvider.autoDispose<MyProposalsNotifier, MyProposalsState>(
  (ref) {
    final repository = ref.watch(proposalRepositoryProvider);
    return MyProposalsNotifier(repository, ref);
  },
);
