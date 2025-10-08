import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_notifier.dart';
import 'package:recurseo/features/auth/presentation/providers/auth_state.dart';
import 'package:recurseo/features/jobs/domain/entities/proposal_entity.dart';
import 'package:recurseo/features/jobs/domain/repositories/proposal_repository.dart';
import 'package:recurseo/features/jobs/presentation/providers/job_providers.dart';

/// Estado del envío de propuesta
class SendProposalState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  const SendProposalState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });

  SendProposalState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? error,
  }) {
    return SendProposalState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      error: error,
    );
  }
}

/// Notifier para enviar propuestas
class SendProposalNotifier extends StateNotifier<SendProposalState> {
  final ProposalRepository _repository;
  final Ref _ref;

  SendProposalNotifier(this._repository, this._ref)
      : super(const SendProposalState());

  /// Enviar propuesta
  Future<void> sendProposal({
    required String jobPostId,
    required String message,
    required double proposedRate,
    required String rateType,
    required DateTime availableFrom,
    int? estimatedDays,
    List<String>? portfolioUrls,
  }) async {
    state = state.copyWith(isLoading: true, error: null, isSuccess: false);

    // Obtener el usuario actual
    final authState = _ref.read(authNotifierProvider);
    if (authState is! Authenticated) {
      state = state.copyWith(
        isLoading: false,
        error: 'Debes iniciar sesión para enviar propuestas',
      );
      return;
    }

    final professionalId = authState.user.id;

    final result = await _repository.createProposal(
      jobPostId: jobPostId,
      professionalId: professionalId,
      message: message,
      proposedRate: proposedRate,
      rateType: rateType,
      availableFrom: availableFrom,
      estimatedDays: estimatedDays,
      portfolioUrls: portfolioUrls,
    );

    if (result is Success<ProposalEntity>) {
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
      );
    } else if (result is Failure<ProposalEntity>) {
      state = state.copyWith(
        isLoading: false,
        error: result.message,
      );
    }
  }

  /// Resetear estado
  void reset() {
    state = const SendProposalState();
  }
}

/// Provider del notifier
final sendProposalProvider =
    StateNotifierProvider.autoDispose<SendProposalNotifier, SendProposalState>(
  (ref) {
    final repository = ref.watch(proposalRepositoryProvider);
    return SendProposalNotifier(repository, ref);
  },
);
