import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/core/utils/result.dart';
import 'package:recurseo/core/utils/validators.dart';
import 'package:recurseo/core/widgets/custom_text_field.dart';
import 'package:recurseo/features/requests/presentation/providers/request_providers.dart';

/// Pantalla para crear una nueva solicitud de servicio
class CreateRequestScreen extends ConsumerStatefulWidget {
  final String providerId;
  final String serviceId;

  const CreateRequestScreen({
    super.key,
    required this.providerId,
    required this.serviceId,
  });

  @override
  ConsumerState<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _budgetFromController = TextEditingController();
  final _budgetToController = TextEditingController();

  DateTime? _selectedDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _budgetFromController.dispose();
    _budgetToController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final repository = ref.read(requestRepositoryProvider);

    final result = await repository.createRequest(
      providerId: widget.providerId,
      serviceId: widget.serviceId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      preferredDate: _selectedDate,
      budgetFrom: _budgetFromController.text.trim().isEmpty
          ? null
          : double.tryParse(_budgetFromController.text.trim()),
      budgetTo: _budgetToController.text.trim().isEmpty
          ? null
          : double.tryParse(_budgetToController.text.trim()),
    );

    setState(() {
      _isLoading = false;
    });

    if (!mounted) return;

    switch (result) {
      case Success():
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Solicitud enviada exitosamente'),
            backgroundColor: AppColors.success,
          ),
        );
        // Invalidar el provider para refrescar la lista
        ref.invalidate(clientRequestsProvider);
        context.pop();
      case Failure(message: final message):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.error,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nueva Solicitud'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.md),
          children: [
            // Título
            CustomTextField(
              controller: _titleController,
              label: 'Título',
              hint: 'Ej: Reparación de tubería',
              validator: Validators.required('El título es requerido'),
              maxLength: 100,
            ),
            const SizedBox(height: AppSizes.md),

            // Descripción
            CustomTextField(
              controller: _descriptionController,
              label: 'Descripción',
              hint: 'Describe en detalle lo que necesitas',
              validator: Validators.required('La descripción es requerida'),
              maxLines: 5,
              maxLength: 500,
            ),
            const SizedBox(height: AppSizes.md),

            // Ubicación
            CustomTextField(
              controller: _locationController,
              label: 'Ubicación (opcional)',
              hint: 'Dirección o zona',
              prefixIcon: Icons.location_on,
            ),
            const SizedBox(height: AppSizes.md),

            // Fecha preferida
            Card(
              child: InkWell(
                onTap: () => _selectDate(context),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.md),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Fecha Preferida (opcional)',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedDate == null
                                  ? 'Seleccionar fecha'
                                  : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.md),

            // Presupuesto
            Text(
              'Presupuesto Estimado (opcional)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _budgetFromController,
                    label: 'Desde',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.attach_money,
                  ),
                ),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: CustomTextField(
                    controller: _budgetToController,
                    label: 'Hasta',
                    hint: '0.00',
                    keyboardType: TextInputType.number,
                    prefixIcon: Icons.attach_money,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.lg),

            // Información
            Container(
              padding: const EdgeInsets.all(AppSizes.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.info),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: Text(
                      'El proveedor recibirá tu solicitud y podrá aceptarla o rechazarla.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.info,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Botón enviar
            FilledButton(
              onPressed: _isLoading ? null : _submitRequest,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar Solicitud'),
            ),
          ],
        ),
      ),
    );
  }
}
