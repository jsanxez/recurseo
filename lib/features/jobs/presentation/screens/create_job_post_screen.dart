import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/features/jobs/domain/entities/job_post_entity.dart';
import 'package:recurseo/features/jobs/presentation/providers/create_job_post_provider.dart';

/// Pantalla para crear una nueva oferta de trabajo
class CreateJobPostScreen extends ConsumerStatefulWidget {
  const CreateJobPostScreen({super.key});

  @override
  ConsumerState<CreateJobPostScreen> createState() => _CreateJobPostScreenState();
}

class _CreateJobPostScreenState extends ConsumerState<CreateJobPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();
  final _budgetMinController = TextEditingController();
  final _budgetMaxController = TextEditingController();
  final _workersController = TextEditingController(text: '1');
  final _requirementsController = TextEditingController();

  final List<String> _selectedCategoryIds = [];
  JobType _selectedType = JobType.porProyecto;
  PaymentType _selectedPaymentType = PaymentType.porProyecto;
  UrgencyLevel _selectedUrgency = UrgencyLevel.normal;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _budgetMinController.dispose();
    _budgetMaxController.dispose();
    _workersController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(createJobPostProvider);
    final notifier = ref.read(createJobPostProvider.notifier);

    // Escuchar cambios de estado para mostrar mensajes
    ref.listen<CreateJobPostState>(createJobPostProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (next.successMessage != null && next.createdJob != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        // Navegar a la oferta creada o a Mis Ofertas
        Future.delayed(const Duration(seconds: 1), () {
          if (context.mounted) {
            context.go('/my-jobs');
          }
        });
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicar Oferta de Trabajo'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Categorías
            Text(
              'Categoría *',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildCategorySelection(),
            const SizedBox(height: 24),

            // Título
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Título de la oferta *',
                hintText: 'Ej: Electricista para instalación residencial',
                border: OutlineInputBorder(),
              ),
              maxLength: 100,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El título es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Descripción
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descripción *',
                hintText: 'Describe el trabajo que necesitas...',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              maxLength: 1000,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La descripción es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Ubicación
            TextFormField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Ubicación *',
                hintText: 'Ej: Cumbayá, Quito',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.location_on),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'La ubicación es obligatoria';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Tipo de trabajo
            Text(
              'Tipo de trabajo *',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<JobType>(
              segments: const [
                ButtonSegment(
                  value: JobType.porProyecto,
                  label: Text('Por Proyecto'),
                  icon: Icon(Icons.work_outline, size: 16),
                ),
                ButtonSegment(
                  value: JobType.temporal,
                  label: Text('Temporal'),
                  icon: Icon(Icons.schedule, size: 16),
                ),
                ButtonSegment(
                  value: JobType.permanente,
                  label: Text('Permanente'),
                  icon: Icon(Icons.event_repeat, size: 16),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (Set<JobType> newSelection) {
                setState(() {
                  _selectedType = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),

            // Duración estimada (opcional)
            TextFormField(
              controller: _durationController,
              decoration: const InputDecoration(
                labelText: 'Duración estimada (días)',
                hintText: 'Ej: 15',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.calendar_today),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 24),

            // Tipo de pago
            Text(
              'Tipo de pago *',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<PaymentType>(
              value: _selectedPaymentType,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.payments),
              ),
              items: const [
                DropdownMenuItem(
                  value: PaymentType.porHora,
                  child: Text('Por Hora'),
                ),
                DropdownMenuItem(
                  value: PaymentType.porDia,
                  child: Text('Por Día'),
                ),
                DropdownMenuItem(
                  value: PaymentType.porProyecto,
                  child: Text('Por Proyecto'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedPaymentType = value;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Presupuesto
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _budgetMinController,
                    decoration: const InputDecoration(
                      labelText: 'Presupuesto mínimo',
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
                    controller: _budgetMaxController,
                    decoration: const InputDecoration(
                      labelText: 'Presupuesto máximo',
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

            // Urgencia
            Text(
              'Urgencia *',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<UrgencyLevel>(
              segments: const [
                ButtonSegment(
                  value: UrgencyLevel.flexible,
                  label: Text('Flexible'),
                  icon: Icon(Icons.schedule, size: 16),
                ),
                ButtonSegment(
                  value: UrgencyLevel.normal,
                  label: Text('Normal'),
                  icon: Icon(Icons.event, size: 16),
                ),
                ButtonSegment(
                  value: UrgencyLevel.urgente,
                  label: Text('Urgente'),
                  icon: Icon(Icons.priority_high, size: 16),
                ),
              ],
              selected: {_selectedUrgency},
              onSelectionChanged: (Set<UrgencyLevel> newSelection) {
                setState(() {
                  _selectedUrgency = newSelection.first;
                });
              },
            ),
            const SizedBox(height: 16),

            // Número de trabajadores
            TextFormField(
              controller: _workersController,
              decoration: const InputDecoration(
                labelText: 'Personas requeridas *',
                hintText: '1',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.group),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Ingresa el número de personas';
                }
                final number = int.tryParse(value);
                if (number == null || number < 1) {
                  return 'Debe ser al menos 1';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Requisitos
            TextFormField(
              controller: _requirementsController,
              decoration: const InputDecoration(
                labelText: 'Requisitos (separados por coma)',
                hintText: 'Ej: 3 años de experiencia, Herramientas propias',
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 3,
              maxLength: 500,
            ),
            const SizedBox(height: 32),

            // Botón de enviar
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
                  : const Text('Publicar Oferta'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelection() {
    final categories = ref.watch(jobCategoriesProvider);
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: categories.map((category) {
        final isSelected = _selectedCategoryIds.contains(category.id);
        return FilterChip(
          label: Text('${category.icon} ${category.name}'),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedCategoryIds.add(category.id);
              } else {
                _selectedCategoryIds.remove(category.id);
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

    if (_selectedCategoryIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debes seleccionar al menos una categoría'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final notifier = ref.read(createJobPostProvider.notifier);

    // Procesar requisitos (separar por comas)
    final requirementsText = _requirementsController.text.trim();
    List<String>? requirements;
    if (requirementsText.isNotEmpty) {
      requirements = requirementsText
          .split(',')
          .map((r) => r.trim())
          .where((r) => r.isNotEmpty)
          .toList();
    }

    final success = await notifier.createJobPost(
      categoryIds: _selectedCategoryIds,
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      type: _selectedType,
      durationDays: _durationController.text.isNotEmpty
          ? int.tryParse(_durationController.text)
          : null,
      paymentType: _selectedPaymentType,
      budgetMin: _budgetMinController.text.isNotEmpty
          ? double.tryParse(_budgetMinController.text)
          : null,
      budgetMax: _budgetMaxController.text.isNotEmpty
          ? double.tryParse(_budgetMaxController.text)
          : null,
      urgency: _selectedUrgency,
      requiredWorkers: int.tryParse(_workersController.text) ?? 1,
      requirements: requirements,
    );

    // La navegación se maneja en el listener del provider
  }
}
