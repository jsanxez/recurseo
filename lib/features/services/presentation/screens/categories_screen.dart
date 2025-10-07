import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/services/presentation/providers/catalog_providers.dart';

/// Pantalla de lista de categorías
class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorías'),
      ),
      body: categoriesAsync.when(
        data: (categories) => GridView.builder(
          padding: const EdgeInsets.all(AppSizes.paddingMd),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.paddingMd,
            mainAxisSpacing: AppSizes.paddingMd,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              child: InkWell(
                onTap: () {
                  context.push('/services/category/${category.id}');
                },
                borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                child: Padding(
                  padding: const EdgeInsets.all(AppSizes.paddingMd),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(category.icon, size: 48, color: category.color),
                      const SizedBox(height: AppSizes.paddingSm),
                      Text(
                        category.name,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppSizes.paddingXs),
                      Text(
                        '${category.servicesCount} servicios',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
