import 'package:flutter/material.dart';
import 'package:recurseo/core/constants/app_colors.dart';
import 'package:recurseo/core/constants/app_sizes.dart';
import 'package:recurseo/features/reviews/domain/entities/review_entity.dart';
import 'package:recurseo/features/reviews/presentation/widgets/rating_display.dart';

/// Card para mostrar una reseña
class ReviewCard extends StatelessWidget {
  final ReviewEntity review;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.review,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingMd),
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Avatar, nombre, fecha
            Row(
              children: [
                // Avatar
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.primaryLight,
                  backgroundImage: review.clientPhotoUrl != null
                      ? NetworkImage(review.clientPhotoUrl!)
                      : null,
                  child: review.clientPhotoUrl == null
                      ? Text(
                          review.clientName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: AppSizes.paddingSm),

                // Nombre y fecha
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            review.clientName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          if (review.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified,
                              size: 16,
                              color: AppColors.success,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        review.timeAgo,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                // Menú de opciones (si es editable)
                if (onEdit != null || onDelete != null)
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) {
                        onEdit!();
                      } else if (value == 'delete' && onDelete != null) {
                        onDelete!();
                      }
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Editar'),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Eliminar', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: AppSizes.paddingSm),

            // Rating
            RatingDisplay(
              rating: review.rating.toDouble(),
              showNumber: false,
              size: 18,
            ),
            const SizedBox(height: AppSizes.paddingSm),

            // Comentario
            Text(
              review.comment,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget para mostrar resumen de estadísticas de reseñas
class ReviewsStatsWidget extends StatelessWidget {
  final double averageRating;
  final int totalReviews;
  final int verifiedReviews;

  const ReviewsStatsWidget({
    super.key,
    required this.averageRating,
    required this.totalReviews,
    required this.verifiedReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.paddingMd),
        child: Row(
          children: [
            // Rating grande
            Column(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                RatingDisplay(
                  rating: averageRating,
                  showNumber: false,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  '$totalReviews ${totalReviews == 1 ? "reseña" : "reseñas"}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(width: AppSizes.paddingLg),

            // Información adicional
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (verifiedReviews > 0)
                    Row(
                      children: [
                        const Icon(
                          Icons.verified,
                          size: 16,
                          color: AppColors.success,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$verifiedReviews ${verifiedReviews == 1 ? "reseña verificada" : "reseñas verificadas"}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  const SizedBox(height: 8),
                  Text(
                    '${((totalReviews > 0 ? (totalReviews - verifiedReviews) / totalReviews : 0) * 100).toStringAsFixed(0)}% recomendarían este servicio',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
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
}
