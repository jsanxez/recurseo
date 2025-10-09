import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/domain/entities/professional_profile_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/create_professional_profile_provider.dart';

/// Pantalla para crear/editar perfil profesional
class CreateProfessionalProfileScreen extends ConsumerStatefulWidget {
  final ProfessionalProfileEntity? existingProfile;

  const CreateProfessionalProfileScreen({
    super.key,
    this.existingProfile,
  });

  @override
  ConsumerState<CreateProfessionalProfileScreen> createState() =>
      _CreateProfessionalProfileScreenState();
}

class _CreateProfessionalProfileScreenState
    extends ConsumerState<CreateProfessionalProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _experienceController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _dailyRateController = TextEditingController();
  final _bioController = TextEditingController();
  final _specialtiesController = TextEditingController();
  final _certificationsController = TextEditingController();
  final _locationsController = TextEditingController();

  final List<Trade> _selectedTrades = [];
  bool _hasOwnTools = false;
  bool _hasOwnTransport = false;
  AvailabilityStatus _availability = AvailabilityStatus.disponible;
  bool _lookingForWork = true;

  bool get isEditMode => widget.existingProfile != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _loadExistingProfile();
    }
  }

  void _loadExistingProfile() {
    final profile = widget.existingProfile!;
    _selectedTrades.addAll(profile.trades);
    _experienceController.text = profile.experienceYears.toString();
    _hasOwnTools = profile.hasOwnTools;
    _hasOwnTransport = profile.hasOwnTransport ?? false;
    _availability = profile.availability;
    _lookingForWork = profile.lookingForWork;

    if (profile.hourlyRate != null) {
      _hourlyRateController.text = profile.hourlyRate!.toStringAsFixed(0);
    }
    if (profile.dailyRate != null) {
      _dailyRateController.text = profile.dailyRate!.toStringAsFixed(0);
    }
    if (profile.bio != null) {
      _bioController.text = profile.bio!;
    }
    if (profile.specialties.isNotEmpty) {
      _specialtiesController.text = profile.specialties.join(', ');
    }
    if (profile.certifications.isNotEmpty) {
      _certificationsController.text = profile.certifications.join(', ');
    }
    if (profile.preferredLocations.isNotEmpty) {
      _locationsController.text = profile.preferredLocations.join(', ');
    }
  }

  @override
  void dispose() {
    _experienceController.dispose();
    _hourlyRateController.dispose();
    _dailyRateController.dispose();
    _bioController.dispose();
    _specialtiesController.dispose();
    _certificationsController.dispose();
    _locationsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(createProfessionalProfileProvider);

    // Escuchar cambios de estado
    ref.listen<CreateProfessionalProfileState>(
      createProfessionalProfileProvider,
      (previous, next) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.error!),
              backgroundColor: Colors.red,
            ),
          );
        }

        if (next.successMessage != null && next.createdProfile != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.successMessage!),
              backgroundColor: Colors.green,
            ),
          );
          // Navegar de regreso al perfil
          Future.delayed(const Duration(seconds: 1), () {
            if (context.mounted) {
              context.go('/home');
            }
          });
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Editar Perfil' : 'Crear Perfil Profesional'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Oficios/Especialidades
            Text(
              'Oficios que dominas *',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildTradeSelection(),
            const SizedBox(height: 24),

            // Especialidades adicionales
            TextFormField(
              controller: _specialtiesController,
              decoration: const InputDecoration(
                labelText: 'Especialidades (separadas por coma)',
                hintText: 'Ej: Instalaciones industriales, Sistemas trifásicos',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Años de experiencia
            TextFormField(
              controller: _experienceController,
              decoration: const InputDecoration(
                labelText: 'Años de experiencia *',
                hintText: '0',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.work_history),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa tus años de experiencia';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Tarifas
            Text(
              'Tarifas (opcional)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _hourlyRateController,
                    decoration: const InputDecoration(
                      labelText: 'Por Hora',
                      hintText: '0',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _dailyRateController,
                    decoration: const InputDecoration(
                      labelText: 'Por Día',
                      hintText: '0',
                      border: OutlineInputBorder(),
                      prefixText: '\$ ',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Biografía
            TextFormField(
              controller: _bioController,
              decoration: const InputDecoration(
                labelText: 'Acerca de ti',
                hintText: 'Describe tu experiencia, habilidades y fortalezas...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 500,
            ),
            const SizedBox(height: 16),

            // Certificaciones
            TextFormField(
              controller: _certificationsController,
              decoration: const InputDecoration(
                labelText: 'Certificaciones (separadas por coma)',
                hintText: 'Ej: Soldadura certificada, Instalaciones eléctricas',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // Ubicaciones preferidas
            TextFormField(
              controller: _locationsController,
              decoration: const InputDecoration(
                labelText: 'Zonas preferidas de trabajo (separadas por coma)',
                hintText: 'Ej: Cumbayá, Tumbaco, Quito Norte',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),

            // Opciones adicionales
            Text(
              'Información adicional',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              title: const Text('Tengo herramientas propias'),
              subtitle: const Text('Equipo y herramientas para trabajar'),
              value: _hasOwnTools,
              onChanged: (value) {
                setState(() {
                  _hasOwnTools = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Tengo transporte propio'),
              subtitle: const Text('Puedo desplazarme por mi cuenta'),
              value: _hasOwnTransport,
              onChanged: (value) {
                setState(() {
                  _hasOwnTransport = value;
                });
              },
            ),

            // Estado (solo en modo edición)
            if (isEditMode) ...[
              const SizedBox(height: 24),
              Text(
                'Estado',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<AvailabilityStatus>(
                value: _availability,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.event_available),
                ),
                items: const [
                  DropdownMenuItem(
                    value: AvailabilityStatus.disponible,
                    child: Text('Disponible'),
                  ),
                  DropdownMenuItem(
                    value: AvailabilityStatus.ocupado,
                    child: Text('Ocupado'),
                  ),
                  DropdownMenuItem(
                    value: AvailabilityStatus.parcial,
                    child: Text('Parcialmente disponible'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _availability = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Buscando trabajo activamente'),
                subtitle: const Text('Aparecerás en búsquedas de empleadores'),
                value: _lookingForWork,
                onChanged: (value) {
                  setState(() {
                    _lookingForWork = value;
                  });
                },
              ),
            ],

            const SizedBox(height: 32),

            // Botón de guardar
            FilledButton(
              onPressed: state.isLoading ? null : _handleSubmit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: state.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(isEditMode ? 'Guardar Cambios' : 'Crear Perfil'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTradeSelection() {
    final theme = Theme.of(context);

    final trades = [
      {'trade': Trade.electricista, 'icon': '⚡', 'name': 'Electricista'},
      {'trade': Trade.plomero, 'icon': '🔧', 'name': 'Plomero'},
      {'trade': Trade.albanil, 'icon': '🧱', 'name': 'Albañil'},
      {'trade': Trade.carpintero, 'icon': '🪚', 'name': 'Carpintero'},
      {'trade': Trade.pintor, 'icon': '🎨', 'name': 'Pintor'},
      {'trade': Trade.soldador, 'icon': '🔥', 'name': 'Soldador'},
      {'trade': Trade.maestroObra, 'icon': '👷', 'name': 'Maestro de Obra'},
      {'trade': Trade.operario, 'icon': '⚙️', 'name': 'Operario'},
      {'trade': Trade.jardinero, 'icon': '🌿', 'name': 'Jardinero'},
      {'trade': Trade.herrero, 'icon': '⚒️', 'name': 'Herrero'},
      {'trade': Trade.limpieza, 'icon': '🧹', 'name': 'Limpieza'},
      {'trade': Trade.ayudante, 'icon': '🤝', 'name': 'Ayudante'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: trades.map((tradeData) {
        final trade = tradeData['trade'] as Trade;
        final icon = tradeData['icon'] as String;
        final name = tradeData['name'] as String;
        final isSelected = _selectedTrades.contains(trade);

        return FilterChip(
          label: Text('$icon $name'),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedTrades.add(trade);
              } else {
                _selectedTrades.remove(trade);
              }
            });
          },
          selectedColor: theme.colorScheme.primaryContainer,
        );
      }).toList(),
    );
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedTrades.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar al menos un oficio'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = ref.read(createProfessionalProfileProvider.notifier);

    // Procesar listas separadas por comas
    final specialties = _specialtiesController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final certifications = _certificationsController.text
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();

    final locations = _locationsController.text
        .split(',')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final hourlyRate = _hourlyRateController.text.isNotEmpty
        ? double.tryParse(_hourlyRateController.text)
        : null;

    final dailyRate = _dailyRateController.text.isNotEmpty
        ? double.tryParse(_dailyRateController.text)
        : null;

    if (isEditMode) {
      await notifier.updateProfile(
        specialties: specialties,
        trades: _selectedTrades,
        experienceYears: int.parse(_experienceController.text),
        availability: _availability,
        preferredLocations: locations.isNotEmpty ? locations : null,
        hasOwnTools: _hasOwnTools,
        certifications: certifications.isNotEmpty ? certifications : null,
        hourlyRate: hourlyRate,
        dailyRate: dailyRate,
        lookingForWork: _lookingForWork,
        bio: _bioController.text.isNotEmpty ? _bioController.text : null,
      );
    } else {
      await notifier.createProfile(
        specialties: specialties,
        trades: _selectedTrades,
        experienceYears: int.parse(_experienceController.text),
        preferredLocations: locations.isNotEmpty ? locations : null,
        hasOwnTools: _hasOwnTools,
        certifications: certifications.isNotEmpty ? certifications : null,
        hourlyRate: hourlyRate,
        dailyRate: dailyRate,
        bio: _bioController.text.isNotEmpty ? _bioController.text : null,
      );
    }
  }
}
