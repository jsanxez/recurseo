import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/professional_profile_provider.dart';

/// Pantalla del perfil profesional
class ProfessionalProfileScreen extends ConsumerWidget {
  final String userId;
  final bool isOwnProfile;

  const ProfessionalProfileScreen({
    super.key,
    required this.userId,
    this.isOwnProfile = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(professionalProfileProvider(userId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(isOwnProfile ? 'Mi Perfil Profesional' : 'Perfil Profesional'),
        actions: [
          if (isOwnProfile && state.profile != null && !state.isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                // Navegar a pantalla de edición pasando el perfil existente
                context.push('/profile/professional/edit', extra: state.profile);
              },
              tooltip: 'Editar perfil',
            ),
        ],
      ),
      body: _buildBody(context, state, theme, ref),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProfessionalProfileState state,
    ThemeData theme,
    WidgetRef ref,
  ) {
    if (state.isLoading && state.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Error al cargar perfil',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(state.error!),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Volver'),
            ),
          ],
        ),
      );
    }

    if (state.profile == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person_off, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Perfil no encontrado',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('Este profesional aún no ha creado su perfil'),
            if (isOwnProfile) ...[
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  context.push('/profile/professional/create');
                },
                icon: const Icon(Icons.add),
                label: const Text('Crear Perfil'),
              ),
            ],
          ],
        ),
      );
    }

    final profile = state.profile!;

    return RefreshIndicator(
      onRefresh: () => ref.read(professionalProfileProvider(userId).notifier).refresh(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información principal
            _buildHeader(profile, theme),
            const SizedBox(height: 24),

            // Estadísticas
            _buildStats(profile, theme),
            const SizedBox(height: 24),

            // Disponibilidad y estado
            _buildAvailability(profile, theme),
            const SizedBox(height: 24),

            // Especialidades y oficios
            _buildSpecialties(profile, theme),
            const SizedBox(height: 24),

            // Tarifas
            if (profile.hourlyRate != null || profile.dailyRate != null)
              _buildRates(profile, theme),

            // Biografía
            if (profile.bio != null && profile.bio!.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildBio(profile, theme),
            ],

            // Habilidades
            if (profile.skills != null && profile.skills!.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildSkills(profile, theme),
            ],

            // Certificaciones
            if (profile.certifications.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildCertifications(profile, theme),
            ],

            // Portfolio
            if (profile.portfolioUrls.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildPortfolio(profile, theme),
            ],

            // Información adicional
            const SizedBox(height: 24),
            _buildAdditionalInfo(profile, theme),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 40,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    profile.tradeNames.isNotEmpty
                        ? profile.tradeNames.first
                        : 'Profesional',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (profile.averageRating != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 20, color: Colors.amber[700]),
                        const SizedBox(width: 4),
                        Text(
                          '${profile.averageRating!.toStringAsFixed(1)} (${profile.reviewsCount} reseñas)',
                          style: theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${profile.experienceYears} años de experiencia',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(
              icon: Icons.work_outline,
              label: 'Trabajos',
              value: '${profile.completedJobs}',
              theme: theme,
            ),
            _buildStatItem(
              icon: Icons.star_outline,
              label: 'Reseñas',
              value: '${profile.reviewsCount}',
              theme: theme,
            ),
            if (profile.averageRating != null)
              _buildStatItem(
                icon: Icons.grade,
                label: 'Rating',
                value: profile.averageRating!.toStringAsFixed(1),
                theme: theme,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildAvailability(ProfessionalProfileEntity profile, ThemeData theme) {
    Color statusColor;
    IconData statusIcon;

    switch (profile.availability) {
      case AvailabilityStatus.disponible:
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case AvailabilityStatus.ocupado:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case AvailabilityStatus.parcial:
        statusColor = Colors.orange;
        statusIcon = Icons.schedule;
        break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estado',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 24),
                const SizedBox(width: 8),
                Text(
                  profile.availabilityText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            if (profile.lookingForWork) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.search, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Buscando trabajo activamente',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialties(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Especialidades',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.tradeNames.map((trade) {
                return Chip(
                  label: Text(trade),
                  backgroundColor: theme.colorScheme.primaryContainer,
                );
              }).toList(),
            ),
            if (profile.specialties.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...profile.specialties.map(
                (specialty) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 18,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(specialty)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRates(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tarifas',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            if (profile.hourlyRate != null)
              _buildRateRow(
                icon: Icons.schedule,
                label: 'Por Hora',
                value: '\$${profile.hourlyRate!.toStringAsFixed(0)}',
                theme: theme,
              ),
            if (profile.dailyRate != null)
              _buildRateRow(
                icon: Icons.today,
                label: 'Por Día',
                value: '\$${profile.dailyRate!.toStringAsFixed(0)}',
                theme: theme,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBio(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Acerca de mí',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              profile.bio!,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkills(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habilidades',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.skills!.map((skill) {
                return Chip(
                  label: Text(skill, style: const TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCertifications(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Certificaciones',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...profile.certifications.map(
              (cert) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified,
                      size: 20,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(cert)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolio(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Portfolio',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '${profile.portfolioUrls.length} fotos de trabajos anteriores',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: profile.portfolioUrls.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, size: 40),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo(ProfessionalProfileEntity profile, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información adicional',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow(
              icon: Icons.build,
              label: 'Herramientas propias',
              value: profile.hasOwnTools ? 'Sí' : 'No',
              theme: theme,
            ),
            if (profile.hasOwnTransport != null)
              _buildInfoRow(
                icon: Icons.directions_car,
                label: 'Transporte propio',
                value: profile.hasOwnTransport! ? 'Sí' : 'No',
                theme: theme,
              ),
            if (profile.preferredLocations.isNotEmpty)
              _buildInfoRow(
                icon: Icons.location_on,
                label: 'Zonas preferidas',
                value: profile.preferredLocations.join(', '),
                theme: theme,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
