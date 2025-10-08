import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/proposal_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado del detalle de la propuesta
class ProposalDetailState {
  final ProposalEntity? proposal;
  final bool isLoading;
  final String? error;

  const ProposalDetailState({
    this.proposal,
    this.isLoading = false,
    this.error,
  });

  ProposalDetailState copyWith({
    ProposalEntity? proposal,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProposalDetailState(
      proposal: proposal ?? this.proposal,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Notifier para el detalle de la propuesta
class ProposalDetailNotifier extends StateNotifier<ProposalDetailState> {
  final ProposalRepository _repository;
  final String _proposalId;

  ProposalDetailNotifier(this._repository, this._proposalId)
      : super(const ProposalDetailState()) {
    loadProposal();
  }

  /// Cargar la propuesta
  Future<void> loadProposal() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.getProposal(_proposalId);

    if (result is Success<ProposalEntity>) {
      state = state.copyWith(
        proposal: result.data,
        isLoading: false,
      );
    } else if (result is Failure<ProposalEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Recargar (pull to refresh)
  Future<void> refresh() => loadProposal();
}

/// Provider del notifier (family provider para pasar el proposalId)
final proposalDetailProvider = StateNotifierProvider.family.autoDispose<
    ProposalDetailNotifier, ProposalDetailState, String>(
  (ref, proposalId) {
    final repository = ref.watch(proposalRepositoryProvider);
    return ProposalDetailNotifier(repository, proposalId);
  },
);
